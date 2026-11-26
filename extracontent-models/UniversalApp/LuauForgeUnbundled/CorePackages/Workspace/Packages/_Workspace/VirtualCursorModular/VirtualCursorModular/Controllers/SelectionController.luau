local GuiService = game:GetService("GuiService")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags")
local fFlagEnableVirtualCursorMoveAssist = SharedFlags.FFlagEnableVirtualCursorMoveAssist
local fIntVirtualCursorMoveAssistLevel = SharedFlags.FIntVirtualCursorMoveAssistLevel
local fIntVirtualCursorMoveAssistHoverSpeed = SharedFlags.FIntVirtualCursorMoveAssistHoverSpeed
local fFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink
local fIntVirtualCursorMoveAssistSpeedSizeMinScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMinScale
local fIntVirtualCursorMoveAssistSpeedSizeMaxScale = SharedFlags.FIntVirtualCursorMoveAssistSpeedSizeMaxScale
local fIntVirtualCursorMoveAssistSpeedSmoothingTimeMs = SharedFlags.FIntVirtualCursorMoveAssistSpeedSmoothingTimeMs

local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local Util = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Util")
local getMaxSpeed = Util.GetMaxSpeed
local getUsesInputSink = Util.GetUsesInputSink
local isCircleContainedInGuiObject = Util.IsCircleContainedInGuiObject
local isScreenSpaceGuiObject = Util.IsScreenSpaceGuiObject
local isSelectableGuiObject = Util.IsSelectableGuiObject
local isSinkingGuiObject = Util.IsSinkingGuiObject
local getPointRotatedAroundObject = Util.GetPointRotatedAroundObject

local cos = math.cos
local sin = math.sin
local abs = math.abs
local max = math.max
local min = math.min
local sign = math.sign

local class = {}
class.__index = class

function class.new(p2, p3, p4)
	return (setmetatable({
		_isScrolling = false,
		_selectedObject = nil,
		_inputController = p2,
		_cursorController = p3,
		_moveAssistController = p4,
		_selectionRadius = Properties.SelectionRadius,
		_scrolled = {},
		_hoverSlowdown = 1
	}, class))
end

function class:processScrolling(scrollingFrame, p2, p3): boolean
	if
		not scrollingFrame:IsA("ScrollingFrame")
		or not scrollingFrame.ScrollingEnabled
		or self._scrolled[scrollingFrame]
	then
		return false
	end

	self._scrolled[scrollingFrame] = true

	local scrollVector = self._inputController:GetScrollVector()
	local v5 = Properties.ScrollingSpeed * p3
	local scrollingRadius = Properties.ScrollingRadius
	local absoluteCanvasSize = scrollingFrame.AbsoluteCanvasSize
	local absoluteSize = scrollingFrame.AbsoluteSize
	local scrollingDirection = scrollingFrame.ScrollingDirection
	local v6

	if absoluteCanvasSize.X > absoluteSize.X then
		v6 = scrollingDirection == Enum.ScrollingDirection.XY
			or scrollingDirection == Enum.ScrollingDirection.X
	else
		v6 = false
	end

	local v7

	if absoluteCanvasSize.Y > absoluteSize.Y then
		v7 = scrollingDirection == Enum.ScrollingDirection.XY
			or scrollingDirection == Enum.ScrollingDirection.Y
	else
		v7 = false
	end

	local absolutePosition = scrollingFrame.AbsolutePosition
	local v8 = scrollingFrame.Rotation / 180 * 3.141592653589793

	if abs(scrollVector.x) > Properties.ThumbstickDeadzone and v6 then
		scrollingFrame.CanvasPosition += Vector2.new(scrollVector.x * v5, 0)
	end

	if abs(scrollVector.y) > Properties.ThumbstickDeadzone and v7 then
		scrollingFrame.CanvasPosition += Vector2.new(0, scrollVector.y * v5)
	end

	local vector2 = Vector2.new(cos(v8), (sin(v8)))

	local vector2_2 = Vector2.new(-sin(v8), (cos(v8)))
	local vector3 = Vector2.new(p2.X, p2.Y) - absolutePosition

	local v9 = vector3:Dot(vector2) - absoluteSize.X / 2
	local v10 = vector3:Dot(vector2_2) - absoluteSize.Y / 2
	local v11 = Vector2.new(abs(v9), (abs(v10))) - absoluteSize / 2
	local magnitude = Vector2.new(max(v11.X, 0), (max(v11.Y, 0))).Magnitude

	if not (abs(min(max(v11.X, v11.Y), 0) + magnitude) < scrollingRadius) then
		return false
	end

	if abs(v11.X) < abs(v11.Y) and v6 then
		scrollingFrame.CanvasPosition += Vector2.new(sign(v9) * v5, 0)
		self._cursorController:SetArrow(sign(v9), 0)
		return true
	else
		local v16 = abs(v11.X)

		if abs(v11.Y) <= v16 and v7 then
			scrollingFrame.CanvasPosition += Vector2.new(0, sign(v10) * v5)
			self._cursorController:SetArrow(0, (sign(v10)))
			return true
		end
	end

	return false
