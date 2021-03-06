﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

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

		public Stats gameStats;

		// Use this for initialization
		void Start () {
			// speed = Random.Range (100.0f, 2000.0f);
			//print(speed);
			player = GameObject.Find ("Player");
			gameStats = GameObject.Find ("stats").GetComponent<Stats> ();
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
			float distance = Vector3.Distance(transform.position, player.transform.position);
			string explosionType = SetExplosionType (gameStats.GetCurrentShot ());
			List<object> values = new List<object> ();

			values.AddRange (new object[] {distance, explosionType});
			OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz/Explode", values);
		}

		string SetExplosionType(string shot) {
			if (shot == "Fizz" || shot == "Buzz" || shot == "FizzBuzz") {
				return "explosion";
			} else {
				return "flare";
			}
		}
	}
}