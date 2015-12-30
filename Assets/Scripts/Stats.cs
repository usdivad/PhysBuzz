using UnityEngine;
using System.Collections;

namespace PhysBuzz
{
	public class Stats : MonoBehaviour {
		private int totalShots;

		// Use this for initialization
		void Start () {
			totalShots = 0;
		}
		
		// Update is called once per frame
		void Update () {
		
		}

		// get the total number of shots fired so far
		public int GetTotalShots() {
			return totalShots;
		}

		// get the "FizzBuzz"'ed value of the current shot
		public string GetCurrentShot() {
			return FizzBuzz (totalShots);
		}

		public void AddShot() {
			totalShots = totalShots + 1;
		}

		public string FizzBuzz(int n) {
			if (n % 15 == 0) {
				return "FizzBuzz";
			} else if (n % 3 == 0) {
				return "Fizz";
			} else if (n % 5 == 0) {
				return "Buzz";
			} else {
				return n.ToString();
			}
		}
	}
}