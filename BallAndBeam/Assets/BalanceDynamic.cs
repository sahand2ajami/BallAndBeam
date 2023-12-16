using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BalanceDynamic : MonoBehaviour
{

    public GameObject plane;
    public GameObject beam;
    public GameObject target;
    public GameObject occluder;

    public float occluderSpan = 0.015f;

    public int fail = 0;
    public int success = 0;

    public int totalFail = 0;
    public int totalSuccess = 0;

    public bool occlusionEnabled = false;
    public bool targetTimerStarted = false;
    public float targetMovementStartTime = 0f;
    public float startTime = 0f;
    public float timeSoFar = 0f;
    public float timeThreshold = 3f;
    public List<float> trackingTimeList;
    public float angularVelocity = 0.33f;
    public float timePeriod = 6f;
    public float targetMovementAmplitude = 0.4f;

    public GameObject experiment;

    // Start is called before the first frame update
    void Start()
    {
        // when the scene begins, make sure that the ball is on the beam 
        ResetToBeam();
        // apply the occluder size hyperparameter (only affects the x span)
        occluder.transform.localScale = new Vector3(occluderSpan, 1.0f, 2.74f);
        // clear the time accumulator
        timeSoFar = 0f;
        // position the occluder outside the center strip
        if (occlusionEnabled)
        {

            float newOccluderXPosition = Random.Range(0f, 1f) <= 0.5f ? Random.Range(-0.35f, -0.25f) : Random.Range(0.25f, 0.35f);
            occluder.transform.position = new Vector3(newOccluderXPosition, beam.transform.position.y, occluder.transform.position.z);
        }
    }

    void Update()
    {
        if (experiment.GetComponent<ExperimentPipelineDynamic>().state == ExperimentPipelineDynamic.ExperimentStateDynamic.RunningPhase)
            {
            // detect if the ball is on the target
            if (Vector3.Distance(transform.position, target.transform.position) <= 0.021f && !targetTimerStarted)
            {
                StartTimer();
            }
            if (Vector3.Distance(transform.position, target.transform.position) > 0.021f && targetTimerStarted)
            {
                // we want continuous holding
                PauseTimer();
            }
            if (TimeThresholdMet())
            {
                Debug.Log("Entered success and threshold met.");
                success += 1;
                PauseTimer();
                ResetTimer();
                ResetToBeam();
                RespawnTarget();
                experiment.GetComponent<ExperimentPipelineDynamic>().trialState = ExperimentPipelineDynamic.TrialStateDynamic.TrialEnd;
            }
            else
            {
                // we move the target per a sinusoid
                UpdateTargetPosition();
            }
        }
    }

    void StartTimer()
    {
        startTime = Time.time;
        targetTimerStarted = true;
    }

    void PauseTimer()
    {
        timeSoFar += Time.time - startTime;
        targetTimerStarted = false;
    }

    void ResetTimer()
    {
        trackingTimeList.Add(timeSoFar);
        startTime = 0;
        timeSoFar = 0;
        targetTimerStarted = false;
    }

    bool TimeThresholdMet()
    {
        //Debug.Log("Time elapsed: " + (Time.time - targetMovementStartTime));
        return ((Time.time - targetMovementStartTime) > timePeriod) && (experiment.GetComponent<ExperimentPipelineDynamic>().trialState == ExperimentPipelineDynamic.TrialStateDynamic.TrialRunning);
    }

    void ResetToBeam()
    {
        // position the ball on the beam
        transform.position = new Vector3(beam.transform.position.x, beam.transform.position.y + 0.017f, beam.transform.position.z);
    }

    void RespawnTarget()
    {
        //float xPosition = Random.Range(-0.48f, 0.48f);
        float xPosition = Random.Range(-0.01f, 0.01f);
        target.transform.localPosition = new Vector3(xPosition, target.transform.localPosition.y, target.transform.localPosition.z);
        //target.transform.localEulerAngles = beam.transform.localEulerAngles;
        if (occlusionEnabled)
        {
            float newOccluderXPosition = Random.Range(-0.3f, 0.3f);
            occluder.transform.position = new Vector3(newOccluderXPosition, beam.transform.position.y, occluder.transform.position.z);
        }
    }

    void UpdateTargetPosition()
    {
        // x = A sin(wt)
        // A = 0.4
        // period = 6 sec
        target.transform.localPosition = new Vector3(targetMovementAmplitude * Mathf.Sin((Time.time - targetMovementStartTime) * angularVelocity * 3.14159f), target.transform.localPosition.y, target.transform.localPosition.z);
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == plane.name)
        {
            // count a fail
            fail += 1;
            PauseTimer();
            ResetTimer();
            ResetToBeam();
            RespawnTarget();
            experiment.GetComponent<ExperimentPipelineDynamic>().trialState = ExperimentPipelineDynamic.TrialStateDynamic.TrialEnd;
        }
    }

    public void ClearSuccessAndFail()
    {
        totalFail += fail;
        totalSuccess += success;
        fail = 0;
        success = 0;
    }

}
