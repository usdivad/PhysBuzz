using UnityEngine;
using System.Collections;
using UnityStandardAssets.Characters.FirstPerson;

namespace PhysBuzz
{
	public class Audio : MonoBehaviour {

		// Use this for initialization
		void Start () {
			OSCHandler.Instance.Init ();
		}
		
		// Update is called once per frame
		void Update () {
			OSCHandler.Instance.UpdateLogs ();
		}
	}
}