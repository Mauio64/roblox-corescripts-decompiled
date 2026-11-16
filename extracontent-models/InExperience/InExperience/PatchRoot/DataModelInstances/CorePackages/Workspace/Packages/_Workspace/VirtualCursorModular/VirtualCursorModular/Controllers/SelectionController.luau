local parent = script.Parent.Parent

local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local parent2 = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableVirtualCursorMoveAssist = SharedFlags.FFlagEnableVirtualCursorMoveAssist
local FIntVirtualCursorMoveAssistLevel = SharedFlags.FIntVirtualCursorMoveAssistLevel
local FIntVirtualCursorMoveAssistHoverSpeed = SharedFlags.FIntVirtualCursorMoveAssistHoverSpeed
local FIntVirtualCursorMoveAssistSpeedSizeMinScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMinScale
local FIntVirtualCursorMoveAssistSpeedSizeMaxScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMaxScale
local FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs = SharedFlags.FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs

local Properties = require(parent.Properties)

local Util = require(parent.Util)
local GetMaxSpeed = Util.GetMaxSpeed
local IsCircleContainedInGuiObject = Util.IsCircleContainedInGuiObject
local IsScreenSpaceGuiObject = Util.IsScreenSpaceGuiObject
local IsSelectableGuiObject = Util.IsSelectableGuiObject
local IsSinkingGuiObject = Util.IsSinkingGuiObject
local GetPointRotatedAroundObject = Util.GetPointRotatedAroundObject

local cos = math.cos
local sin = math.sin
local abs = math.abs
local max = math.max
local min = math.min
local sign = math.sign

local SelectionController = {}
SelectionController.__index = SelectionController

function SelectionController.new(inputController, cursorController, moveAssistController)
	return (setmetatable({
		_isScrolling = false,
		_selectedObject = nil,
		_inputController = inputController,
		_cursorController = cursorController,
		_moveAssistController = moveAssistController,
		_selectionRadius = Properties.SelectionRadius,
		_scrolled = {},
		_hoverSlowdown = 1
	}, SelectionController))
end

function SelectionController:processScrolling(scrollingFrame, vector2: Vector2, p: number): boolean
	if
		not scrollingFrame:IsA("ScrollingFrame")
		or not scrollingFrame.ScrollingEnabled
		or self._scrolled[scrollingFrame]
	then
		return false
	end

	self._scrolled[scrollingFrame] = true

	local scrollVector = self._inputController:GetScrollVector()
	local v = Properties.ScrollingSpeed * p
	local scrollingRadius = Properties.ScrollingRadius
	local absoluteCanvasSize = scrollingFrame.AbsoluteCanvasSize
	local absoluteSize = scrollingFrame.AbsoluteSize
	local scrollingDirection = scrollingFrame.ScrollingDirection
	local v2

	if absoluteCanvasSize.X > absoluteSize.X then
		v2 = scrollingDirection == Enum.ScrollingDirection.XY or scrollingDirection == Enum.ScrollingDirection.X
	else
		v2 = false
	end

	local v3

	if absoluteCanvasSize.Y > absoluteSize.Y then
		v3 = scrollingDirection == Enum.ScrollingDirection.XY or scrollingDirection == Enum.ScrollingDirection.Y
	else
		v3 = false
	end

	local absolutePosition = scrollingFrame.AbsolutePosition
	local v4 = scrollingFrame.Rotation / 180 * 3.141592653589793

	if abs(scrollVector.x) > Properties.ThumbstickDeadzone and v2 then
		scrollingFrame.CanvasPosition += Vector2.new(scrollVector.x * v, 0)
	end

	if abs(scrollVector.y) > Properties.ThumbstickDeadzone and v3 then
		scrollingFrame.CanvasPosition += Vector2.new(0, scrollVector.y * v)
	end

	local vector2_2 = Vector2.new(cos(v4), (sin(v4)))

	local vector2_3 = Vector2.new(-sin(v4), (cos(v4)))
	local vector = Vector2.new(vector2.X, vector2.Y) - absolutePosition

	local v5 = vector:Dot(vector2_2) - absoluteSize.X / 2
	local v6 = vector:Dot(vector2_3) - absoluteSize.Y / 2
	local v7 = Vector2.new(abs(v5), (abs(v6))) - absoluteSize / 2
	local magnitude = Vector2.new(max(v7.X, 0), (max(v7.Y, 0))).Magnitude

	if not (abs(min(max(v7.X, v7.Y), 0) + magnitude) < scrollingRadius) then
		return false
	end

	if abs(v7.X) < abs(v7.Y) and v2 then
		scrollingFrame.CanvasPosition += Vector2.new(sign(v5) * v, 0)
		self._cursorController:SetArrow(sign(v5), 0)
		return true
	elseif abs(v7.X) >= abs(v7.Y) and v3 then
		scrollingFrame.CanvasPosition += Vector2.new(0, sign(v6) * v)
		self._cursorController:SetArrow(0, (sign(v6)))
		return true
	end

	return false