end

function class:getClosestCandidate(items, p2, p3, p4, data, coreGui)
	local v5, occludingCandidate, v6

	if data then
		v5 = data.closestCandidate
		occludingCandidate = data.occludingCandidate
		v6 = data.closestDistance
	else
		v6 = 1e999
	end

	local v7 = not (coreGui == nil) and coreGui:IsA("CoreGui")

	for k, item in items do
		if self:processScrolling(item, p2, p4) then
			self._isScrolling = true
			return v5, occludingCandidate, v6
		end

		local v8

		if fFlagVirtualCursorInputSink and coreGui ~= nil then
			v8 = getUsesInputSink(item, v7)
		else
			v8 = false
		end

		local v10 = if fFlagVirtualCursorInputSink then v8 else nil

		if isSelectableGuiObject(item, v10) then
			local absolutePosition = item.AbsolutePosition
			local v11 = item.AbsolutePosition + item.AbsoluteSize

			local v12 = 0
			local v13 = if item.AbsoluteRotation == 0 then p2 else getPointRotatedAroundObject(p2, item)

			if
				v13.X < absolutePosition.X
				or v13.Y < absolutePosition.Y
				or v13.X > v11.X
				or v13.Y > v11.Y
			then
				local v14

				if v13.X < absolutePosition.X then
					v14 = absolutePosition.X - v13.X
				else
					v14 = not (v13.X > v11.X) and 0 or v13.X - v11.X
				end

				local v15

				if v13.Y < absolutePosition.Y then
					v15 = absolutePosition.Y - v13.Y
				else
					v15 = not (v13.Y > v11.Y) and 0 or v13.Y - v11.Y
				end

				v12 = math.sqrt(math.pow(v14, 2) + math.pow(v15, 2))
			end

			if v12 < v6 or v5 == nil then
				v6 = v12
				v5 = item
			end
		end

		if not fFlagVirtualCursorInputSink then
			v8 = nil
		end

		if
			isSinkingGuiObject(item, v8)
			and isCircleContainedInGuiObject(p2, Properties.CursorRadius * Properties.OcclusionRadiusScale, item)
		then
			return v5, item, v6
		end
	end

	return v5, occludingCandidate, v6
end

function class:getSizeAdaptiveHoverSpeed(p3, p4, p5, p6)
	local v5 = Properties.CursorRadius * 2
	local v6 = min(p3.AbsoluteSize.X, p3.AbsoluteSize.Y) / v5
	local v7 = p6 - p5
	local v8 = not (v7 > 0) and 1 or math.clamp((v6 - p5) / v7, 0, 1)
	return p4 + (1 - p4) * v8
end

