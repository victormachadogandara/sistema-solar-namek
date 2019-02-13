Shader "Custom/Rim_Spec"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Albedo("Albedo", Color) = (1, 1, 1, 1)
		_BumpTex("Normal", 2D) = "bump" {}
		_NormalAmount("Normal Amount", Range(-3, 3)) = 1
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower("Rim Amount", Range(0.5, 8.0)) = 1
		_Spec("Specular", Range(0, 1)) = 0.5
		_Gloss("Gloss", Range(0, 1)) = 0.5
		_SpecColor("SpecColor", Color) = (1, 1, 1, 1)
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		sampler2D _BumpTex;
		half4 _Albedo;
		float _NormalAmount;
		float4 _RimColor;
		float _RimPower;

		half _Spec;
		fixed _Gloss;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Albedo.rbg;
			float3 normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			normal.z = normal.z / _NormalAmount;
			o.Normal = normal;

			//Rim
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);

			o.Specular = _Spec;
			o.Gloss = _Gloss;
		}

		ENDCG
	}

}