end

function SelectionController:getClosestCandidate(list, vector2: Vector2, _: number, p: number, data)
	local v, occludingCandidate, v2

	if data then
		v = data.closestCandidate
		occludingCandidate = data.occludingCandidate
		v2 = data.closestDistance
	else
		v2 = 1e999
	end

	for _, item in ipairs(list) do
		if self:processScrolling(item, vector2, p) then
			self._isScrolling = true
			return v, occludingCandidate, v2
		end

		if IsSelectableGuiObject(item) then
			local absolutePosition = item.AbsolutePosition
			local v3 = item.AbsolutePosition + item.AbsoluteSize

			local v4 = 0
			local v5

			if item.AbsoluteRotation == 0 then
				v5 = vector2
			else
				v5 = GetPointRotatedAroundObject(vector2, item)
			end

			if v5.X < absolutePosition.X or v5.Y < absolutePosition.Y or v5.X > v3.X or v5.Y > v3.Y then
				local v6

				if v5.X < absolutePosition.X then
					v6 = absolutePosition.X - v5.X
				else
					v6 = not (v5.X > v3.X) and 0 or v5.X - v3.X
				end

				local v7

				if v5.Y < absolutePosition.Y then
					v7 = absolutePosition.Y - v5.Y
				else
					v7 = not (v5.Y > v3.Y) and 0 or v5.Y - v3.Y
				end

				v4 = math.sqrt(math.pow(v6, 2) + math.pow(v7, 2))
			end

			if v4 < v2 or v == nil then
				v2 = v4
				v = item
			end
		end

		if
			IsSinkingGuiObject(item)
			and IsCircleContainedInGuiObject(vector2, Properties.CursorRadius * Properties.OcclusionRadiusScale, item)
		then
			return v, item, v2
		end
	end

	return v, occludingCandidate, v2
end

function SelectionController:getSizeAdaptiveHoverSpeed(p, p2: number, p3: number, p4: number)
	local v = Properties.CursorRadius * 2
	local v2 = min(p.AbsoluteSize.X, p.AbsoluteSize.Y) / v
	local v3 = p4 - p3
	local v4 = not (v3 > 0) and 1 or math.clamp((v2 - p3) / v3, 0, 1)
	return p2 + (1 - p2) * v4
end

function SelectionController:processMoving(p: number)
	local v = GuiService:GetScreenResolution() + GuiService:GetGuiInset()

	local moveVector = self._inputController:GetMoveVector()
	local v2 = GamepadService:GetGamepadCursorPosition()
	local v3 = FFlagEnableVirtualCursorMoveAssist and FIntVirtualCursorMoveAssistLevel > 0

	if v3 and not self._isScrolling and moveVector.Magnitude >= Properties.MoveAssistMinInputMagnitude then
		local cursorScreenGuiOffset = self._cursorController:GetCursorScreenGuiOffset()
		moveVector = self._moveAssistController:applyMoveAssist(moveVector, {
			cursorPosition = v2 + cursorScreenGuiOffset,
			strengthMultiplier = FIntVirtualCursorMoveAssistLevel / 100,
			candidates = self:getAssistCandidateList(v2, Properties.MoveAssistRadius)
		})
	elseif FFlagEnableVirtualCursorMoveAssist then
		self._moveAssistController:clearDebugSnapshot()
	end

	local v4 = moveVector * GetMaxSpeed()
	local selectedObject = self._selectedObject
	local v5

	if v3 then
		local v6

		if FIntVirtualCursorMoveAssistHoverSpeed > 0 then
			v6 = FIntVirtualCursorMoveAssistHoverSpeed / 100
		else
			v6 = Properties.SpeedAdjustmentTarget
		end

		local v7 = FIntVirtualCursorMoveAssistSpeedSizeMinScale / 100
		local v8 = FIntVirtualCursorMoveAssistSpeedSizeMaxScale / 100

		if v7 < v8 and selectedObject ~= nil and not self._isScrolling and IsScreenSpaceGuiObject(selectedObject) then
			v6 = self:getSizeAdaptiveHoverSpeed(selectedObject, v6, v7, v8)
		end

		if selectedObject == nil then
			v6 = 1
		elseif self._isScrolling then
			v6 = Properties.ScrollingSlowDown
		end

		local v9 = FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs / 1000

		if v9 > 0 then
			local v10 = 1 - math.exp(-p / v9)
			self._hoverSlowdown += (v6 - self._hoverSlowdown) * v10
			v5 = v4 * self._hoverSlowdown
		else
			v5 = v4 * v6
		end
	else
		local v6

		if selectedObject == nil then
			v6 = 1
		elseif self._isScrolling then
			v6 = Properties.ScrollingSlowDown
		else
			v6 = Properties.SpeedAdjustmentTarget
		end

		v5 = v4 * v6
	end

	if v5.Magnitude > 0 then
		local v6 = v2 + v5 * p
		v2 = Vector2.new(math.clamp(v6.X, 0, v.X), (math.clamp(v6.Y, 0, v.Y)))
	end

	self._cursorController:SetPosition(v2)
	GamepadService:SetGamepadCursorPosition(v2)
