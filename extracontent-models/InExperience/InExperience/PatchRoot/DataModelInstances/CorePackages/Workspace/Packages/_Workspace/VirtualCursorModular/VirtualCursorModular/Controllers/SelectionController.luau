local ParentParent = script.Parent.Parent
local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableSnapInVirtualCursor = SharedFlags.FFlagEnableSnapInVirtualCursor
local FFlagEnableMoveSnapInVirtualCursor = SharedFlags.FFlagEnableMoveSnapInVirtualCursor
local FIntSnapLevelInVirtualCursor = SharedFlags.FIntSnapLevelInVirtualCursor
local FFlagVirtualCursorSnapStopsWhenInputStops = SharedFlags.FFlagVirtualCursorSnapStopsWhenInputStops
local FFlagVirtualCursorSnapLevelBasedOnDirection = SharedFlags.FFlagVirtualCursorSnapLevelBasedOnDirection
local FFlagEnableVirtualCursorDebugging = SharedFlags.FFlagEnableVirtualCursorDebugging
local Properties = require(ParentParent.Properties)
local Util = require(ParentParent.Util)
local GetMaxSpeed = Util.GetMaxSpeed
local IsCircleContainedInGuiObject = Util.IsCircleContainedInGuiObject
local IsSelectableGuiObject = Util.IsSelectableGuiObject
local IsSinkingGuiObject = Util.IsSinkingGuiObject
local GetPointRotatedAroundObject = Util.GetPointRotatedAroundObject
local cos = math.cos
local sin = math.sin
local abs = math.abs
local max = math.max
local min = math.min
local sign = math.sign
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 61
	-- upvalues: Properties (copy), t1 (copy)
	return (setmetatable({
		_isScrolling = false,
		_selectedObject = nil,
		_inputController = p1,
		_cursorController = p2,
		_snapController = p3,
		_targetingRadius = Properties.SnapRadius,
		_selectionRadius = Properties.SelectionRadius,
		_scrolled = {}
	}, t1))
end
function t1.processScrolling(t2: {[any]: any}, p4, vector2: Vector2, n1: number) -- line: 76
	-- upvalues: Properties (copy), abs (copy), cos (copy), sin (copy), max (copy), min (copy), sign (copy)
	if not p4:IsA("ScrollingFrame") then
		return false
	end

	if not p4.ScrollingEnabled then
		return false
	end

	if t2._scrolled[p4] then
		return false
	end

	t2._scrolled[p4] = true

	local ScrollVector = t2._inputController:GetScrollVector()
	local v36 = Properties.ScrollingSpeed * n1
	local ScrollingRadius = Properties.ScrollingRadius
	local AbsoluteCanvasSize = p4.AbsoluteCanvasSize
	local AbsoluteSize = p4.AbsoluteSize
	local ScrollingDirection = p4.ScrollingDirection
	local v41 = AbsoluteCanvasSize.X > AbsoluteSize.X and (ScrollingDirection == Enum.ScrollingDirection.XY or ScrollingDirection == Enum.ScrollingDirection.X)
	local v42 = AbsoluteCanvasSize.Y > AbsoluteSize.Y and (ScrollingDirection == Enum.ScrollingDirection.XY or ScrollingDirection == Enum.ScrollingDirection.Y)
	local AbsolutePosition = p4.AbsolutePosition
	local v44 = p4.Rotation / 180 * 3.141592653589793

	if abs(ScrollVector.x) > Properties.ThumbstickDeadzone and v41 then
		p4.CanvasPosition = p4.CanvasPosition + Vector2.new(ScrollVector.x * v36, 0)
	end

	if abs(ScrollVector.y) > Properties.ThumbstickDeadzone and v42 then
		p4.CanvasPosition = p4.CanvasPosition + Vector2.new(0, ScrollVector.y * v36)
	end

	local vector2_2 = Vector2.new(cos(v44), (sin(v44)))
	local vector2_3 = Vector2.new(-sin(v44), (cos(v44)))
	local v47 = Vector2.new(vector2.X, vector2.Y) - AbsolutePosition
	local v48 = v47:Dot(vector2_2) - AbsoluteSize.X / 2
	local v49 = v47:Dot(vector2_3) - AbsoluteSize.Y / 2
	local v50 = Vector2.new(abs(v48), (abs(v49))) - AbsoluteSize / 2
	local Magnitude = Vector2.new(max(v50.X, 0), (max(v50.Y, 0))).Magnitude

	if ScrollingRadius > abs(min(max(v50.X, v50.Y), 0) + Magnitude) then
		if abs(v50.X) < abs(v50.Y) and v41 then
			p4.CanvasPosition = p4.CanvasPosition + Vector2.new(sign(v48) * v36, 0)
			t2._cursorController:SetArrow(sign(v48), 0)

			return true
		end

		if abs(v50.X) >= abs(v50.Y) and v42 then
			p4.CanvasPosition = p4.CanvasPosition + Vector2.new(0, sign(v49) * v36)
			t2._cursorController:SetArrow(0, (sign(v49)))

			return true
		end
	end

	return false
