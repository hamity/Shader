using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderController : MonoBehaviour {

	// Use this for initialization
	void Start () {
		GetComponent<Renderer>().material.SetColor("_BaseColor", Color.white);
	}
}
