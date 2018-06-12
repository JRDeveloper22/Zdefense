using UnityEngine;
using System.Collections;

public interface IPool 
{
    PoolObject GetItem();
    void ReturnItem(IPoolable item);
    GameObject GetPrefab();
}
