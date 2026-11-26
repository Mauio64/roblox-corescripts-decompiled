local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags")
local fFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging
local fFlagVirtualCursorMoveAssistIntentRamp = SharedFlags.FFlagVirtualCursorMoveAssistIntentRamp

local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local moveAssistMinInputMagnitude = Properties.MoveAssistMinInputMagnitude

local v5 = Properties.CursorRadius * 0.5

local function normalizeSafe(p2)
	local magnitude = p2.Magnitude

	if magnitude > 0.00001 then
		return p2 / magnitude
	end

	return Vector2.zero
end

local function closestPointOnRect(p2, p3, p4)
	local x = p3.X
	local y = p3.Y
	local v6 = p3.X + p4.X
	local v7 = p3.Y + p4.Y

	return Vector2.new(math.clamp(p2.X, x, v6), (math.clamp(p2.Y, y, v7)))
end

local function smoothStep(p2)
	return p2 * p2 * (3 - 2 * p2)
end

local function computeAimPoint(p2, p3, p4, p5)
	local absoluteSize = p2.AbsoluteSize
	local absolutePosition = p2.AbsolutePosition
	local v6 = absolutePosition - Vector2.new(p4, p4)
	local v7 = absoluteSize + Vector2.new(p5, p5)
	local x = v6.X
	local y = v6.Y
	local v8 = v6.X + v7.X
	local v9 = v6.Y + v7.Y

	local vector2 = Vector2.new(math.clamp(p3.X, x, v8), (math.clamp(p3.Y, y, v9)))

	local v10 = absolutePosition + absoluteSize / 2

	local v11 = math.clamp(1 - math.max(absoluteSize.X, absoluteSize.Y) / p5 / 0.5, 0, 1)

	local lerped = vector2:Lerp(v10, v11)
	local x2 = absolutePosition.X
	local y2 = absolutePosition.Y
	local v12 = absolutePosition.X + absoluteSize.X
	local v13 = absolutePosition.Y + absoluteSize.Y

	return lerped, (Vector2.new(math.clamp(p3.X, x2, v12), (math.clamp(p3.Y, y2, v13))):Lerp(v10, v11))
end

local function scoreCandidate(candidate, cursorPosition, vector2, cursorRadius, p2)
	local absoluteSize = candidate.AbsoluteSize
	local v6 = (absoluteSize.X * math.abs(vector2.Y) + absoluteSize.Y * math.abs(vector2.X)) / p2

	if v6 >= 1 then
		return nil
	end

	local v7 = math.clamp(1 - v6 ^ 2, 0, 1)
	local v8, v9 = computeAimPoint(candidate, cursorPosition, cursorRadius, p2)

	local v10 = v8 - cursorPosition
	local magnitude = v10.Magnitude
	local magnitude2 = v10.Magnitude

	local v11 = if magnitude2 > 0.00001 then v10 / magnitude2 else Vector2.zero

	local dot = vector2:Dot(v11)

	local v12 = magnitude < Properties.MoveAssistRadius and dot > 0.25
	local v13

	if v12 then
		local v14 = math.clamp(1 - magnitude / Properties.MoveAssistRadius, 0, 1)
		v13 = v14 * v14 * (3 - 2 * v14) * dot * v7
	else
		v13 = 0
	end

	return {
		scored = v12,
		influence = v13,
		dirToButton = v11,
		distance = magnitude,
		dot = dot,
		aimPoint = v9
	}
end

local function computeAssistStrength(p2, p3, p4, p5, p6, p7, p8)
	local v6 = not (p2 > 0) and 0 or (p2 - p3) / p2
	local v7 = p6 and 0.08 or 0.15
	local v8 = math.clamp((v6 - v7) / (0.4 - v7), 0, 1)

	local v9 = math.clamp((p4 - 0.25) / 0.75, 0, 1)

	local v10 = math.clamp(p5 / v5, 0, 1)

	return {
		assistStrength = math.clamp(p7 * p8 * v8 * v9 * v10, 0, 1),
		confidence = v6,
		confidenceStrength = v8,
		inputFollowStrength = v9,
		arrivalFactor = v10
	}
end

local class = {}
class.__index = class

function class.new()
	local object = setmetatable({ _assistTarget = nil, _debugSnapshot = nil }, class)

	if fFlagEnableVirtualCursorDebugging then
		print("[VirtualCursor] MoveAssistController created")
	end

	return object
end

