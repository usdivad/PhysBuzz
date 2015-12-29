using UnityEngine;
using System.Collections;

namespace PhysBuzz
{
	public class Rocket : MonoBehaviour {
		// fly speed (used by the weapon later)
		public float speed;
		public float testVar = 1.0f;

		// explosiont prefab (particles)
		public GameObject explosionPrefab;

		// player
		public GameObject player;

		// Use this for initialization
		void Start () {
			speed = Random.Range (100.0f, 2000.0f);
			//print(speed);
			player = GameObject.Find ("Player");
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

			// osc
			Vector3 distance = transform.position - player.transform.position;
			print ("rocket distance:" + distance);
			OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz/Explode", distance);
		}
	}
}