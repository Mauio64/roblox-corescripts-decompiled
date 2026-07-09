local ParentParent = script.Parent.Parent
local TweenService = game:GetService("TweenService")
local Parent = script:FindFirstAncestor("VirtualCursorModular").Parent
local FFlagEnableVirtualCursorDebugging = require(Parent.SharedFlags).FFlagEnableVirtualCursorDebugging
local Enums = require(ParentParent.Enums)
local Properties = require(ParentParent.Properties)

local function normalizeSafe(vector2: Vector2) -- line: 26
	local Magnitude = vector2.Magnitude

	if Magnitude > 1E-05 then
		return vector2 / Magnitude
	end

	return Vector2.zero
end
local function closestPointOnRect(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- line: 34
	local vector2_2X = vector2_2.X
	local vector2_2Y = vector2_2.Y
	local v18 = vector2_2.X + vector2_3.X
	local v19 = vector2_2.Y + vector2_3.Y

	return Vector2.new(math.clamp(vector2.X, vector2_2X, v18), (math.clamp(vector2.Y, vector2_2Y, v19)))
end
local function smoothStep(n1: number) -- line: 43
	return n1 * n1 * (3 - n1 * 2)
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 60
	-- upvalues: Enums (copy), t1 (copy)
	return (setmetatable({
		_currTargetObject = nil,
		_currTargetCenter = nil,
		_cursorStartingPosition = nil,
		_snapTimer = 0,
		_cursorVelocity = Vector2.zero,
		_strengthTable = {
			[Enums.SnapAssistMethod.Friction] = 0,
			[Enums.SnapAssistMethod.Tracking] = 0,
			[Enums.SnapAssistMethod.Centering] = 0
		}
	}, t1))
end
function t1.setMethodStrength(t2: {[any]: any}, p1, n2: number) -- line: 78
	local v24 = math.clamp(n2, 0, 1)

	t2._strengthTable[p1] = v24
end
function t1.getScaledMethodStrength(t3: {[any]: any}, p2, n3: number) -- line: 84
	return (math.clamp((t3._strengthTable[p2] or 0) * n3, 0, 1))
end
function t1.adjustFriction(t4: {[any]: any}, t5: {[any]: any}) -- line: 91
	-- upvalues: Enums (copy)
	local v30 = t4:getScaledMethodStrength(Enums.SnapAssistMethod.Friction, t5.strengthMultiplier)

	if not t5.targetObject or v30 <= 0 then
		return t5.cursorPosition
	end

	if t4._cursorStartingPosition then
		return t5.cursorPosition:Lerp(t4._cursorStartingPosition, v30)
	end

	return t5.cursorPosition
end
function t1.adjustTracking(t6: {[any]: any}, t7: {[any]: any}) -- line: 106
	-- upvalues: Enums (copy)
	local v33 = t6:getScaledMethodStrength(Enums.SnapAssistMethod.Tracking, t7.strengthMultiplier)

	if not t7.targetObject or v33 <= 0 then
		return t7.cursorPosition
	end

	local cursorPosition = t7.cursorPosition
	local v35 = t7.targetObject.AbsolutePosition + t7.targetObject.AbsoluteSize / 2
	local v36 = t6._currTargetCenter or v35
	local v37 = cursorPosition + Vector2.new(0, 0):Lerp(v35 - v36, v33)

	t6._currTargetCenter = v35

	return v37
end
function t1.adjustCentering(t8: {[any]: any}, t9: {[any]: any}) -- line: 124
	-- upvalues: Enums (copy), TweenService (copy)
	local v40 = t8:getScaledMethodStrength(Enums.SnapAssistMethod.Centering, t9.strengthMultiplier)

	if not t9.targetObject or v40 <= 0 then
		return t9.cursorPosition
	end

	local vector2 = Vector2.new(math.floor(t9.targetObject.AbsoluteSize.X / 2), (math.floor(t9.targetObject.AbsoluteSize.Y / 2)))
	local v42 = t9.targetObject.AbsolutePosition + vector2

	if not t9.deltaTime then
		return (t9.cursorPosition:Lerp(v42, v40))
	end

	local v43 = 1 - v40
	local v44, v45 = TweenService:SmoothDamp(t9.cursorPosition, v42, t8._cursorVelocity, v43, 1e999, t9.deltaTime)

	t8._cursorVelocity = v45

	return v44
end
function t1.adjustSnap(t10: {[any]: any}, t11: {[any]: any}) -- line: 159
	-- upvalues: FFlagEnableVirtualCursorDebugging (copy)
	if t11.targetObject ~= t10._currTargetObject then
		t10._currTargetObject = t11.targetObject

		local v48 = nil

		if t11.targetObject then
			v48 = t11.targetObject.AbsolutePosition + t11.targetObject.AbsoluteSize / 2
		end

		t10._currTargetCenter = v48
		t10._cursorVelocity = Vector2.zero
		t10._cursorStartingPosition = t11.cursorPosition
		t10._snapTimer = tick()

		if FFlagEnableVirtualCursorDebugging then
			print("New target detected, cursorPos", t11.cursorPosition, "targetPos", t10.currTargetCenter)
		end
	elseif t11.expiredTime and tick() - t10._snapTimer > t11.expiredTime then
		if FFlagEnableVirtualCursorDebugging then
			print("Snap expired")
		end

		return t11.cursorPosition
	end

	t11.cursorPosition = t10:adjustFriction(t11)
	t11.cursorPosition = t10:adjustTracking(t11)
	t11.cursorPosition = t10:adjustCentering(t11)

	return t11.cursorPosition
end
function t1.isSnapCandidate(_: {[any]: any}, p3, vector2: Vector2) -- line: 192
	if not p3.Visible or not p3.Selectable then
		return false
	end

	if p3.AbsolutePosition.X + p3.AbsoluteSize.X < 0 or p3.AbsolutePosition.Y + p3.AbsoluteSize.Y < 0 or p3.AbsolutePosition.X > vector2.X or p3.AbsolutePosition.Y > vector2.Y then
		return false
	end

	return true
end
function t1.adjustMove(_: {[any]: any}, vector2: Vector2, t14: {[any]: any}) -- line: 210
	-- upvalues: Properties (copy), FFlagEnableVirtualCursorDebugging (copy)
	local cursorPosition = t14.cursorPosition
	local candidates = t14.candidates
	local strengthMultiplier = t14.strengthMultiplier

	if strengthMultiplier <= 0 or (not candidates or #candidates == 0) then
		return vector2
	end

	if vector2.Magnitude < 1E-05 then
		return Vector2.zero
	end

	local Magnitude = vector2.Magnitude
	local v59 = if not (Magnitude > 1E-05) then Vector2.zero else vector2 / Magnitude
	local n4 = 0
	local zero = Vector2.zero

	for _, v63 in candidates do
		local AbsolutePosition = v63.AbsolutePosition
		local AbsoluteSize = v63.AbsoluteSize
		local AbsolutePositionX = AbsolutePosition.X
		local AbsolutePositionY = AbsolutePosition.Y
		local v68 = AbsolutePosition.X + AbsoluteSize.X
		local v69 = AbsolutePosition.Y + AbsoluteSize.Y
		local v70 = Vector2.new(math.clamp(cursorPosition.X, AbsolutePositionX, v68), (math.clamp(cursorPosition.Y, AbsolutePositionY, v69))) - cursorPosition
		local Magnitude2 = v70.Magnitude

		if Magnitude2 < Properties.SnapRadius then
			local Magnitude3 = v70.Magnitude
			local v73 = if not (Magnitude3 > 1E-05) then Vector2.zero else v70 / Magnitude3
			local v74 = v59:Dot(v73)

			if v74 > 0.25 then
				local v75 = math.clamp(1 - Magnitude2 / Properties.SnapRadius, 0, 1)
				local v76 = v75 * v75 * (3 - v75 * 2) * v74

				if n4 < v76 then
					n4 = v76
					zero = v73
				end
			end
		end
	end

	if n4 > 0 then
		local v77 = v59 + zero * (n4 * strengthMultiplier)
		local Magnitude4 = v77.Magnitude

		v59 = if not (Magnitude4 > 1E-05) then Vector2.zero else v77 / Magnitude4
	end

	if (v59 - vector2).Magnitude > 0 and FFlagEnableVirtualCursorDebugging then
		print("Move input adjusted from", vector2, "to", v59)
	end

	return v59
end

return t1
