Shader "Custom/Floor" {
	Properties {
    _Color("Color", Color) = (0, 0, 0, 0)
	}
	SubShader {
        Tags { "Queue"="Geometry-2" }
        
        Pass {
            Zwrite On
        }
	}
}
