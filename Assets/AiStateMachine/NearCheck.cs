using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NearCheck : MonoBehaviour {

    public GameObject Zombie;
    ZombieMachine Zmachine;

    void OnTriggerStay(Collider other)
    {
        if(other.tag == "Zombie")
        {
            Zmachine = other.GetComponent<ZombieMachine>();
            Zmachine.isNear = true;
        }
    }
    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Zombie")
        {
            Zmachine = other.GetComponent<ZombieMachine>();
            Zmachine.isNear = false;
        }
    }
}
