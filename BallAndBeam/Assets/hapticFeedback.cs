using System.Collections;
using System.Collections.Generic;
// using System.Mathf;
using UnityEngine;
using System.IO;
using Valve.VR;
using Valve.VR.InteractionSystem;

public class hapticFeedback : MonoBehaviour
{

    // misc constants
    public float yShift = 0f;
    public float zShift = 0f;

    // objects for the ball and table
    public GameObject ball;
    public GameObject table;

    // objects to perform interpolation for haptics
    public GameObject leftAnchor;
    public GameObject rightAnchor;

    // objects for hand model tracking
    public GameObject staticLeftHandModel;
    public GameObject staticRightHandModel;
    public GameObject leftHandModel;
    public GameObject rightHandModel;
    public GameObject staticLeftHandFollower;
    public GameObject staticRightHandFollower;

    // SteamVR stuff for API calls
    public SteamVR_Action_Vibration hapticAction;
    public SteamVR_Action_Single squeezeAction;

    public bool hapticsEnabled = false;
    public bool rightHandIsHoldingBeam = false;
    public bool leftHandIsHoldingBeam = false;
    public bool handsFound = false;
    public bool tableIsActive = true;

    // variables for position/rotation tracking once beam is held up
    public float sholderWidth = 0.46f; // * const
    public float leftHandYBaseline = 0f;
    public float rightHandYBaseline = 0f;

    // constants for haptic feedback
    public float amplitudeScalingFactor = 0.2f;
    public float frequencyScalingFactor = 1.0f;

    void CheckForHoldingBeam()
    {
        float triggerValueL = squeezeAction.GetAxis(SteamVR_Input_Sources.LeftHand);
        float triggerValueR = squeezeAction.GetAxis(SteamVR_Input_Sources.RightHand);
        if (triggerValueL > 0.0f)
        {
            leftHandIsHoldingBeam = true;
            staticLeftHandFollower.transform.position = new Vector3(-sholderWidth/2, staticLeftHandFollower.transform.position.y, staticLeftHandFollower.transform.position.z);
            leftHandYBaseline = leftHandModel.transform.position.y;
            // Debug.Log("left" + staticLeftHandFollower.transform.rotation);

        }
        if (triggerValueR > 0.0f)
        {
            rightHandIsHoldingBeam = true;
            staticRightHandFollower.transform.position = new Vector3(sholderWidth/2, staticRightHandFollower.transform.position.y, staticRightHandFollower.transform.position.z);
            rightHandYBaseline = rightHandModel.transform.position.y;

        }        
    }

    void UpdateStaticHands()
    {
        if (leftHandIsHoldingBeam && rightHandIsHoldingBeam) return;
        // render static hands
        staticLeftHandModel.transform.position = leftHandModel.transform.position;
        staticLeftHandModel.transform.rotation = leftHandModel.transform.rotation;
        Debug.Log("right" + staticLeftHandModel.transform.rotation);

        staticRightHandModel.transform.position = rightHandModel.transform.position;
        staticRightHandModel.transform.rotation = rightHandModel.transform.rotation;
    }

    void CheckForHandModels()
    {
        leftHandModel = GameObject.Find("/Player/HandColliderLeft(Clone)");
        rightHandModel = GameObject.Find("/Player/HandColliderRight(Clone)");
        handsFound = true;
    }

