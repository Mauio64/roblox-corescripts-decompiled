local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local GamepadService = game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")

local playerGui = nil

local Input = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Input")
local Interface = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Interface")
local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Properties")
local isCircleContainedInGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/isCircleContainedInGuiObject")
local isSelectableGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/isSelectableGuiObject")
local RotatePointAroundObject = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/RotatePointAroundObject")

local v5 = 1

local flag = false

local sin = math.sin
local cos = math.cos
local abs = math.abs
local max = math.max
local min = math.min
local sign = math.sign
local abs2 = math.abs

local scrollingFrameSet = {}

local v6 = nil
local v7 = nil
local v8 = 1e999

local function contains(p2, p3, p4): boolean
	return p2.x >= p3.x and p2.y >= p3.y and p2.x <= p4.x and p2.y <= p4.y
end

local function handleScrollingFrame(scrollingFrame, p2, p3): boolean
	if
		not scrollingFrame:IsA("ScrollingFrame")
		or not scrollingFrame.ScrollingEnabled
		or scrollingFrameSet[scrollingFrame]
	then
		return false
	end

	scrollingFrameSet[scrollingFrame] = true

	local thumbstick2Vector = Input:GetThumbstick2Vector()
	local v9 = Properties.ScrollingSpeed * p3
	local scrollingRadius = Properties.ScrollingRadius
	local absoluteCanvasSize = scrollingFrame.AbsoluteCanvasSize
	local absoluteSize = scrollingFrame.AbsoluteSize
	local scrollingDirection = scrollingFrame.ScrollingDirection
	local v10

	if absoluteCanvasSize.X > absoluteSize.X then
		v10 = scrollingDirection == Enum.ScrollingDirection.XY
			or scrollingDirection == Enum.ScrollingDirection.X
	else
		v10 = false
	end

	local v11

	if absoluteCanvasSize.Y > absoluteSize.Y then
		v11 = scrollingDirection == Enum.ScrollingDirection.XY
			or scrollingDirection == Enum.ScrollingDirection.Y
	else
		v11 = false
	end

	local absoluteSize2 = scrollingFrame.AbsoluteSize
	local absolutePosition = scrollingFrame.AbsolutePosition
	local v12 = scrollingFrame.Rotation / 180 * 3.141592653589793

	if abs2(thumbstick2Vector.x) > Properties.ThumbstickDeadzone and v10 then
		scrollingFrame.CanvasPosition += Vector2.new(thumbstick2Vector.x * v9, 0)
	end

	if abs2(thumbstick2Vector.y) > Properties.ThumbstickDeadzone and v11 then
		scrollingFrame.CanvasPosition += Vector2.new(0, thumbstick2Vector.y * v9)
	end

	local vector2 = Vector2.new(cos(v12), (sin(v12)))

	local vector2_2 = Vector2.new(-sin(v12), (cos(v12)))
	local vector3 = Vector2.new(p2.X, p2.Y) - absolutePosition

	local v13 = vector3:Dot(vector2) - absoluteSize2.X / 2
	local v14 = vector3:Dot(vector2_2) - absoluteSize2.Y / 2
	local v15 = Vector2.new(abs2(v13), (abs2(v14))) - absoluteSize2 / 2
	local magnitude = Vector2.new(max(v15.x, 0), (max(v15.y, 0))).Magnitude

	if not (abs2(min(max(v15.x, v15.y), 0) + magnitude) < scrollingRadius) then
		return false
	end

	if abs2(v15.x) < abs2(v15.y) and v10 then
		scrollingFrame.CanvasPosition += Vector2.new(sign(v13) * v9, 0)
		Interface:SetArrow(sign(v13), 0)
		return true
	else
		local v20 = abs2(v15.x)

		if abs2(v15.y) <= v20 and v11 then
			scrollingFrame.CanvasPosition += Vector2.new(0, sign(v14) * v9)
			Interface:SetArrow(0, (sign(v14)))
			return true
		end
	end

	return false
end

