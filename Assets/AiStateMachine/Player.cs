using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

    private Animator playerAnim = null;
    private float speed = 1.0f;

    public GameObject ACW_R = null;
    public GameObject M4A1 = null;



	void Start ()
    {
        playerAnim = GameObject.FindGameObjectWithTag("Player").GetComponent<Animator>();
        M4A1.SetActive(false);
        ACW_R.SetActive(true);
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyDown(KeyCode.W))
            playerAnim.SetFloat("Speed", speed);
        else if (Input.GetKeyUp(KeyCode.W))
            playerAnim.SetFloat("Speed", 0.0f);
        else if (Input.GetKeyDown(KeyCode.R))
        {
            playerAnim.SetTrigger("Reloading");
            Debug.Log("I am reloading");
        }
        else if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("I jumped");
            playerAnim.SetTrigger("Jump");
        }
        else if (Input.GetKeyDown(KeyCode.E))
        {
            SwitchActive();
            Debug.Log("I am Switching Guns");
        }

        ;
	}

    void SwitchActive()
    {
        if (M4A1.activeSelf == true)
        {
            M4A1.SetActive(false);
            ACW_R.SetActive(true);
        }
        else if (ACW_R.activeSelf == true)
        {
            M4A1.SetActive(true);
            ACW_R.SetActive(false);
        }
    }
}