function class:processMoving(p2)
	local v5 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()

	local moveVector = self._inputController:GetMoveVector()
	local v6 = GamepadService:GetGamepadCursorPosition()
	local v7 = fFlagEnableVirtualCursorMoveAssist and fIntVirtualCursorMoveAssistLevel > 0

	if v7 and not self._isScrolling and moveVector.Magnitude >= Properties.MoveAssistMinInputMagnitude then
		local cursorScreenGuiOffset = self._cursorController:GetCursorScreenGuiOffset()
		moveVector = self._moveAssistController:applyMoveAssist(moveVector, {
			cursorPosition = v6 + cursorScreenGuiOffset,
			strengthMultiplier = fIntVirtualCursorMoveAssistLevel / 100,
			candidates = self:getAssistCandidateList(v6, Properties.MoveAssistRadius)
		})
	elseif fFlagEnableVirtualCursorMoveAssist then
		self._moveAssistController:clearDebugSnapshot()
	end

	local v8 = moveVector * getMaxSpeed()
	local selectedObject = self._selectedObject
	local v9

	if v7 then
		local v10

		if fIntVirtualCursorMoveAssistHoverSpeed > 0 then
			v10 = fIntVirtualCursorMoveAssistHoverSpeed / 100
		else
			v10 = Properties.SpeedAdjustmentTarget
		end

		local v11 = fIntVirtualCursorMoveAssistSpeedSizeMinScale / 100
		local v12 = fIntVirtualCursorMoveAssistSpeedSizeMaxScale / 100

		if
			v11 < v12
			and selectedObject ~= nil
			and not self._isScrolling
			and isScreenSpaceGuiObject(selectedObject)
		then
			v10 = self:getSizeAdaptiveHoverSpeed(selectedObject, v10, v11, v12)
		end

		if selectedObject == nil then
			v10 = 1
		elseif self._isScrolling then
			v10 = Properties.ScrollingSlowDown
		end

		local v13 = fIntVirtualCursorMoveAssistSpeedSmoothingTimeMs / 1000

		if v13 > 0 then
			local v14 = 1 - math.exp(-p2 / v13)
			self._hoverSlowdown += (v10 - self._hoverSlowdown) * v14
			v9 = v8 * self._hoverSlowdown
		else
			v9 = v8 * v10
		end
	else
		local v10

		if selectedObject == nil then
			v10 = 1
		else
			v10 = if self._isScrolling then Properties.ScrollingSlowDown else Properties.SpeedAdjustmentTarget
		end

		v9 = v8 * v10
	end

	if v9.Magnitude > 0 then
		local v10 = v6 + v9 * p2
		v6 = Vector2.new(math.clamp(v10.X, 0, v5.X), (math.clamp(v10.Y, 0, v5.Y)))
	end

	self._cursorController:SetPosition(v6)
	GamepadService:SetGamepadCursorPosition(v6)
end

function class:getCandidates(p3, p4)
	local localPlayer = Players.LocalPlayer
	local playerGui = if localPlayer then localPlayer:FindFirstChildOfClass("PlayerGui") else nil
	local v5 = not playerGui and {} or playerGui:GetGuiObjectsInCircle(p3, p4)
	return {
		{ CoreGui, (CoreGui:GetGuiObjectsInCircle(p3, p4)) },
		{ playerGui, v5 }
	}
end

function class:processAncestors(p2, p3, p4, p5)
	local parent = p2.Parent

	while parent and parent ~= p3 do
		if self:processScrolling(parent, p4, p5) then
			self._isScrolling = true
			break
		end

		parent = parent.Parent
	end
end

