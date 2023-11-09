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

    // Start is called before the first frame update
    void Start()
    {
        // when the scene begins, make sure that the ball is on the beam 
        ResetToBeam();
    }

    void Update()
    {
        // detect if the ball is on the target
        if (Vector3.Distance(transform.position, target.transform.position) <= 0.021f)
        {
            success += 1;
            RespawnTarget();
            ResetToBeam();
        }
    }

    void ResetToBeam()
    {
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
        }
    }

}
