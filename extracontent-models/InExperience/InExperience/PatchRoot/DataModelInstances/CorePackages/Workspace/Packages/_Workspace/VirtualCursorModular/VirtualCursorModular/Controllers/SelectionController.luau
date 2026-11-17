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
local FFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink
local FIntVirtualCursorMoveAssistSpeedSizeMinScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMinScale
local FIntVirtualCursorMoveAssistSpeedSizeMaxScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMaxScale
local FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs = SharedFlags.FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs

local Properties = require(parent.Properties)

local Util = require(parent.Util)
local GetMaxSpeed = Util.GetMaxSpeed
local GetUsesInputSink = Util.GetUsesInputSink
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
	else
		local v8 = abs(v7.X)

		if abs(v7.Y) <= v8 and v3 then
			scrollingFrame.CanvasPosition += Vector2.new(0, sign(v6) * v)
			self._cursorController:SetArrow(0, (sign(v6)))
			return true
		end
	end

	return false
end

function SelectionController:getClosestCandidate(items, vector2: Vector2, _: number, p: number, data, coreGui)
	local v, occludingCandidate, v2

	if data then
		v = data.closestCandidate
		occludingCandidate = data.occludingCandidate
		v2 = data.closestDistance
	else
		v2 = 1e999
	end

	local v3

	if coreGui == nil then
		v3 = false
	else
		v3 = coreGui:IsA("CoreGui")
	end

	for _, item in items do
		if self:processScrolling(item, vector2, p) then
			self._isScrolling = true
			return v, occludingCandidate, v2
		end

		local v4

		if FFlagVirtualCursorInputSink and coreGui ~= nil then
			v4 = GetUsesInputSink(item, v3)
		else
			v4 = false
		end

		local v5

		if FFlagVirtualCursorInputSink then
			v5 = v4
		end

		if IsSelectableGuiObject(item, v5) then
			local absolutePosition = item.AbsolutePosition
			local v6 = item.AbsolutePosition + item.AbsoluteSize

			local v7 = 0
			local v8

			if item.AbsoluteRotation == 0 then
				v8 = vector2
			else
				v8 = GetPointRotatedAroundObject(vector2, item)
			end

			if v8.X < absolutePosition.X or v8.Y < absolutePosition.Y or v8.X > v6.X or v8.Y > v6.Y then
				local v9

				if v8.X < absolutePosition.X then
					v9 = absolutePosition.X - v8.X
				else
					v9 = not (v8.X > v6.X) and 0 or v8.X - v6.X
				end

				local v10

				if v8.Y < absolutePosition.Y then
					v10 = absolutePosition.Y - v8.Y
				else
					v10 = not (v8.Y > v6.Y) and 0 or v8.Y - v6.Y
				end

				v7 = math.sqrt(math.pow(v9, 2) + math.pow(v10, 2))
			end

			if v7 < v2 or v == nil then
				v2 = v7
				v = item
			end
		end

		if not FFlagVirtualCursorInputSink then
			v4 = nil
		end

		if
			IsSinkingGuiObject(item, v4)
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
		local v3 = candidate[2]
		local v4

		if FFlagVirtualCursorInputSink then
			v4 = v2
		end

		closestCandidate, occludingCandidate, closestDistance = self:getClosestCandidate(
			v3,
			v,
			p,
			p2,
			{
				closestCandidate = closestCandidate,
				occludingCandidate = occludingCandidate,
				closestDistance = closestDistance
			},
			v4
		)

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
	local v = {}
	local guiObjects = {}

	for _, v2 in self:getCandidates(vector2 - GuiService:GetGuiInset(), p) do
		for _, guiObject in v2[2] do
			if not guiObject:IsA("GuiObject") then
				continue
			end

			if v2[1] == CoreGui then
				local v3

				if FFlagVirtualCursorInputSink then
					v3 = v
				else
					v3 = guiObjects
				end

				table.insert(v3, guiObject)
			else
				table.insert(guiObjects, guiObject)
			end
		end
	end

	if FFlagVirtualCursorInputSink then
		return self:filterAssistCandidates(v, guiObjects)
	end

	return self:DEPRECATED_filterAssistCandidates(guiObjects)
end

function SelectionController:filterAssistCandidates(p, p2)
	local v = Properties.CursorRadius * Properties.OcclusionRadiusScale
	local v2 = {}
	local result = {}

	for _, v3 in { p, p2 } do
		for _, v4 in v3 do
			local usesInputSink = GetUsesInputSink(v4, v3 == p)

			if IsSelectableGuiObject(v4, usesInputSink) then
				local v5 = v4.AbsolutePosition + v4.AbsoluteSize * 0.5
				local v6 = false

				for _, v7 in v2 do
					if v7 ~= v4 and IsCircleContainedInGuiObject(v5, v, v7) then
						v6 = true
						break
					end
				end

				if not v6 then
					table.insert(result, v4)
				end
			end

			if IsSinkingGuiObject(v4, usesInputSink) then
				table.insert(v2, v4)
			end
		end
	end

	return result
end

function SelectionController:DEPRECATED_filterAssistCandidates(items)
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
