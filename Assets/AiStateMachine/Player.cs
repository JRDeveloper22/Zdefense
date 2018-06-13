using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

    private Animator playerAnim = null;
    private float speed = 1.0f;
    private int ActiveGun = 0;
    private float TimeBetweenBullets = .15f;
    protected int phealth = 100;

    private float timer;
    public GameObject ACW_R = null;
    public GameObject M4A1 = null;
    public Transform Acw_rT = null;
    public Transform M4A1T = null;
    public GameObject bullet= null;
    public float Bulletspeed = 6f;
    
    public float mouseSpeed = 3f;
    public Transform player;
    public Camera cam;
    


	void Start ()
    {
        playerAnim = GameObject.FindGameObjectWithTag("Player").GetComponent<Animator>();
        M4A1.SetActive(false);
        ACW_R.SetActive(true);
	}
	
	// Update is called once per frame
	void Update ()
    {
        timer += Time.deltaTime;
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
        else if (Input.GetButtonDown("Fire1"))
        {
            Debug.Log("Im pressing LMB");
            playerAnim.SetBool("Firing",true);
            if (timer >= TimeBetweenBullets)
            {
                CheckToFire();
            }
        }
        else if (Input.GetButtonUp("Fire1"))
        {
            Debug.Log("Im letting LMB go");
            playerAnim.SetBool("Firing", false);
        }
        MouseMovement();
	}

    void SwitchActive()
    {
        if (M4A1.activeSelf == true)
        {
            M4A1.SetActive(false);
            ACW_R.SetActive(true);
            ActiveGun = 0;
        }
        else if (ACW_R.activeSelf == true)
        {
            M4A1.SetActive(true);
            ACW_R.SetActive(false);
            ActiveGun = 1;
        }
    }
    void MouseMovement()
    {
        
        float X = Input.GetAxis("Mouse X") * mouseSpeed;
        //float Y = Input.GetAxis("Mouse Y") * mouseSpeed;

        player.Rotate(0,X,0);// Makeshift Rotate player Char


    }
    void CheckToFire()
    {
        if (ActiveGun == 0)
        {
            FireBullet(Acw_rT);
        }
        else if (ActiveGun == 1)
        {
            FireBullet(M4A1T);
        }
    }
    void FireBullet(Transform t)
    {
        // reset the time to fire
        timer = 0;
        //making GameObject Bullet spawn
        GameObject bull = (GameObject)Instantiate(bullet, t.position, t.rotation);

        // making bullet go
        bull.GetComponent<Rigidbody>().velocity = bull.transform.forward * Bulletspeed;

        //Kill the bullet After 2 seconds
        Destroy(bullet, 2.0f);

    }
}
