using UnityEngine;
using System.Collections;
using System.IO.Ports;
using System.Threading;

public class Communications : MonoBehaviour
{
    public string portName;
    public SerialPort serial_port;



    void Start()
    {
        portName = "COM10";
        serial_port = new SerialPort(portName, 9600);
    }

    public void Log(SerialPort serial_port, string input)
    {
        if (input == "c")
        {
            Debug.Log("Recording Started");
        }
        else if (input == "b")
        {
            Debug.Log("Recording Stopped");
        }
        serial_port.Open();
        serial_port.Write(input);
        serial_port.Close();
    }

}