function class:applyMoveAssist(p2, data)
	local cursorPosition = data.cursorPosition
	local candidates = data.candidates
	local v6 = math.clamp(data.strengthMultiplier, 0, 1)
	local v7

	if fFlagEnableVirtualCursorDebugging then
		v7 = {}

		local v8 = {
			active = false,
			cursorPosition = cursorPosition,
			radius = Properties.MoveAssistRadius,
			inputDir = 0,
			finalDir = 0,
			inputMagnitude = 0,
			candidates = 0,
			committed = nil,
			masterGain = 0,
			intentFactor = 0,
			confidence = 0,
			confidenceStrength = 0,
			inputFollowStrength = 0,
			arrivalFactor = 0,
			assistStrength = 0,
			bestInfluence = 0
		}
		local magnitude = p2.Magnitude

		local v9 = if magnitude > 0.00001 then p2 / magnitude else Vector2.zero

		v8.inputDir = v9
		local magnitude2 = p2.Magnitude

		local v10 = if magnitude2 > 0.00001 then p2 / magnitude2 else Vector2.zero

		v8.finalDir = v10
		v8.inputMagnitude = p2.Magnitude
		v8.candidates = v7

		v8.masterGain = v6
		self._debugSnapshot = v8
	end

	if v6 <= 0 or not candidates or #candidates == 0 then
		self._assistTarget = nil
		return p2
	end

	local magnitude = p2.Magnitude

	if magnitude < 0.00001 then
		self._assistTarget = nil
		return Vector2.zero
	end

	local v8

	if fFlagVirtualCursorMoveAssistIntentRamp then
		v8 = math.clamp(
			(magnitude - moveAssistMinInputMagnitude) / (0.7 - moveAssistMinInputMagnitude),
			0,
			1
		)

		if v8 <= 0 then
			self._assistTarget = nil
			return p2
		end
	elseif magnitude < moveAssistMinInputMagnitude then
		self._assistTarget = nil
		return p2
	else
		v8 = 1
	end

	local cursorRadius = Properties.CursorRadius
	local v9 = cursorRadius * 2
	local v10 = p2 / magnitude

	local v11 = Vector2.zero
	local v12 = 0
	local v13 = 0
	local v14 = nil
	local v15 = 0
	local v16 = 0
	local v17 = nil

	for k, candidate in candidates do
		local v18

		if v7 then
			v18 = {
				position = candidate.AbsolutePosition,
				size = candidate.AbsoluteSize,
				influence = 0,
				aimPoint = nil,
				state = "skipped"
			}

			table.insert(v7, v18)
		end

		local v19 = scoreCandidate(candidate, cursorPosition, v10, cursorRadius, v9)

		if not v19 then
			continue
		end

		if v18 then
			v18.aimPoint = v19.aimPoint

			if v19.scored then
				v18.influence = v19.influence
				v18.state = "scored"
			end
		end

		if not v19.scored then
			continue
		end

		local influence = v19.influence

		if self._assistTarget ~= nil and candidate == self._assistTarget then
			influence *= 1.25
		end

		if v12 < influence then
			v11 = v19.dirToButton
			v16 = v19.distance
			v15 = v19.dot
			v17 = v18
			v14 = candidate
			v13 = v12
			v12 = influence
		elseif v13 < influence then
			v13 = influence
		end
	end

	if not v14 or v12 < 0.05 then
		self._assistTarget = nil
		return p2
	end

	local v18 = if self._assistTarget then v14 == self._assistTarget else false

	if v15 < (v18 and 0.25 or 0.5) then
		self._assistTarget = nil
		return p2
	end

	local v19 = computeAssistStrength(v12, v13, v15, v16, v18, v6, v8)

	if v19.assistStrength <= 0 then
		self._assistTarget = nil
		return p2
	end

	self._assistTarget = v14

	local lerped = v10:Lerp(v11, v19.assistStrength)
	local magnitude2 = lerped.Magnitude

	local v20 = if magnitude2 > 0.00001 then lerped / magnitude2 else Vector2.zero

	if v20 == Vector2.zero then
		return p2
	end

	local v21 = v20 * magnitude

	if not fFlagEnableVirtualCursorDebugging then
		return v21
	end

	if (v21 - p2).Magnitude > 0 then
		print("Move input adjusted from", p2, "to", v21)
	end

	local debugSnapshot = self._debugSnapshot

	if debugSnapshot then
		debugSnapshot.active = true
		debugSnapshot.finalDir = v20
		debugSnapshot.intentFactor = v8
		debugSnapshot.confidence = v19.confidence
		debugSnapshot.confidenceStrength = v19.confidenceStrength
		debugSnapshot.inputFollowStrength = v19.inputFollowStrength
		debugSnapshot.arrivalFactor = v19.arrivalFactor
		debugSnapshot.assistStrength = v19.assistStrength
		debugSnapshot.bestInfluence = v12
		debugSnapshot.committed = v14
	end

	if v17 then
		v17.state = "committed"
	end

	return v21
end

function class:clearDebugSnapshot()
	self._debugSnapshot = nil
end

return class
