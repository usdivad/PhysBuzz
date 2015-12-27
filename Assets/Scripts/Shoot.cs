using UnityEngine;
using System.Collections;

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
		}
	}
}
