local parent = script.Parent

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local GamepadService = game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")

local playerGui = nil

local Input = require(parent.Input)
local Interface = require(parent.Interface)
local Properties = require(parent.Properties)
local isCircleContainedInGuiObject = require(parent.isCircleContainedInGuiObject)
local isSelectableGuiObject = require(parent.isSelectableGuiObject)
local RotatePointAroundObject = require(parent.RotatePointAroundObject)

local v = 1

local flag = false

local sin = math.sin
local cos = math.cos
local abs = math.abs
local max = math.max
local min = math.min
local sign = math.sign
local abs2 = math.abs

local scrollingFrameSet = {}

local v2 = nil
local v3 = nil
local v4 = 1e999

local function contains(p, p2, p3): boolean
	return p.x >= p2.x and p.y >= p2.y and p.x <= p3.x and p.y <= p3.y
end

local function handleScrollingFrame(scrollingFrame, p, p2): boolean
	if
		not scrollingFrame:IsA("ScrollingFrame")
		or not scrollingFrame.ScrollingEnabled
		or scrollingFrameSet[scrollingFrame]
	then
		return false
	end

	scrollingFrameSet[scrollingFrame] = true

	local thumbstick2Vector = Input:GetThumbstick2Vector()
	local v5 = Properties.ScrollingSpeed * p2
	local scrollingRadius = Properties.ScrollingRadius
	local absoluteCanvasSize = scrollingFrame.AbsoluteCanvasSize
	local absoluteSize = scrollingFrame.AbsoluteSize
	local scrollingDirection = scrollingFrame.ScrollingDirection
	local v6

	if absoluteCanvasSize.X > absoluteSize.X then
		v6 = scrollingDirection == Enum.ScrollingDirection.XY or scrollingDirection == Enum.ScrollingDirection.X
	else
		v6 = false
	end

	local v7

	if absoluteCanvasSize.Y > absoluteSize.Y then
		v7 = scrollingDirection == Enum.ScrollingDirection.XY or scrollingDirection == Enum.ScrollingDirection.Y
	else
		v7 = false
	end

	local absoluteSize2 = scrollingFrame.AbsoluteSize
	local absolutePosition = scrollingFrame.AbsolutePosition
	local v8 = scrollingFrame.Rotation / 180 * 3.141592653589793

	if abs2(thumbstick2Vector.x) > Properties.ThumbstickDeadzone and v6 then
		scrollingFrame.CanvasPosition += Vector2.new(thumbstick2Vector.x * v5, 0)
	end

	if abs2(thumbstick2Vector.y) > Properties.ThumbstickDeadzone and v7 then
		scrollingFrame.CanvasPosition += Vector2.new(0, thumbstick2Vector.y * v5)
	end

	local vector2 = Vector2.new(cos(v8), (sin(v8)))

	local vector2_2 = Vector2.new(-sin(v8), (cos(v8)))
	local vector = Vector2.new(p.X, p.Y) - absolutePosition

	local v9 = vector:Dot(vector2) - absoluteSize2.X / 2
	local v10 = vector:Dot(vector2_2) - absoluteSize2.Y / 2
	local v11 = Vector2.new(abs2(v9), (abs2(v10))) - absoluteSize2 / 2
	local magnitude = Vector2.new(max(v11.x, 0), (max(v11.y, 0))).Magnitude

	if not (abs2(min(max(v11.x, v11.y), 0) + magnitude) < scrollingRadius) then
		return false
	end

	if abs2(v11.x) < abs2(v11.y) and v6 then
		scrollingFrame.CanvasPosition += Vector2.new(sign(v9) * v5, 0)
		Interface:SetArrow(sign(v9), 0)
		return true
	elseif abs2(v11.x) >= abs2(v11.y) and v7 then
		scrollingFrame.CanvasPosition += Vector2.new(0, sign(v10) * v5)
		Interface:SetArrow(0, (sign(v10)))
		return true
	end

	return false
end

