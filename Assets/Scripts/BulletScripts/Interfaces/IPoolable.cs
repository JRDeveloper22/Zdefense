using UnityEngine;
using System.Collections;

public interface IPoolable
{
    void Begin(IPool myPool);
    void End();
    GameObject GetSource();
}
