using UnityEngine;
using System.Collections;

public class Eyeball : MonoBehaviour {
	public GameObject player;
	public float speed;

	// Use this for initialization
	void Start () {
		player = GameObject.Find ("Player");
		speed = 2.5f;
	}
	
	// Update is called once per frame
	void Update () {
		CharacterController controller = GetComponent<CharacterController> ();

		// movement
		Vector3 playerPos = player.transform.position; // player position
		Vector3 dir = playerPos - transform.position; // target position relative to player
		Vector3 movement = dir.normalized * speed * Time.deltaTime; // calculate movement based on speed
		if (movement.magnitude > dir.magnitude) { // limit mvmt to never pass target position
			movement = dir;
		}
		controller.Move (movement); // move it!

		// rotation
		Vector3 rotDir = Vector3.RotateTowards (transform.forward, dir, speed * Time.deltaTime, 0.0F);
		// Debug.DrawRay (transform.position, rotDir, Color.red);
		transform.rotation = Quaternion.LookRotation (rotDir);
		print (rotDir);
	}
}
