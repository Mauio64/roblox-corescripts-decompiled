local function wrap01(p: number) -- 1 equivalent call inferred from this helper
	if p < 0 then
		return 0
	end

	if p > 1 then
		return p - math.floor(p)
	end

	return p
end

local function catmull(p: number, p2: number, p3: number, p4: number, p5: number) -- 2 equivalent calls inferred from this helper
	local v = p5 * p5
	local v2 = v * p5
	return (p2 * 2 + (-p + p3) * p5 + (p * 2 - p2 * 5 + p3 * 4 - p4) * v + (-p + p2 * 3 - p3 * 3 + p4) * v2) * 0.5
end

local function wrappedKey(list, p: number) -- 2 equivalent calls inferred from this helper
	local v = #list
	return list[(p - 1) % v + 1]
end

local function sampleSegment(list, p: number, p2: number, p3: number)
	local count = #list
	local v

	if count >= 3 then
		v = wrappedKey(list, p - 1) -- inferred equivalent call
	else
		v = list[p]
	end

	local item = list[p]
	local item2 = list[p2]
	local v2

	if count >= 3 then
		v2 = wrappedKey(list, p2 + 1) -- inferred equivalent call
	else
		v2 = list[p2]
	end

	return
		catmull(v.yawDegrees, item.yawDegrees, item2.yawDegrees, v2.yawDegrees, p3), -- inferred equivalent call
		catmull(v.pitchDegrees, item.pitchDegrees, item2.pitchDegrees, v2.pitchDegrees, p3) -- inferred equivalent call
end

local function sampleKeys(list, p: number)
	if #list == 0 then
		return 0, 0
	end

	if #list == 1 then
		return list[1].yawDegrees, list[1].pitchDegrees
	end

	p = wrap01(p) -- inferred equivalent call
	local item = list[1]
	local item2 = list[#list]

	if p <= item.alpha then
		return item.yawDegrees, item.pitchDegrees
	end

	if item2.alpha <= p then
		local v = 1 - item2.alpha

		if v <= 0 then
			return item2.yawDegrees, item2.pitchDegrees
		end

		return sampleSegment(list, #list, 1, (p - item2.alpha) / v)
	end

	for i = 1, #list - 1 do
		local item3 = list[i]
		local item4 = list[i + 1]

		if p <= item4.alpha then
			local v = item4.alpha - item3.alpha
			local v2 = not (v > 0) and 0 or (p - item3.alpha) / v
			return sampleSegment(list, i, i + 1, v2)
		end
	end

	return item2.yawDegrees, item2.pitchDegrees
end

local function cframeAroundLookAt(vector3: Vector3, p: number, p2: number, p3: number)
	local vectorToWorldSpace = (CFrame.Angles(0, math.rad(p2), 0) * CFrame.Angles(-math.rad(p3), 0, 0)):VectorToWorldSpace((Vector3.new(0, 0, p)))

	return CFrame.lookAt(vector3 + vectorToWorldSpace, vector3)
end

local v = {
	{ alpha = 0, yawDegrees = 0, pitchDegrees = 0 },
	{ alpha = 0.35, yawDegrees = 8, pitchDegrees = 4 },
	{ alpha = 0.7, yawDegrees = -6, pitchDegrees = 2 },
	{ alpha = 1, yawDegrees = 0, pitchDegrees = 0 }
}

local fullOrbit = {
	{ alpha = 0, yawDegrees = 0, pitchDegrees = 12 },
	{ alpha = 1, yawDegrees = 360, pitchDegrees = 12 }
}

local static = {
	{ alpha = 0, yawDegrees = 0, pitchDegrees = 0 }
}

local v2 = { static = static, subtle = v, closeup = v, fullOrbit = fullOrbit }
local CameraPath = {}

function CameraPath.eval(vector3: Vector3, p: number, p2, p3: number)
	local v3, v4 = sampleKeys(p2, p3)
	return cframeAroundLookAt(vector3, p, v3, v4)
end

CameraPath.cframeAroundLookAt = cframeAroundLookAt
CameraPath.sampleKeys = sampleKeys

function CameraPath.resolve(p: string?)
	if p == "static" or p == "subtle" or p == "closeup" or p == "fullOrbit" then
		return v2[p]
	end

	return v
end

function CameraPath.framingFor(p: string?): string
	return if p == "closeup" then "face" else "standing"
end

CameraPath.EMOTE_ORBIT = v
CameraPath.FULL_ORBIT = fullOrbit
CameraPath.STATIC = static
return CameraPath
