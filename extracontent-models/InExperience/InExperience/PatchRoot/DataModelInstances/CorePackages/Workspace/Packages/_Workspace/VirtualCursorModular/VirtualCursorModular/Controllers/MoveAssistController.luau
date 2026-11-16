local parent = script.Parent.Parent

local parent2 = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging
local FFlagVirtualCursorMoveAssistIntentRamp = SharedFlags.FFlagVirtualCursorMoveAssistIntentRamp

local Properties = require(parent.Properties)

local MoveAssistMinInputMagnitude = Properties.MoveAssistMinInputMagnitude

local v = Properties.CursorRadius * 0.5

local function normalizeSafe(vector2: Vector2) -- 4 equivalent calls inferred from this helper
	local magnitude = vector2.Magnitude

	if magnitude > 0.00001 then
		return vector2 / magnitude
	end

	return Vector2.zero
end

local function closestPointOnRect(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- 2 equivalent calls inferred from this helper
	local x = vector2_2.X
	local y = vector2_2.Y
	local v2 = vector2_2.X + vector2_3.X
	local v3 = vector2_2.Y + vector2_3.Y

	return Vector2.new(math.clamp(vector2.X, x, v2), (math.clamp(vector2.Y, y, v3)))
end

local function smoothStep(p: number) -- 1 equivalent call inferred from this helper
	return p * p * (3 - p * 2)
end

local function computeAimPoint(p, vector2: Vector2, p2: number, p3: number)
	local absoluteSize = p.AbsoluteSize
	local absolutePosition = p.AbsolutePosition
	local v2 = closestPointOnRect(vector2, absolutePosition - Vector2.new(p2, p2), absoluteSize + Vector2.new(p3, p3)) -- inferred equivalent call

	local v3 = absolutePosition + absoluteSize / 2

	local v4 = math.clamp(1 - math.max(absoluteSize.X, absoluteSize.Y) / p3 / 0.5, 0, 1)

	return v2:Lerp(v3, v4), (closestPointOnRect(vector2, absolutePosition, absoluteSize):Lerp(v3, v4)) -- inferred equivalent call
end

local function scoreCandidate(candidate, cursorPosition: Vector2, vector: Vector2, cursorRadius: number, p: number)
	local absoluteSize = candidate.AbsoluteSize
	local v2 = (absoluteSize.X * math.abs(vector.Y) + absoluteSize.Y * math.abs(vector.X)) / p

	if v2 >= 1 then
		return nil
	end

	local v3 = math.clamp(1 - v2 ^ 2, 0, 1)
	local v4, aimPoint = computeAimPoint(candidate, cursorPosition, cursorRadius, p)

	local v5 = v4 - cursorPosition
	local magnitude = v5.Magnitude
	local safe = normalizeSafe(v5) -- inferred equivalent call
	local dot = vector:Dot(safe)
	local scored

	if magnitude < Properties.MoveAssistRadius then
		scored = dot > 0.25
	else
		scored = false
	end

	local influence

	if scored then
		influence = smoothStep(math.clamp(1 - magnitude / Properties.MoveAssistRadius, 0, 1)) * dot * v3 -- inferred equivalent call
	else
		influence = 0
	end

	return {
		scored = scored,
		influence = influence,
		dirToButton = safe,
		distance = magnitude,
		dot = dot,
		aimPoint = aimPoint
	}
end

local function computeAssistStrength(p: number, p2: number, p3: number, p4: number, flag: boolean, p5: number, p6: number)
	local confidence = not (p > 0) and 0 or (p - p2) / p
	local v2 = flag and 0.08 or 0.15
	local confidenceStrength = math.clamp((confidence - v2) / (0.4 - v2), 0, 1)

	local inputFollowStrength = math.clamp((p3 - 0.25) / 0.75, 0, 1)

	local arrivalFactor = math.clamp(p4 / v, 0, 1)

	return {
		assistStrength = math.clamp(p5 * p6 * confidenceStrength * inputFollowStrength * arrivalFactor, 0, 1),
		confidence = confidence,
		confidenceStrength = confidenceStrength,
		inputFollowStrength = inputFollowStrength,
		arrivalFactor = arrivalFactor
	}
end

local MoveAssistController = {}
MoveAssistController.__index = MoveAssistController

function MoveAssistController.new()
	local self = setmetatable({ _assistTarget = nil, _debugSnapshot = nil }, MoveAssistController)

	if FFlagEnableVirtualCursorDebugging then
		print("[VirtualCursor] MoveAssistController created")
	end

	return self
end

function MoveAssistController:applyMoveAssist(vector2: Vector2, data)
	local cursorPosition = data.cursorPosition
	local candidates = data.candidates
	local masterGain = math.clamp(data.strengthMultiplier, 0, 1)
	local candidates2

	if FFlagEnableVirtualCursorDebugging then
		candidates2 = {}

		self._debugSnapshot = {
			active = false,
			cursorPosition = cursorPosition,
			radius = Properties.MoveAssistRadius,
			inputDir = normalizeSafe(vector2), -- inferred equivalent call
			finalDir = normalizeSafe(vector2), -- inferred equivalent call
			inputMagnitude = vector2.Magnitude,
			candidates = candidates2,
			committed = nil,
			masterGain = masterGain,
			intentFactor = 0,
			confidence = 0,
			confidenceStrength = 0,
			inputFollowStrength = 0,
			arrivalFactor = 0,
			assistStrength = 0,
			bestInfluence = 0
		}
	end

	if masterGain <= 0 or not candidates or #candidates == 0 then
		self._assistTarget = nil
		return vector2
	end

	local magnitude = vector2.Magnitude

	if magnitude < 0.00001 then
		self._assistTarget = nil
		return Vector2.zero
	end

	local intentFactor

	if FFlagVirtualCursorMoveAssistIntentRamp then
		intentFactor = math.clamp((magnitude - MoveAssistMinInputMagnitude) / (0.7 - MoveAssistMinInputMagnitude), 0, 1)

		if intentFactor <= 0 then
			self._assistTarget = nil
			return vector2
		end
	elseif magnitude < MoveAssistMinInputMagnitude then
		self._assistTarget = nil
		return vector2
	else
		intentFactor = 1
	end

	local cursorRadius = Properties.CursorRadius
	local v2 = cursorRadius * 2
	local v3 = vector2 / magnitude

	local v4 = Vector2.zero
	local bestInfluence = 0
	local v5 = 0
	local v6 = nil
	local v7 = 0
	local v8 = 0
	local v9 = nil

	for _, candidate in candidates do
		local v10

		if candidates2 then
			v10 = {
				position = candidate.AbsolutePosition,
				size = candidate.AbsoluteSize,
				influence = 0,
				aimPoint = nil,
				state = "skipped"
			}

			table.insert(candidates2, v10)
		end

		local v11 = scoreCandidate(candidate, cursorPosition, v3, cursorRadius, v2)

		if not v11 then
			continue
		end

		if v10 then
			v10.aimPoint = v11.aimPoint

			if v11.scored then
				v10.influence = v11.influence
				v10.state = "scored"
			end
		end

		if not v11.scored then
			continue
		end

		local influence = v11.influence

		if self._assistTarget ~= nil and candidate == self._assistTarget then
			influence *= 1.25
		end

		if bestInfluence < influence then
			v4 = v11.dirToButton
			v8 = v11.distance
			v7 = v11.dot
			v9 = v10
			v6 = candidate
			v5 = bestInfluence
			bestInfluence = influence
		elseif v5 < influence then
			v5 = influence
		end
	end

	if not v6 or bestInfluence < 0.05 then
		self._assistTarget = nil
		return vector2
	end

	local v10

	if self._assistTarget then
		v10 = v6 == self._assistTarget
	else
		v10 = false
	end

	if v7 < (v10 and 0.25 or 0.5) then
		self._assistTarget = nil
		return vector2
	end

	local v11 = computeAssistStrength(bestInfluence, v5, v7, v8, v10, masterGain, intentFactor)

	if v11.assistStrength <= 0 then
		self._assistTarget = nil
		return vector2
	end

	self._assistTarget = v6

	local safe = normalizeSafe(v3:Lerp(v4, v11.assistStrength)) -- inferred equivalent call

	if safe == Vector2.zero then
		return vector2
	end

	local v12 = safe * magnitude

	if not FFlagEnableVirtualCursorDebugging then
		return v12
	end

	if (v12 - vector2).Magnitude > 0 then
		print("Move input adjusted from", vector2, "to", v12)
	end

	local debugSnapshot = self._debugSnapshot

	if debugSnapshot then
		debugSnapshot.active = true
		debugSnapshot.finalDir = safe
		debugSnapshot.intentFactor = intentFactor
		debugSnapshot.confidence = v11.confidence
		debugSnapshot.confidenceStrength = v11.confidenceStrength
		debugSnapshot.inputFollowStrength = v11.inputFollowStrength
		debugSnapshot.arrivalFactor = v11.arrivalFactor
		debugSnapshot.assistStrength = v11.assistStrength
		debugSnapshot.bestInfluence = bestInfluence
		debugSnapshot.committed = v6
	end

	if v9 then
		v9.state = "committed"
	end

	return v12
end

function MoveAssistController:clearDebugSnapshot()
	self._debugSnapshot = nil
end

return MoveAssistController
