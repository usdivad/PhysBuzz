using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace PhysBuzz
{
	public class Eyeball : MonoBehaviour {
		public GameObject player;
		public float speed;
		private int maxRetreatTime;
		private int curRetreatTime;

		// Use this for initialization
		void Start () {
			player = GameObject.Find ("Player");
			speed = 2.5f;
			maxRetreatTime = 100;
			curRetreatTime = 0;
		}
		
		// Update is called once per frame
		void Update () {
			CharacterController controller = GetComponent<CharacterController> ();

			// movement
			Vector3 playerPos = player.transform.position; // player position
			Vector3 dir = playerPos - transform.position; // target position relative to player
			Vector3 movement = dir.normalized * speed * Time.deltaTime; // calculate movement based on speed
			if (movement.magnitude > (dir.magnitude * 0.75)) { // limit mvmt to never pass target position
				movement = transform.position;
			}
			if (curRetreatTime > 0) {
				movement = movement * -2;

				curRetreatTime = curRetreatTime - 1;
			}
			controller.Move (movement); // move it!

			// rotation
			Vector3 rotDir = Vector3.RotateTowards (transform.forward, dir, speed * Time.deltaTime, 0.0F);
			transform.rotation = Quaternion.LookRotation (rotDir);
			// Debug.DrawRay (transform.position, rotDir, Color.red);
			//print (rotDir);

			// distance
			float distance = Vector3.Distance (playerPos, transform.position);
			OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz/Eyeball/Movement", distance);

		}

		void OnCollisionEnter(Collision hit) {
			// print (hit.transform.gameObject.name);
			int isRocket = 0; // use int because no bools in chuck
			float distance = Vector3.Distance (player.transform.position, transform.position);

			if (hit.transform.gameObject.name.Contains("fizzbuzzrocket")) {
				print ("ouch!");
				curRetreatTime = maxRetreatTime;
				isRocket = 1;
			}
			List<object> values = new List<object> ();
			values.AddRange(new object[] {isRocket, curRetreatTime, distance});
			OSCHandler.Instance.SendMessageToClient("ChucK", "/PhysBuzz/Eyeball/Hit", values);
		}
	}
}