end
function t1.getClosestCandidate(t3: {[any]: any}, t4: {[any]: any}, vector2: Vector2, _: number, n3: number, t5: {[any]: any}?) -- line: 141
	-- upvalues: IsSelectableGuiObject (copy), GetPointRotatedAroundObject (copy), IsSinkingGuiObject (copy), IsCircleContainedInGuiObject (copy), Properties (copy)
	local closestCandidate = nil
	local occludingCandidate = nil
	local n4 = 1e999

	if t5 then
		closestCandidate = t5.closestCandidate
		occludingCandidate = t5.occludingCandidate
		n4 = t5.closestDistance
	end

	for _, v in ipairs(t4) do
		if t3:processScrolling(v, vector2, n3) then
			t3._isScrolling = true

			return closestCandidate, occludingCandidate, n4
		end

		if IsSelectableGuiObject(v) then
			local AbsolutePosition = v.AbsolutePosition
			local v64 = v.AbsolutePosition + v.AbsoluteSize
			local n5 = 0
			local v66 = if v.AbsoluteRotation == 0 then vector2 else GetPointRotatedAroundObject(vector2, v)

			if v66.X < AbsolutePosition.X or v66.Y < AbsolutePosition.Y or v66.X > v64.X or v66.Y > v64.Y then
				local v67 = if not (v66.X < AbsolutePosition.X) then not (v66.X > v64.X) and 0 or v66.X - v64.X else AbsolutePosition.X - v66.X
				local v68 = if not (v66.Y < AbsolutePosition.Y) then not (v66.Y > v64.Y) and 0 or v66.Y - v64.Y else AbsolutePosition.Y - v66.Y

				n5 = math.sqrt(math.pow(v67, 2) + math.pow(v68, 2))
			end

			if n5 < n4 or closestCandidate == nil then
				closestCandidate = v
				n4 = n5
			end
		end

		if IsSinkingGuiObject(v) and IsCircleContainedInGuiObject(vector2, Properties.CursorRadius * Properties.OcclusionRadiusScale, v) then
			return closestCandidate, v, n4
		end
	end

	return closestCandidate, occludingCandidate, n4
end
function t1.processMoving(t6: {[any]: any}, n6: number) -- line: 211
	-- upvalues: GuiService (copy), GamepadService (copy), FFlagEnableMoveSnapInVirtualCursor (copy), FIntSnapLevelInVirtualCursor (copy), Properties (copy), GetMaxSpeed (copy)
	local v71 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()
	local MoveVector = t6._inputController:GetMoveVector()
	local GamepadCursorPosition = GamepadService:GetGamepadCursorPosition()

	if FFlagEnableMoveSnapInVirtualCursor and not t6._isScrolling then
		local CursorScreenGuiOffset = t6._cursorController:GetCursorScreenGuiOffset()

		MoveVector = t6._snapController:adjustMove(MoveVector, {
			cursorPosition = GamepadCursorPosition + CursorScreenGuiOffset,
			strengthMultiplier = FIntSnapLevelInVirtualCursor / 100,
			candidates = t6:getSnapCandidateList(GamepadCursorPosition, Properties.SnapRadius)
		})
	end

	local v75 = MoveVector * GetMaxSpeed() * if t6._selectedObject ~= nil then if not t6._isScrolling then Properties.SpeedAdjustmentTarget else Properties.ScrollingSlowDown else 1

	if v75.Magnitude > 0 then
		local v76 = GamepadCursorPosition + v75 * n6

		GamepadCursorPosition = Vector2.new(math.clamp(v76.X, 0, v71.X), (math.clamp(v76.Y, 0, v71.Y)))
	end

	t6._cursorController:SetPosition(GamepadCursorPosition)
	GamepadService:SetGamepadCursorPosition(GamepadCursorPosition)
end
function t1.processSnapping(t7: {[any]: any}, n7: number, vector2: Vector2, vector2_4: Vector2, p5) -- line: 244
	-- upvalues: FFlagEnableSnapInVirtualCursor (copy), FFlagVirtualCursorSnapStopsWhenInputStops (copy), FFlagEnableVirtualCursorDebugging (copy), FIntSnapLevelInVirtualCursor (copy), Properties (copy), GuiService (copy), FFlagVirtualCursorSnapLevelBasedOnDirection (copy), GamepadService (copy)
	if not FFlagEnableSnapInVirtualCursor then
		return
	end

	local v82 = (vector2 - vector2_4) / n7

	if v82.Magnitude <= 0 and FFlagVirtualCursorSnapStopsWhenInputStops then
		if FFlagEnableVirtualCursorDebugging then
			print("Cursor is not moving, skipping snap processing")
		end

		return
	end

	local CursorScreenGuiOffset = t7._cursorController:GetCursorScreenGuiOffset()
	local v84 = t7._snapController:adjustSnap({
		cursorPosition = vector2 + CursorScreenGuiOffset,
		strengthMultiplier = FIntSnapLevelInVirtualCursor / 100,
		targetObject = p5,
		deltaTime = n7,
		expiredTime = Properties.SnapExpireTime
	}) - CursorScreenGuiOffset
	local v85 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()
	local v86 = math.clamp(v84.X, 0, v85.X)
	local v87 = math.clamp(v84.Y, 0, v85.Y)
	local vector2_5 = Vector2.new(v86, v87)

	if (vector2_5 - vector2):Dot(v82) <= 0 and FFlagVirtualCursorSnapLevelBasedOnDirection then
		if FFlagEnableVirtualCursorDebugging then
			print("Snap position is behind cursor movement, skipping snap")
		end

		return
	end

	t7._cursorController:SetPosition(vector2_5)
	GamepadService:SetGamepadCursorPosition(vector2_5)
