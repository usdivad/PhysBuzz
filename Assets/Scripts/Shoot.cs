using UnityEngine;
using System.Collections;
using System.Collections.Generic;
//using System.Net;

namespace PhysBuzz
{
	public class Shoot : MonoBehaviour {
		// rocket prefab
		public GameObject defaultRocketPrefab;
		public GameObject fizzBuzzRocketPrefab;

		// stats (counter)
		public Stats gameStats;

		// Use this for initialization
		void Start () {
			//gameStats = new Stats();
			gameStats = GameObject.Find ("stats").GetComponent<Stats> ();
		}
		
		// Update is called once per frame
		void Update () {
			if (Input.GetMouseButtonDown (0)) {
				// update stats
				gameStats.AddShot();
				string curShot = gameStats.GetCurrentShot();
				print (curShot);

				GameObject rocketPrefab = SetPrefab (curShot);
				GameObject g = (GameObject)Instantiate(rocketPrefab,
				                                       transform.position, // exactly where the weapon is
				                                       transform.parent.rotation); // face same direction player (weapon's parent) faces

				// make rocket fly fwd by calling rigidbody's AddForce method
				// (requires rocket to have rigidbody attached to it)
				//float force = g.GetComponent<Rocket>().speed;
				float force = SetForce (curShot);
				print("force: "+ force);
				g.GetComponent<Rigidbody>().AddForce(g.transform.forward * force);


				GameObject counter = GameObject.Find ("counter");
				TextMesh counterText = counter.GetComponent<TextMesh>();
				counterText.text = gameStats.GetTotalShots().ToString();

				// OSC
				List<object> values = new List<object>();
				values.AddRange (new object[] {curShot, force});

				// values.AddRange (new object[] {transform.position.x, transform.position.y, transform.position.z});

				// values.Add (transform.parent.rotation);
				//values.Add (force);

				// OSCHandler.Instance.UpdateLogs();
				 OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz/Shoot", values);
//				OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz", transform.position.x);
			}
		}

		float SetForce(string shot) {
			if (shot == "Fizz" || shot == "Buzz" || shot == "FizzBuzz") {
				return Random.Range (100.0f, 200.0f);
			} else {
				return Random.Range (2000.0f, 3000.0f);
			}
		}

		GameObject SetPrefab(string shot) {
			if (shot == "Fizz" || shot == "Buzz" || shot == "FizzBuzz") {
				return fizzBuzzRocketPrefab;
			} else {
				return defaultRocketPrefab;
			}
		}
	}
}