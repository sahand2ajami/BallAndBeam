using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class Logger : MonoBehaviour
{
// path: C:\Users\s2ajami\OneDrive - University of Waterloo\BallAndBeam-project\BallAndBeam\data
    public string dir = "C:\\Users\\s2ajami\\Desktop\\data\\";
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void WriteCSV(string filename, int success, int totalSuccess, int fail, int totalFail, int trialNumber, int phaseNumber)
    {   
        bool exists = false;
        if (File.Exists(dir + filename + ".csv")){
            exists = true;
        }
        using(StreamWriter sw = File.AppendText(dir + filename + ".csv"))
        {        
            //DateTime now = DateTime.Now;
            if (!exists) 
            { 
                sw.WriteLine("success,totalSuccess,fail,totalFail,trialNumber,phaseNumber");
            }
            sw.WriteLine(success + "," + totalSuccess + "," + fail + "," + totalFail + "," + trialNumber + "," + phaseNumber);
        }
    }
    
    public void WriteCSVPositions(string filename, Vector3 position, int trialNumber, int phaseNumber)
    {   
        bool exists = false;
        if (File.Exists(dir + filename + ".csv")){
            exists = true;
        }
        using(StreamWriter sw = File.AppendText(dir + filename + ".csv"))
        {        
            //DateTime now = DateTime.Now;
            if (!exists) 
            { 
                sw.WriteLine("X,Y,Z,trialNumber,phaseNumber");
            }
            sw.WriteLine(position.x + "," + position.y + "," + position.z + "," + trialNumber+ "," + phaseNumber);
        }
        // sw.Close();
    }


public void WriteCSVTime(string filename, float time, int trialNumber, int phaseNumber)
    {   
        bool exists = false;
        if (File.Exists(dir + filename + ".csv")){
            exists = true;
        }
        using(StreamWriter sw = File.AppendText(dir + filename + ".csv"))
        {        
            //DateTime now = DateTime.Now;
            if (!exists) 
            { 
                sw.WriteLine("time,trialNumber,phaseNumber");
            }
            sw.WriteLine(time + "," + trialNumber+ "," + phaseNumber);
        }
        // sw.Close();
    }

    public void WriteCSVList(string filename, float trackingTime, int trialNumber, int phaseNumber)
    {   
        bool exists = false;
        if (File.Exists(dir + filename + ".csv")){
            exists = true;
        }
        using(StreamWriter sw = File.AppendText(dir + filename + ".csv"))
        {        
            //DateTime now = DateTime.Now;
            if (!exists) 
            { 
                sw.WriteLine("trackingTime,trialNumber,phaseNumber");
            }
            sw.WriteLine(trackingTime + "," + trialNumber + "," + phaseNumber);
            
            // sw.WriteLine(success + "," + totalSuccess + "," + fail + "," + totalFail + "," + trialNumber + "," + phaseNumber);
        }
    }
}
