using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Balance : MonoBehaviour
{

    public GameObject plane;
    public GameObject beam;
    public GameObject target;

    public int fail = 0;
    public int success = 0;

    public int totalFail = 0;
    public int totalSuccess = 0;

    public bool targetTimerStarted = false;
    public float startTime = 0f;
    public float timeThreshold = 1f;

    public GameObject experiment;

    // Start is called before the first frame update
    void Start()
    {
        // when the scene begins, make sure that the ball is on the beam 
        ResetToBeam();
    }

    void Update()
    {
        // detect if the ball is on the target
        if (Vector3.Distance(transform.position, target.transform.position) <= 0.021f && !targetTimerStarted)
        {
            StartTimer();
        }
        if (Vector3.Distance(transform.position, target.transform.position) <= 0.021f && targetTimerStarted && TimeThresholdMet())
        {
            success += 1;
            RespawnTarget();
            ResetToBeam();
            experiment.GetComponent<ExperimentPipeline>().trialState = ExperimentPipeline.TrialState.TrialEnd;
        }
        if (Vector3.Distance(transform.position, target.transform.position) > 0.021f && targetTimerStarted)
        {
            // we want continuous holding
            ResetTimer();
        }

    }

    void StartTimer()
    {
        startTime = Time.time;
        targetTimerStarted = true;
    }

    void ResetTimer()
    {
        startTime = 0;
        targetTimerStarted = false;
    }

    bool TimeThresholdMet()
    {
        float timeElapsed = Time.time - startTime;
        return (timeElapsed >= timeThreshold);
    }

    void ResetToBeam()
    {
        // position the ball on the beam
        transform.position = new Vector3(beam.transform.position.x, beam.transform.position.y + 0.017f, beam.transform.position.z);
    }

    void RespawnTarget()
    {
        float xPosition = Random.Range(-0.48f, 0.48f);
        target.transform.localPosition = new Vector3(xPosition, target.transform.localPosition.y, target.transform.localPosition.z);
        //target.transform.localEulerAngles = beam.transform.localEulerAngles;
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == plane.name)
        {
            // count a fail
            fail += 1;
            ResetToBeam();
            experiment.GetComponent<ExperimentPipeline>().trialState = ExperimentPipeline.TrialState.TrialEnd;
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
