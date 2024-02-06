using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ExperimentPipelineDynamic : MonoBehaviour
{
    // objects that need to be kept track of in the experiment
    public GameObject beam;
    public GameObject ball;
    public TextMeshPro tmp;

    public TextMeshPro go_plane;
    public Logger logger;

    public Communications communications;

    public GameObject left_hand;
    public GameObject right_hand;

    public GameObject horizontal_beam;
    public GameObject leftHandModelRenderer;
    public GameObject rightHandModelRenderer;
    public GameObject lamp;
    // time duration constants for commencing experiment
    public float initialWait = 5.0f;
    public float interPhaseWait = 30.0f;
    public float interTrialWait = 60.0f;

    public float ready_time = 3.0f;
    // misc variables for state tracking
    public float startTime = 0f;
    public enum ExperimentStateDynamic 
    {
        NotStarted,
        StartingPhase,
        RunningPhase,
        PhaseBreak,
        End
    }
    public ExperimentStateDynamic state;
    public enum TrialStateDynamic
    {
        TrialStart,
        TrialRunning,
        TrialEnd
    }
    public TrialStateDynamic trialState;
    public hapticFeedback hapticFeedback;
    public int phase = 0;
    public int trialsPerPhase = 10;


    // Start is called before the first frame update
    void Start()
    {
        tmp.text = "Move your hands under the beam, pick it up, and press both triggers simultaneously to begin";
        state = ExperimentStateDynamic.NotStarted;
        trialState = TrialStateDynamic.TrialStart;
        ball.GetComponent<Rigidbody>().isKinematic = true;
        
    }

    // Update is called once per frame
    void Update()
    {
        // check if the triggers have been pressed and the beam has been picked up
        switch(state)
        {
            case ExperimentStateDynamic.NotStarted: 
                NotStarted();
                break;
            case ExperimentStateDynamic.StartingPhase:
                StartingPhase();
                break;
            case ExperimentStateDynamic.RunningPhase:
                RunningPhase();
                break;
            case ExperimentStateDynamic.PhaseBreak:
                PhaseBreak();
                break;
            case ExperimentStateDynamic.End:
                End();
                break;
            default: break;
        }

    }

    void NotStarted()
    {
        // communications.Log(communications.serial_port, "b"); //End recording
        if (beam.GetComponent<hapticFeedback>().leftHandIsHoldingBeam && beam.GetComponent<hapticFeedback>().rightHandIsHoldingBeam) 
        {
            state = ExperimentStateDynamic.StartingPhase;
            // phase = 1;
            startTime = Time.time;
        }
    }

    void StartingPhase()
    {
        // communications.Log(communications.serial_port, "c"); //Start recording
        // begin trial in initialWait seconds
        float remainingTime = initialWait - (Time.time - startTime); 
        tmp.text = "Beginning phase " + phase + " in " + remainingTime.ToString("n2") + "s";
        if (phase == 2 || phase == 4)
        {
            hapticFeedback.hapticsEnabled = true;
        }
        else
        {
            hapticFeedback.hapticsEnabled = false;
        }
        if (phase == 1 || phase == 2)
        {
            hapticFeedback.yShift = 1000000000000;
        }
        else
        {

        }

        if (remainingTime <= 0.0f) 
        {
            state = ExperimentStateDynamic.RunningPhase;
            trialState = TrialStateDynamic.TrialRunning;
            ball.GetComponent<Rigidbody>().isKinematic = false;
            ball.GetComponent<BalanceDynamic>().targetMovementStartTime = Time.time;
            // communications.Log(communications.serial_port, "b"); //End recording
        }
    }

    void RunningPhase()
    {
        
        // display the current score
        int fail = ball.GetComponent<BalanceDynamic>().fail;
        int score = ball.GetComponent<BalanceDynamic>().success;
        int remaining = trialsPerPhase - fail - score;
        // tmp.text = "Fail: " + fail + " | " + "Score: " + score + " | " + "Remaining: " + remaining;
        tmp.text = "Remaining: " + remaining;
        
        // check if between trials
        switch (trialState)
        {
            case TrialStateDynamic.TrialStart: 
                TrialStarting();
                break;
            case TrialStateDynamic.TrialRunning:
                TrialRunning(trialsPerPhase - remaining + 1);
                break;
            case TrialStateDynamic.TrialEnd:
                TrialEnd(trialsPerPhase - remaining);
                break;
            default: break;
        }

        // stuff related to end of phase
        if (remaining == 0 && phase != 4)
        {
            state = ExperimentStateDynamic.PhaseBreak;
            startTime = Time.time;
            ball.GetComponent<BalanceDynamic>().ClearSuccessAndFail();
        } 
        else if (remaining == 0 && phase == 4)
        {
            state = ExperimentStateDynamic.End;
        }
    }

    void PhaseBreak()
    {
        // disable ball physics
        ball.GetComponent<Rigidbody>().isKinematic = true;
        // display a countdown for resting
        float remainingTime = interPhaseWait - (Time.time - startTime);
        tmp.text = "Rest for " + remainingTime.ToString("n2") + "s";
        
        if (remainingTime <= 0.0f)
        {
            phase += 1;
            state = ExperimentStateDynamic.StartingPhase;
        }
    }

    void End()
    {
        // print a closing message and freeze the ball
        ball.GetComponent<Rigidbody>().isKinematic = true;
        tmp.text = "The experiment is over.";
    }

    void TrialStarting()
    {
        // begin trial in initialWait seconds
        float remainingTime = interTrialWait - (Time.time - startTime); 
        tmp.text = "Next trial in " + remainingTime.ToString("n2") + "s";
        if (remainingTime <= ready_time)
        {
            // Get the Renderer component from the new cube
            var lampRenderer = lamp.GetComponent<Renderer>();
            // Call SetColor using the shader property name "_Color" and setting the color to red
            lampRenderer.material.SetColor("_Color", Color.yellow);

            go_plane.text = "Ready";
            horizontal_beam.SetActive(true);
            // horizontal_beam.transform.position.y = beam.transform.position.y;
            horizontal_beam.transform.position = new Vector3 (beam.transform.position.x, beam.transform.position.y, beam.transform.position.z);
            Debug.Log("Ready: " + horizontal_beam.transform.position);
            // horizontal_beam.transform.position = new Vector3(horizontal_beam.transform.position.x - 2*1e6f, horizontal_beam.transform.position.y, horizontal_beam.transform.position.z);
        }
        if (remainingTime <= 0.0f) 
        {
            trialState = TrialStateDynamic.TrialRunning;
            ball.GetComponent<Rigidbody>().isKinematic = false;
            ball.GetComponent<BalanceDynamic>().targetMovementStartTime = Time.time;

            // SAHAND: CHECK THIS
            // Start recording EMG
            communications.Log(communications.serial_port, "c"); //Start recording

            // Get the Renderer component from the new cube
            var lampRenderer = lamp.GetComponent<Renderer>();

            // Call SetColor using the shader property name "_Color" and setting the color to red
            lampRenderer.material.SetColor("_Color", Color.green);

            go_plane.text = "Go";
            // Debug.Log("Go: " + horizontal_beam.transform.position);
            horizontal_beam.SetActive(false);
            // horizontal_beam.transform.position = new Vector3(horizontal_beam.transform.position.x +1e6f, horizontal_beam.transform.position.y, horizontal_beam.transform.position.z);
        }
    }

    void TrialRunning(int trialNumber)
    {   
        logger.WriteCSV("scores", 
            ball.GetComponent<BalanceDynamic>().success,
            ball.GetComponent<BalanceDynamic>().totalSuccess,
            ball.GetComponent<BalanceDynamic>().fail, 
            ball.GetComponent<BalanceDynamic>().totalFail,
            trialNumber, phase);
        logger.WriteCSVPositions("ball", ball.transform.position, trialNumber, phase);
        logger.WriteCSVPositions("target", ball.GetComponent<BalanceDynamic>().target.transform.position, trialNumber, phase);
        logger.WriteCSVPositions("occluder", ball.GetComponent<BalanceDynamic>().occluder.transform.position, trialNumber, phase);
        logger.WriteCSVPositions("left_hand", left_hand.transform.position, trialNumber, phase);
        logger.WriteCSVPositions("right_hand", right_hand.transform.position, trialNumber, phase);
        logger.WriteCSVTime("time", Time.time - startTime, trialNumber, phase);

        // Get the Renderer component from the new cube
            var lampRenderer = lamp.GetComponent<Renderer>();

            // Call SetColor using the shader property name "_Color" and setting the color to red
            lampRenderer.material.SetColor("_Color", Color.green);

            go_plane.text = "Go";
            horizontal_beam.SetActive(false);
            Debug.Log("Go: " + horizontal_beam.transform.position);
    }

    void TrialEnd(int trialNumber)
    {
        // freeze ball and switch states
        // SAHAND: CHECK THIS
        communications.Log(communications.serial_port, "b");
        ball.GetComponent<Rigidbody>().isKinematic = true;
        trialState = TrialStateDynamic.TrialStart;
        // start timer
        startTime = Time.time;
        logger.WriteCSVList("trackingTimes", ball.GetComponent<BalanceDynamic>().trackingTimeList[^1], trialNumber, phase);

        // Get the Renderer component from the new cube
        var lampRenderer = lamp.GetComponent<Renderer>();

        // Call SetColor using the shader property name "_Color" and setting the color to red
        lampRenderer.material.SetColor("_Color", Color.red);

        go_plane.text = "Stop";
        // horizontal_beam.transform.position = new Vector3(horizontal_beam.transform.position.x + 1e6f, horizontal_beam.transform.position.y, horizontal_beam.transform.position.z
        Debug.Log("Stop: " + horizontal_beam.transform.position);
    }
}
