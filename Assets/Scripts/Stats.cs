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

		public int GetTotalShots() {
			return totalShots;
		}

		public void AddShot() {
			totalShots = totalShots + 1;
		}
	}
}