end
function t1.getCandidates(_: {[any]: any}, vector2: Vector2, n8: number) -- line: 292
	-- upvalues: Players (copy), CoreGui (copy)
	local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v93 = if not PlayerGui then {} else PlayerGui:GetGuiObjectsInCircle(vector2, n8)
	local GuiObjectsInCircle = CoreGui:GetGuiObjectsInCircle(vector2, n8)

	return {
		{
			CoreGui,
			GuiObjectsInCircle
		},
		{
			PlayerGui,
			v93
		}
	}
end
function t1.processAncestors(t9: {[any]: any}, p6, p7, vector2: Vector2, n9: number) -- line: 300
	local p6Parent = p6.Parent

	while p6Parent and p6Parent ~= p7 do
		if t9:processScrolling(p6Parent, vector2, n9) then
			t9._isScrolling = true

			return
		end

		p6Parent = p6Parent.Parent
	end
end
function t1.processCandidates(t10: {[any]: any}, vector2: Vector2, n10: number, n11: number) -- line: 311
	-- upvalues: GuiService (copy)
	local v105 = vector2 - GuiService:GetGuiInset()
	local v106 = t10:getCandidates(v105, n10)
	local v107 = nil
	local v108 = nil
	local n12 = 1e999

	t10._scrolled = {}
	t10._isScrolling = false

	for _, v in ipairs(v106) do
		local v112 = v[1]

		v107, v108, n12 = t10:getClosestCandidate(v[2], v105, n10, n11, {
			closestCandidate = v107,
			occludingCandidate = v108,
			closestDistance = n12
		})

		if t10._isScrolling then
			return nil, 1e999
		end

		if v107 then
			t10:processAncestors(v107, v112, v105, n11)
		end

		if t10._isScrolling then
			return nil, 1e999
		end

		if v108 and v108 ~= v107 then
			t10:processAncestors(v108, v112, v105, n11)
		end

		if t10._isScrolling then
			return nil, 1e999
		end

		if v108 then
			return v107, n12
		end
	end

	return v107, n12
end
function t1.getSnapCandidateList(t11: {[any]: any}, vector2: Vector2, n13: number) -- line: 358
	-- upvalues: GuiService (copy), Players (copy), CoreGui (copy)
	local t12 = {}
	local v117 = vector2 - GuiService:GetGuiInset()
	local v118 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()
	local LocalPlayer = Players.LocalPlayer
	local v120 = if not LocalPlayer then nil else LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v121 = if not v120 then {} else v120:GetGuiObjectsInCircle(v117, n13)
	local GuiObjectsInCircle = CoreGui:GetGuiObjectsInCircle(v117, n13)

	for _, v124 in v121 do
		if v124:IsA("GuiObject") and t11._snapController:isSnapCandidate(v124, v118) then
			table.insert(t12, v124)
		end
	end

	for _, v126 in GuiObjectsInCircle do
		if v126:IsA("GuiObject") and t11._snapController:isSnapCandidate(v126, v118) then
			table.insert(t12, v126)
		end
	end

	return t12
end
function t1.onRenderStep(t13: {[any]: any}, n14: number) -- line: 385
	-- upvalues: GamepadService (copy), FFlagEnableSnapInVirtualCursor (copy), FFlagEnableMoveSnapInVirtualCursor (copy), Players (copy), CoreGui (copy), GuiService (copy)
	local GamepadCursorPosition = GamepadService:GetGamepadCursorPosition()

	t13:processMoving(n14)

	local GamepadCursorPosition2 = GamepadService:GetGamepadCursorPosition()
	local v131, v132 = t13:processCandidates(GamepadCursorPosition2, t13._targetingRadius, n14)

	if v132 > t13._selectionRadius then
		v131 = nil
	end

	if FFlagEnableSnapInVirtualCursor and not FFlagEnableMoveSnapInVirtualCursor then
		t13:processSnapping(n14, GamepadCursorPosition2, GamepadCursorPosition, v131)
	end

	if v131 ~= t13._selectedObject then
		local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if v131 then
			t13._cursorController:SetHighlight(true)

			if v131:IsDescendantOf(CoreGui) then
				GuiService.SelectedCoreObject = v131
				GuiService.SelectedObject = nil
			elseif PlayerGui and v131:IsDescendantOf(PlayerGui) then
				GuiService.SelectedObject = v131
				GuiService.SelectedCoreObject = nil
			end
		else
			t13._cursorController:SetHighlight(false)
			GuiService.SelectedObject = nil
			GuiService.SelectedCoreObject = nil
		end

		t13._selectedObject = v131
	end
end

return t1