local function findClosestOrOccludingGuiObject(_, list, p, p2)
	for _, item in ipairs(list) do
		if handleScrollingFrame(item, p, p2) then
			flag = true
			break
		end

		local selectableGuiObject = isSelectableGuiObject(item)

		if selectableGuiObject and not v2 then
			v2 = item
		end

		if selectableGuiObject then
			local absolutePosition = item.AbsolutePosition
			local v5 = item.AbsolutePosition + item.AbsoluteSize

			local v6 = 0
			local v7

			if item.AbsoluteRotation == 0 then
				v7 = p
			else
				v7 = RotatePointAroundObject(p, item)
			end

			if v7.x < absolutePosition.x or v7.y < absolutePosition.y or v7.x > v5.x or v7.y > v5.y then
				local v8

				if v7.x < absolutePosition.x then
					v8 = absolutePosition.x - v7.x
				else
					v8 = not (v7.x > v5.x) and 0 or v7.x - v5.x
				end

				local v9

				if v7.y < absolutePosition.y then
					v9 = absolutePosition.y - v7.y
				else
					v9 = not (v7.y > v5.y) and 0 or v7.y - v5.y
				end

				v6 = math.sqrt(math.pow(v8, 2) + math.pow(v9, 2))
			end

			if v6 < v4 then
				v2 = item
				v4 = v6
			end
		end

		if
			item.Visible
			and item.Active
			and item.Interactable
			and isCircleContainedInGuiObject(p, Properties.CursorRadius * Properties.OcclusionRadiusScale, item)
		then
			v3 = item
			break
		end
	end
end

local function handleScrollingInAncestors(p, p2, p3, p4)
	local parent2 = p.Parent

	while parent2 and parent2 ~= p2 do
		if handleScrollingFrame(parent2, p3, p4) then
			flag = true
			break
		end

		parent2 = parent2.Parent
	end
end

local function processCursorPosition(p, selectionRadius, p2)
	table.clear(scrollingFrameSet)
	v2 = nil
	v3 = nil
	v4 = 1e999

	local v5 = p - GuiService:GetGuiInset()

	if playerGui == nil then
		playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local v6 = not playerGui and {} or playerGui:GetGuiObjectsInCircle(v5, selectionRadius)
	local guiObjectsInCircle = CoreGui:GetGuiObjectsInCircle(v5, selectionRadius)

	flag = false

	local v7 = {
		{ CoreGui, guiObjectsInCircle },
		{ playerGui, v6 }
	}

	for _, v8 in ipairs(v7) do
		local v9 = v8[1]
		findClosestOrOccludingGuiObject(v9, v8[2], v5, p2)

		if flag then
			return nil
		end

		if v2 then
			handleScrollingInAncestors(v2, v9, v5, p2)
		end

		if flag then
			return nil
		end

		if v3 and v3 ~= v2 then
			handleScrollingInAncestors(v3, v9, v5, p2)
		end

		if flag then
			return nil
		end

		if v3 then
			return v2
		end
	end

	return v2
end

local function getMaxSpeed() -- 1 equivalent call inferred from this helper
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return function(state, p)
	local v5 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()

	local thumbstickVector = Input:GetThumbstickVector()
	local cursorPosition = GamepadService:GetGamepadCursorPosition()

	Vector2.new()

	if state.SelectedObject == nil then
		v = 1
		Interface:SetCursorHighlight(false)
	end

	if flag then
		v = Properties.ScrollingSlowDown
	end

	local v6 = thumbstickVector * getMaxSpeed() * v -- inferred equivalent call

	if v6.Magnitude > 0 then
		local v7 = cursorPosition + v6 * p
		local v8 = math.clamp(v7.x, 0, v5.x)
		local v9 = math.clamp(v7.y, 0, v5.y)
		cursorPosition = Vector2.new(v8, v9)
	end

	Interface:SetCursorPosition(cursorPosition)
	GamepadService:SetGamepadCursorPosition(cursorPosition)
	state.CursorPosition = cursorPosition

	local v7 = processCursorPosition(cursorPosition, Properties.SelectionRadius, p)

	if v7 ~= state.PreviouslySelectedObject then
		state.PreviouslySelectedObject = v7

		Interface:SetCursorHighlight(v7 ~= nil)

		if v7 then
			if v7 ~= state.SelectedObject then
				state.SelectedObject = v7
				v = Properties.SpeedAdjustmentTarget
			end
		else
			state.SelectedObject = nil
			v = 1
		end

		if state.SelectedObject == nil then
			GuiService.SelectedObject = nil
			GuiService.SelectedCoreObject = nil
		elseif state.SelectedObject:IsDescendantOf(CoreGui) then
			GuiService.SelectedCoreObject = state.SelectedObject
			GuiService.SelectedObject = nil
		elseif state.SelectedObject:IsDescendantOf(playerGui) then
			GuiService.SelectedObject = state.SelectedObject
			GuiService.SelectedCoreObject = nil
		end
	end
end