function class:processCandidates(p2, p3, p4)
	local v5 = p2 - GuiService:GetGuiInset()
	local candidates = self:getCandidates(v5, p3)

	self._scrolled = {}
	self._isScrolling = false
	local v6 = nil
	local v7 = nil
	local v8 = 1e999

	for i, candidate in ipairs(candidates) do
		local v9 = candidate[1]
		local v10 = candidate[2]
		local v12 = if fFlagVirtualCursorInputSink then v9 else nil
		v6, v7, v8 = self:getClosestCandidate(
			v10,
			v5,
			p3,
			p4,
			{ closestCandidate = v6, occludingCandidate = v7, closestDistance = v8 },
			v12
		)

		if self._isScrolling then
			return nil, 1e999
		end

		if v6 then
			self:processAncestors(v6, v9, v5, p4)
		end

		if self._isScrolling then
			return nil, 1e999
		end

		if v7 and v7 ~= v6 then
			self:processAncestors(v7, v9, v5, p4)
		end

		if self._isScrolling then
			return nil, 1e999
		end

		if v7 then
			return v6, v8
		end
	end

	return v6, v8
end

function class:getAssistCandidateList(p2, p3)
	local v5 = {}
	local guiObjects = {}

	for k, v6 in self:getCandidates(p2 - GuiService:GetGuiInset(), p3) do
		for k2, guiObject in v6[2] do
			if not guiObject:IsA("GuiObject") then
				continue
			end

			if v6[1] == CoreGui then
				table.insert(if fFlagVirtualCursorInputSink then v5 else guiObjects, guiObject)
			else
				table.insert(guiObjects, guiObject)
			end
		end
	end

	if fFlagVirtualCursorInputSink then
		return self:filterAssistCandidates(v5, guiObjects)
	end

	return self:DEPRECATED_filterAssistCandidates(guiObjects)
end

function class:filterAssistCandidates(p3, p4)
	local v5 = Properties.CursorRadius * Properties.OcclusionRadiusScale
	local v6 = {}
	local result = {}

	for k, v7 in { p3, p4 } do
		for k2, v8 in v7 do
			local usesInputSink = getUsesInputSink(v8, v7 == p3)

			if isSelectableGuiObject(v8, usesInputSink) then
				local v9 = v8.AbsolutePosition + v8.AbsoluteSize * 0.5
				local v10 = false

				for k3, v12 in v6 do
					if v12 ~= v8 and isCircleContainedInGuiObject(v9, v5, v12) then
						v10 = true
						break
					end
				end

				if not v10 then
					table.insert(result, v8)
				end
			end

			if isSinkingGuiObject(v8, usesInputSink) then
				table.insert(v6, v8)
			end
		end
	end

	return result
end

function class:DEPRECATED_filterAssistCandidates(items)
	local v5 = Properties.CursorRadius * Properties.OcclusionRadiusScale
	local v6 = {}
	local result = {}

	for k, item in items do
		if isSelectableGuiObject(item) then
			local v7 = item.AbsolutePosition + item.AbsoluteSize * 0.5
			local v8 = false

			for k2, v10 in v6 do
				if v10 ~= item and isCircleContainedInGuiObject(v7, v5, v10) then
					v8 = true
					break
				end
			end

			if not v8 then
				table.insert(result, item)
			end
		end

		if isSinkingGuiObject(item) then
			table.insert(v6, item)
		end
	end

	return result
end

function class:onRenderStep(p2)
	self:processMoving(p2)
	local v5 = self:processCandidates(GamepadService:GetGamepadCursorPosition(), self._selectionRadius, p2)

	if v5 ~= self._selectedObject then
		local localPlayer = Players.LocalPlayer
		local playerGui = if localPlayer then localPlayer:FindFirstChildOfClass("PlayerGui") else nil

		if v5 then
			self._cursorController:SetHighlight(true)

			if v5:IsDescendantOf(CoreGui) then
				GuiService.SelectedCoreObject = v5
				GuiService.SelectedObject = nil
			elseif playerGui and v5:IsDescendantOf(playerGui) then
				GuiService.SelectedObject = v5
				GuiService.SelectedCoreObject = nil
			end
		else
			self._cursorController:SetHighlight(false)

			GuiService.SelectedObject = nil
			GuiService.SelectedCoreObject = nil
		end

		self._selectedObject = v5
	end
end

return class