local function findClosestOrOccludingGuiObject(p2, list, p3, p4)
	for i, item in ipairs(list) do
		if handleScrollingFrame(item, p3, p4) then
			flag = true
			break
		end

		local v9 = isSelectableGuiObject(item)

		if v9 and not v6 then
			v6 = item
		end

		if v9 then
			local absolutePosition = item.AbsolutePosition
			local v10 = item.AbsolutePosition + item.AbsoluteSize

			local v11 = 0
			local v12 = if item.AbsoluteRotation == 0 then p3 else RotatePointAroundObject(p3, item)

			if
				v12.x < absolutePosition.x
				or v12.y < absolutePosition.y
				or v12.x > v10.x
				or v12.y > v10.y
			then
				local v13

				if v12.x < absolutePosition.x then
					v13 = absolutePosition.x - v12.x
				else
					v13 = not (v12.x > v10.x) and 0 or v12.x - v10.x
				end

				local v14

				if v12.y < absolutePosition.y then
					v14 = absolutePosition.y - v12.y
				else
					v14 = not (v12.y > v10.y) and 0 or v12.y - v10.y
				end

				v11 = math.sqrt(math.pow(v13, 2) + math.pow(v14, 2))
			end

			if v11 < v8 then
				v6 = item
				v8 = v11
			end
		end

		if
			item.Visible
			and item.Active
			and item.Interactable
			and isCircleContainedInGuiObject(p3, Properties.CursorRadius * Properties.OcclusionRadiusScale, item)
		then
			v7 = item
			break
		end
	end
end

local function handleScrollingInAncestors(p2, p3, p4, p5)
	local parent = p2.Parent

	while parent and parent ~= p3 do
		if handleScrollingFrame(parent, p4, p5) then
			flag = true
			break
		end

		parent = parent.Parent
	end
end

local function processCursorPosition(p2, selectionRadius, p3)
	table.clear(scrollingFrameSet)
	v6 = nil
	v7 = nil
	v8 = 1e999

	local v9 = p2 - GuiService:GetGuiInset()

	if playerGui == nil then
		playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local v10 = not playerGui and {} or playerGui:GetGuiObjectsInCircle(v9, selectionRadius)
	local guiObjectsInCircle = CoreGui:GetGuiObjectsInCircle(v9, selectionRadius)

	flag = false

	local v11 = {
		{ CoreGui, guiObjectsInCircle },
		{ playerGui, v10 }
	}

	for i, v12 in ipairs(v11) do
		local v13 = v12[1]
		findClosestOrOccludingGuiObject(v13, v12[2], v9, p3)

		if flag then
			return nil
		end

		if v6 then
			handleScrollingInAncestors(v6, v13, v9, p3)
		end

		if flag then
			return nil
		end

		if v7 and v7 ~= v6 then
			handleScrollingInAncestors(v7, v13, v9, p3)
		end

		if flag then
			return nil
		end

		if v7 then
			return v6
		end
	end

	return v6
end

local function getMaxSpeed()
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return function(state, p2)
	local v9 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()

	local thumbstickVector = Input:GetThumbstickVector()
	local v10 = GamepadService:GetGamepadCursorPosition()

	Vector2.new()

	if state.SelectedObject == nil then
		v5 = 1
		Interface:SetCursorHighlight(false)
	end

	if flag then
		v5 = Properties.ScrollingSlowDown
	end

	local v11 = thumbstickVector * (GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative) * v5

	if v11.Magnitude > 0 then
		local v12 = v10 + v11 * p2
		local v13 = math.clamp(v12.x, 0, v9.x)
		local v14 = math.clamp(v12.y, 0, v9.y)
		v10 = Vector2.new(v13, v14)
	end

	Interface:SetCursorPosition(v10)
	GamepadService:SetGamepadCursorPosition(v10)
	state.CursorPosition = v10

	local v12 = processCursorPosition(v10, Properties.SelectionRadius, p2)

	if v12 ~= state.PreviouslySelectedObject then
		state.PreviouslySelectedObject = v12

		Interface:SetCursorHighlight(v12 ~= nil)

		if v12 then
			if v12 ~= state.SelectedObject then
				state.SelectedObject = v12
				v5 = Properties.SpeedAdjustmentTarget
			end
		else
			state.SelectedObject = nil
			v5 = 1
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