    void Update()
    {
        // disable the mesh renderers for hands (keep them active though, we need position to move the beam)
        GameObject rightHandMesh = GameObject.Find("/Player/SteamVRObjects/RightHand/RightRenderModel Slim(Clone)");
        GameObject leftHandMesh = GameObject.Find("/Player/SteamVRObjects/LeftHand/LeftRenderModel Slim(Clone)");
        rightHandMesh.SetActive(false);
        leftHandMesh.SetActive(false);

        // locate the hand collider models for static hand tracking
        if (!handsFound) CheckForHandModels();

        // if hands are not holding beam yet, update static hand positions
        if ((!leftHandIsHoldingBeam) || (!rightHandIsHoldingBeam)) 
        {
            CheckForHoldingBeam();
            UpdateStaticHands();
        }

        else
        {
            // disable the cube table
            if (tableIsActive)
            {
                // disable beam physics
                GetComponent<Rigidbody>().isKinematic = true;
                // remove table
                table.SetActive(false);
                tableIsActive = false;
                // disable hand finger colliders
                GameObject leftFingers = GameObject.Find("/Player/HandColliderLeft(Clone)/fingers");
                GameObject rightFingers = GameObject.Find("/Player/HandColliderRight(Clone)/fingers");
                leftFingers.SetActive(false);
                rightFingers.SetActive(false);
                // disable hand palm colliders
                GameObject leftPalm = GameObject.Find("/Player/HandColliderLeft(Clone)/sphere");
                GameObject rightPalm = GameObject.Find("/Player/HandColliderRight(Clone)/sphere");
                leftPalm.SetActive(false);
                rightPalm.SetActive(false);
            }
            // both hands are static and placed on the beam
            // 1. turn off physics for hands
            leftHandModel.GetComponent<HandCollider>().enabled = false;
            rightHandModel.GetComponent<HandCollider>().enabled = false;
            // 2. move the static hands to the position of the followers
            staticLeftHandModel.transform.position = new Vector3(staticLeftHandFollower.transform.position.x, staticLeftHandFollower.transform.position.y - yShift, staticLeftHandFollower.transform.position.z - zShift);
            staticLeftHandModel.transform.rotation = staticLeftHandFollower.transform.rotation;
            staticRightHandModel.transform.position = new Vector3(staticRightHandFollower.transform.position.x, staticRightHandFollower.transform.position.y - yShift, staticRightHandFollower.transform.position.z - zShift);
            staticRightHandModel.transform.rotation = staticRightHandFollower.transform.rotation;
            // 3. draw a vector connecting the two hands' y positions
            Vector2 handVector = new Vector2(rightHandModel.transform.position.x - leftHandModel.transform.position.x, rightHandModel.transform.position.y - leftHandModel.transform.position.y);
            transform.eulerAngles = new Vector3(0, 0, Mathf.Rad2Deg * Mathf.Atan(handVector.y / handVector.x));
            if (hapticsEnabled) RenderHaptics();
        }
    }

    void RenderHaptics()
    {
        // parameters for API call
        float secondsFromNow = 0f;
        float duration = 1/60.0f;
        float frequency = 100f;
        float leftAmplitude = 0f;
        float rightAmplitude = 0f;
        float amplitudeFactor = 0.8f;
        // compute lerp for position of ball
        // 1. distance between the two anchors
        float distanceBetweenAnchors = Vector3.Distance(leftAnchor.transform.position, rightAnchor.transform.position);
        // 2. distance between the left anchor and the ball
        float distanceBetweenLeftAndBall = Vector3.Distance(leftAnchor.transform.position, ball.transform.position);
        // 3. distance between the right anchor and the ball
        float distanceBetweenRightAndBall = distanceBetweenAnchors - distanceBetweenLeftAndBall;
        // 4. on the left hand: Right-Ball Distance / Left-Right Distance * ALPHA
        leftAmplitude = Mathf.Log(distanceBetweenRightAndBall + 1) * amplitudeFactor;
        // 5. on the right hand: Left-Ball Distance / Left-Right Distance * ALPHA
        rightAmplitude = Mathf.Log(distanceBetweenLeftAndBall + 1) * amplitudeFactor; 
        // first, render haptics for the left hand
        hapticAction.Execute(secondsFromNow, duration, frequency, leftAmplitude, SteamVR_Input_Sources.LeftHand);
        // then, render haptics for the right hand
        hapticAction.Execute(secondsFromNow, duration, frequency, rightAmplitude, SteamVR_Input_Sources.RightHand);
    }

}
