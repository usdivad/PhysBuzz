using UnityEngine;
using System.Collections;

public class Rocket : MonoBehaviour {
	// fly speed (used by the weapon later)
	public float speed = 2000.0f;

	// explosiont prefab (particles)
	public GameObject explosionPrefab;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// when it hits something
	void OnCollisionEnter(Collision c) {
		// show an explosion
		Instantiate (explosionPrefab,
		             transform.position, // where the rocket is
		             Quaternion.identity); // default rotation

		// destroy the rocket
		// Destroy(this) destroys rocket script, Destroy(gameObject) destroys the entire object
		Destroy (gameObject);
	}
}