end

function SelectionController:getCandidates(vector2: Vector2, p: number)
	local localPlayer = Players.LocalPlayer
	local playerGui

	if localPlayer then
		playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local v = not playerGui and {} or playerGui:GetGuiObjectsInCircle(vector2, p)
	return {
		{ CoreGui, (CoreGui:GetGuiObjectsInCircle(vector2, p)) },
		{ playerGui, v }
	}
end

function SelectionController:processAncestors(p, p2, vector2: Vector2, p3: number)
	local parent3 = p.Parent

	while parent3 and parent3 ~= p2 do
		if self:processScrolling(parent3, vector2, p3) then
			self._isScrolling = true
			break
		end

		parent3 = parent3.Parent
	end
end

function SelectionController:processCandidates(vector2: Vector2, p: number, p2: number)
	local v = vector2 - GuiService:GetGuiInset()
	local candidates = self:getCandidates(v, p)

	self._scrolled = {}
	self._isScrolling = false
	local closestCandidate = nil
	local occludingCandidate = nil
	local closestDistance = 1e999

	for _, candidate in ipairs(candidates) do
		local v2 = candidate[1]
		closestCandidate, occludingCandidate, closestDistance = self:getClosestCandidate(candidate[2], v, p, p2, {
			closestCandidate = closestCandidate,
			occludingCandidate = occludingCandidate,
			closestDistance = closestDistance
		})

		if self._isScrolling then
			return nil, 1e999
		end

		if closestCandidate then
			self:processAncestors(closestCandidate, v2, v, p2)
		end

		if self._isScrolling then
			return nil, 1e999
		end

		if occludingCandidate and occludingCandidate ~= closestCandidate then
			self:processAncestors(occludingCandidate, v2, v, p2)
		end

		if self._isScrolling then
			return nil, 1e999
		end

		if occludingCandidate then
			return closestCandidate, closestDistance
		end
	end

	return closestCandidate, closestDistance
end

function SelectionController:getAssistCandidateList(vector2: Vector2, p: number)
	local guiObjects = {}

	for _, v in self:getCandidates(vector2 - GuiService:GetGuiInset(), p) do
		for _, guiObject in v[2] do
			if guiObject:IsA("GuiObject") then
				table.insert(guiObjects, guiObject)
			end
		end
	end

	return self:filterAssistCandidates(guiObjects)
end

function SelectionController:filterAssistCandidates(items)
	local v = Properties.CursorRadius * Properties.OcclusionRadiusScale
	local v2 = {}
	local result = {}

	for _, item in items do
		if IsSelectableGuiObject(item) then
			local v3 = item.AbsolutePosition + item.AbsoluteSize * 0.5
			local v4 = false

			for _, v5 in v2 do
				if v5 ~= item and IsCircleContainedInGuiObject(v3, v, v5) then
					v4 = true
					break
				end
			end

			if not v4 then
				table.insert(result, item)
			end
		end

		if IsSinkingGuiObject(item) then
			table.insert(v2, item)
		end
	end

	return result
end

function SelectionController:onRenderStep(p: number)
	self:processMoving(p)
	local v = self:processCandidates(GamepadService:GetGamepadCursorPosition(), self._selectionRadius, p)

	if v ~= self._selectedObject then
		local localPlayer = Players.LocalPlayer
		local playerGui

		if localPlayer then
			playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		end

		if v then
			self._cursorController:SetHighlight(true)

			if v:IsDescendantOf(CoreGui) then
				GuiService.SelectedCoreObject = v
				GuiService.SelectedObject = nil
			elseif playerGui and v:IsDescendantOf(playerGui) then
				GuiService.SelectedObject = v
				GuiService.SelectedCoreObject = nil
			end
		else
			self._cursorController:SetHighlight(false)

			GuiService.SelectedObject = nil
			GuiService.SelectedCoreObject = nil
		end

		self._selectedObject = v
	end
end

return SelectionController
