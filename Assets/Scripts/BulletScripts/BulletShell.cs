using UnityEngine;
using System.Collections;

public class BulletShell : MonoBehaviour
{
    public ParticleSystem ps;
  

    public void Eject ()
    {
        ps.Emit(1);
	}
}
