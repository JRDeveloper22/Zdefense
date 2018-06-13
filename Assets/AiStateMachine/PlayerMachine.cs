using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMachine : MonoBehaviour
{
    public UnityEngine.AI.NavMeshAgent agent { get; private set; }
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
    //bullet//
    public GameObject BulletPrefab = null;
    public float Bulletspeed = 6f;
    public PoolManager poolManager;
    //
    public float mouseSpeed = 3f;
    public Transform PlayerRotate;
    // Use this for initialization
    void Awake()
    {
        agent = GetComponentInChildren<UnityEngine.AI.NavMeshAgent>();
        agent.updatePosition = true;
        agent.updateRotation = false;

        PlayerRotate = gameObject.GetComponent<Transform>();
        playerAnim = GameObject.FindGameObjectWithTag("Player").GetComponent<Animator>();
        poolManager = FindObjectOfType<PoolManager>();
    }
    void Update()
    {
        Vector3 foward = transform.forward * Time.deltaTime * speed;
        timer += Time.deltaTime;
        if (Input.GetKeyDown(KeyCode.W))
        {
            playerAnim.SetFloat("Speed", speed);
            agent.Move(foward);
        }
        else if (Input.GetKeyUp(KeyCode.W))
        {
            playerAnim.SetFloat("Speed", 0.0f);
        }
        else if (Input.GetKeyDown(KeyCode.E))
        {
            SwitchActive();
            Debug.Log("I am Switching Guns");
        }
        else if (Input.GetButtonDown("Fire1"))
        {
            Debug.Log("Im pressing LMB");
            playerAnim.SetBool("Firing", true);
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
    void MouseMovement()
    {
        float x = Input.GetAxis("Mouse X") * 3f;
        PlayerRotate.Rotate(0, x, 0);
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
    void FireBullet(Transform BulletSpawnLocation)
    {
        // reset the time to fire
        timer = 0;
        PoolObject item = poolManager.GetItem(BulletPrefab);
        GameObject obj = item.gameObject;
        Bullet bullet = obj.GetComponent<Bullet>();
        //GunAnim.Play("Fire");

        bullet.enabled = true;
        bullet.lastpos = BulletSpawnLocation.position;
        bullet.Rigidbody.isKinematic = false;

        obj.SetActive(true);
        bullet.Rigidbody.AddForce(BulletSpawnLocation.forward * Bulletspeed);
        bullet.transform.position = new Vector3(BulletSpawnLocation.transform.position.x,
                                                BulletSpawnLocation.transform.position.y,
                                                BulletSpawnLocation.transform.position.z);

    }
}
