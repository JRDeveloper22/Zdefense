using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : IActable
{

    public GameObject BulletPrefab;
    public Transform BulletSpawnLocation;

    public float MinSpeed = 1000;
    public float MaxSpeed = 1000;

    public int bullets;
    public int maxBullets = 20;

    public PoolManager poolManager;
    //Animator GunAnim;
    void Start()
    {
        bullets = maxBullets;
        //poolManager = FindObjectOfType<PoolManager>();
    }
    public void Fire()
    {
       if(bullets > 0)
        {
            --bullets;
            float Speed = Random.Range(MinSpeed, MaxSpeed);
            PoolObject item = poolManager.GetItem(BulletPrefab);
            GameObject obj = item.gameObject;
            Bullet bullet = obj.GetComponent<Bullet>();
            //GunAnim.Play("Fire");

            bullet.enabled = true;
            bullet.lastpos = BulletSpawnLocation.position;
            bullet.Rigidbody.isKinematic = false;
            bullet.Trail.enabled = true;
            obj.SetActive(true);
            bullet.Rigidbody.AddForce(BulletSpawnLocation.forward * Speed);
            bullet.transform.position = new Vector3(BulletSpawnLocation.transform.position.x,
                                                    BulletSpawnLocation.transform.position.y,
                                                    BulletSpawnLocation.transform.position.z);
        }
    }
    public void ActionStart()
    {
        Fire();
    }
    public void ActionStop()
    {

    }
}
