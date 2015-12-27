using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using System.Net;

namespace PhysBuzz
{
	public class Shoot : MonoBehaviour {
		// rocket prefab
		public GameObject rocketPrefab;

		// Use this for initialization
		void Start () {
		
		}
		
		// Update is called once per frame
		void Update () {
			if (Input.GetMouseButtonDown (0)) {
				GameObject g = (GameObject)Instantiate(rocketPrefab,
				                                       transform.position, // exactly where the weapon is
				                                       transform.parent.rotation); // face same direction player (weapon's parent) faces

				// make rocket fly fwd by calling rigidbody's AddForce method
				// (requires rocket to have rigidbody attached to it)
				float force = g.GetComponent<Rocket>().speed;
				g.GetComponent<Rigidbody>().AddForce(g.transform.forward * force);

				List<object> values = new List<object>();
				values.AddRange (new object[] {transform.position.x, transform.position.y, transform.position.z});
//				values.Add (transform.parent.rotation);
//				values.Add (force);

				
				// OSCHandler.Instance.UpdateLogs();
				 OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz", values);
//				OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz", transform.position.x);
			}
		}
	}
}