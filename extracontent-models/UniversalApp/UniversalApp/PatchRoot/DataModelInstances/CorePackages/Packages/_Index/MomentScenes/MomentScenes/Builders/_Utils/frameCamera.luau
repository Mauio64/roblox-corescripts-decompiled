local avatarFloorPosition = require(script.Parent.avatarFloorPosition)

local parent = script:FindFirstAncestor("MomentScenes").Parent
local SafeFlags = require(parent.SafeFlags)

local getFString = SafeFlags.createGetFString("MomentScenesFrameCameraPadding", "2")

local function cameraPadding() -- 1 equivalent call inferred from this helper
	local v = tonumber(getFString())
	return if v == nil or v <= 0 then 2 else v
end

local function headTopAboveRoot(humanoidRootPart, head) -- 2 equivalent calls inferred from this helper
	return head.Position.Y - humanoidRootPart.Position.Y + 0.5 * head.Size.Y
end

local function emptyFit()
	return CFrame.lookAt(Vector3.new(0, 2.5, 8), Vector3.new(0, 2, 0)), Vector3.new(0, 2, 0), 8
end

local function distanceToFit(vector3: Vector3, p: number)
	local v = math.rad(p) / 2
	local v2 = math.atan(math.tan(v) * 0.5625)
	return math.max(
		not (math.tan(v) > 0) and 8 or vector3.Y / 2 / math.tan(v),
		not (math.tan(v2) > 0) and 8 or vector3.X / 2 / math.tan(v2),
		1
	) * cameraPadding() -- inferred equivalent call
end

local function fitBox(vector3: Vector3, vector3_2: Vector3, p: number)
	local v = vector3_2 - vector3
	local midpoint = (vector3 + vector3_2) / 2
	local v2 = distanceToFit(v, p)
	return CFrame.lookAt(midpoint + Vector3.new(0, 0, v2), midpoint), midpoint, v2
end

local FrameCamera = {}

function FrameCamera.fitStandingCharacters(items, p: number)
	local v = Vector3.new(1e999, 1e999, 1e999)
	local v2 = Vector3.new(-1e999, -1e999, -1e999)
	local flag = false

	for _, item in items do
		local humanoidRootPart = item:FindFirstChild("HumanoidRootPart")
		local head = item:FindFirstChild("Head")
		local heightForCharacter = avatarFloorPosition.heightForCharacter(item)

		if not (humanoidRootPart ~= nil and humanoidRootPart:IsA("BasePart") and head ~= nil and head:IsA("BasePart")) then
			continue
		end

		if heightForCharacter == nil then
			continue
		end

		local v3 = heightForCharacter + headTopAboveRoot(humanoidRootPart, head) -- inferred equivalent call

		local v4 = v3 * 0.24
		local position = humanoidRootPart.Position
		v = Vector3.new(math.min(v.X, position.X - v4), math.min(v.Y, 0), (math.min(v.Z, position.Z - 0.75)))

		v2 = Vector3.new(math.max(v2.X, position.X + v4), math.max(v2.Y, v3), (math.max(v2.Z, position.Z + 0.75)))
		flag = true
	end

	if flag then
		return fitBox(v, v2, p)
	end

	return emptyFit()
end

function FrameCamera.fitStandingFace(items, p: number)
	local v = Vector3.new(1e999, 1e999, 1e999)
	local v2 = Vector3.new(-1e999, -1e999, -1e999)
	local flag = false

	for _, item in items do
		local humanoidRootPart = item:FindFirstChild("HumanoidRootPart")
		local head = item:FindFirstChild("Head")
		local heightForCharacter = avatarFloorPosition.heightForCharacter(item)

		if not (humanoidRootPart ~= nil and humanoidRootPart:IsA("BasePart") and head ~= nil and head:IsA("BasePart")) then
			continue
		end

		if heightForCharacter == nil then
			continue
		end

		local v3 = heightForCharacter + headTopAboveRoot(humanoidRootPart, head) -- inferred equivalent call

		local position = humanoidRootPart.Position
		v = Vector3.new(math.min(v.X, position.X - 0.7), math.min(v.Y, v3 - 2), (math.min(v.Z, position.Z - 0.5)))

		v2 = Vector3.new(math.max(v2.X, position.X + 0.7), math.max(v2.Y, v3), (math.max(v2.Z, position.Z + 0.5)))
		flag = true
	end

	if flag then
		return fitBox(v, v2, p)
	end

	return emptyFit()
end

return FrameCamera
