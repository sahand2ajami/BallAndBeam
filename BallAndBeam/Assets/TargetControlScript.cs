using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetControlScript : MonoBehaviour
{
    public GameObject ball;
    public int success = 0;

    void ResetTargetPosition()
    {
        float randomXPosition = Random.Range(-0.5f, 0.5f);
        transform.localPosition = new Vector3(randomXPosition, transform.localPosition.y, transform.localPosition.z);
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == ball.name)
        {
            success += 1;
            ResetTargetPosition();
        }
        
    }
}
