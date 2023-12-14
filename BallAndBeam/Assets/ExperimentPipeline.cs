using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ExperimentPipeline : MonoBehaviour
{
    // objects that need to be kept track of in the experiment
    public GameObject beam;
    public GameObject ball;
    public TextMeshPro tmp;

    // time duration constants for commencing experiment
    public float initialWait = 5.0f;
    public float interPhaseWait = 30.0f;
    public float interTrialWait = 3.0f;

    // misc variables for state tracking
    public float startTime = 0f;
    public enum ExperimentState 
    {
        NotStarted,
        StartingPhase,
        RunningPhase,
        PhaseBreak,
        End
    }
    public ExperimentState state;
    public enum TrialState
    {
        TrialStart,
        TrialRunning,
        TrialEnd
    }
    public TrialState trialState;
    public int phase = 0;
    public int trialsPerPhase = 10;

    // Start is called before the first frame update
    void Start()
    {
        tmp.text = "Move your hands under the beam, pick it up, and press both triggers simultaneously to begin";
        state = ExperimentState.NotStarted;
        trialState = TrialState.TrialStart;
        ball.GetComponent<Rigidbody>().isKinematic = true;
    }

    // Update is called once per frame
    void Update()
    {
        // check if the triggers have been pressed and the beam has been picked up
        switch(state)
        {
            case ExperimentState.NotStarted: 
                NotStarted();
                break;
            case ExperimentState.StartingPhase:
                StartingPhase();
                break;
            case ExperimentState.RunningPhase:
                RunningPhase();
                break;
            case ExperimentState.PhaseBreak:
                PhaseBreak();
                break;
            case ExperimentState.End:
                End();
                break;
            default: break;
        }

    }

    void NotStarted()
    {
        if (beam.GetComponent<hapticFeedback>().leftHandIsHoldingBeam && beam.GetComponent<hapticFeedback>().rightHandIsHoldingBeam) 
        {
            state = ExperimentState.StartingPhase;
            phase = 1;
            startTime = Time.time;
        }
    }

    void StartingPhase()
    {
        // begin trial in initialWait seconds
        float remainingTime = initialWait - (Time.time - startTime); 
        tmp.text = "Beginning phase " + phase + " in " + remainingTime.ToString("n2") + "s";
        if (remainingTime <= 0.0f) 
        {
            state = ExperimentState.RunningPhase;
            ball.GetComponent<Rigidbody>().isKinematic = false;
        }
    }

    void RunningPhase()
    {
        // display the current score
        int fail = ball.GetComponent<Balance>().fail;
        int score = ball.GetComponent<Balance>().success;
        int remaining = trialsPerPhase - fail - score;
        tmp.text = "Fail: " + fail + " | " + "Score: " + score + " | " + "Remaining: " + remaining;
        
        // check if between trials
        switch (trialState)
        {
            case TrialState.TrialStart: 
                TrialStarting();
                break;
            case TrialState.TrialRunning:
                break;
            case TrialState.TrialEnd:
                TrialEnd();
                break;
            default: break;
        }

        // stuff related to end of phase
        if (remaining == 0 && phase != 3)
        {
            state = ExperimentState.PhaseBreak;
            startTime = Time.time;
            ball.GetComponent<Balance>().ClearSuccessAndFail();
        } 
        else if (remaining == 0 && phase == 3)
        {
            state = ExperimentState.End;
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
            state = ExperimentState.StartingPhase;
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
        if (remainingTime <= 0.0f) 
        {
            trialState = TrialState.TrialRunning;
            ball.GetComponent<Rigidbody>().isKinematic = false;
        }
    }

    void TrialEnd()
    {
        // freeze ball and switch states
        ball.GetComponent<Rigidbody>().isKinematic = true;
        trialState = TrialState.TrialStart;
        // start timer
        startTime = Time.time;
    }
}
