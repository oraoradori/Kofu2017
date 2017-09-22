////////////////////////////////////////////////////////
Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

struct VS_OUTPUT
{
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR0;
};

cbuffer ShaderInput : register(b1)
{
	float2 g_resolution;
	float  g_time;
	float  g_frame;
	float2 g_mouse;
	float  g_leftPressed;
	float  g_rightPressed;
	float2 g_textureResolution;
};
////////////////////////////////////////////////////////
static const float  HorizontalAmplitude = 0.80;
static const float  VerticleAmplitude = 0.80;
static const float  HorizontalSpeed = 2.90;
static const float  VerticleSpeed = 0.80;
static const float  ParticleMinSize = 1.76;
static const float  ParticleMaxSize = 1.71;
static const float  ParticleBreathingSpeed = 0.30;
static const float  ParticleColorChangeSpeed = 0.70;
static const float  ParticleCount = 7.0;
static const float3 ParticleColor1 = float3(9.0, 5.0, 3.0);
static const float3 ParticleColor2 = float3(1.0, 3.0, 9.0);
float3 checkerBoard(float2 uv, float2 pp)
{
	float2 p = floor(uv * 4.6);
	float t = fmod(p.x + p.y, 2.2);
	float3 c = float3(t + pp.x, t + pp.y, t + (pp.x*pp.y));

	return c;
}

float3 tunnel(float2 p, float scrollSpeed, float rotateSpeed)
{
	float a = 1.0 * atan2(p.y, p.x);
	float po = 2.0;
	float px = pow(p.x*p.x, po);
	float py = pow(p.y*p.y, po);
	float r = pow(px + py, 1.0 / (12.0*po));
	float2 uvp = float2(1.0 / r + (g_time*scrollSpeed), a + (g_time*rotateSpeed));
	float3 finalColor = checkerBoard(uvp, p).xyz;
	finalColor *= r;

	return finalColor;
}

float4 PS(float4 position : SV_POSITION, float2 uv : TEXCOORD0) : SV_Target
{
	float timeSpeedX = g_time * 0.3;
float timeSpeedY = g_time * 0.2;
float2 p = uv + float2(-0.50 + cos(timeSpeedX)*0.2, -0.5 - sin(timeSpeedY)*0.3);
float3 finalColor = tunnel(p, 1.2, 1.0);

timeSpeedX = g_time * 0.30001;
timeSpeedY = g_time * 0.20001;
p = uv + float2(-0.50 + cos(timeSpeedX)*0.2, -0.5 - sin(timeSpeedY)*0.3);
return float4(finalColor,1);
}