local scriptParent = script.Parent
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local GamepadService = game:GetService("GamepadService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = nil
local Input = require(scriptParent.Input)
local Interface = require(scriptParent.Interface)
local Properties = require(scriptParent.Properties)
local isCircleContainedInGuiObject = require(scriptParent.isCircleContainedInGuiObject)
local RotatePointAroundObject = require(scriptParent.RotatePointAroundObject)
local n1 = 1
local u13 = false
local sin = math.sin
local cos = math.cos
local _ = math.abs
local max = math.max
local min = math.min
local sign = math.sign
local abs = math.abs
local t1 = {}
local u22 = nil
local u23 = nil
local n2 = 1e999

local function isSelectableGuiObject(p1) -- line: 36
	if not p1:IsA("GuiButton") and not p1:IsA("TextBox") then
		return false
	end

	if not p1.Active or not p1.Selectable then
		return false
	end

	if p1.AbsoluteSize.Magnitude == 0 then
		return false
	end

	return true
end
local function contains(p2, p3, p4) -- line: 50
	return p2.x >= p3.x and (p2.y >= p3.y and (p2.x <= p4.x and p2.y <= p4.y))
end
local function handleScrollingFrame(p5, p6, p7) -- line: 54
	-- upvalues: t1 (copy), Input (copy), Properties (copy), abs (copy), cos (copy), sin (copy), max (copy), min (copy), sign (copy), Interface (copy)
	if not p5:IsA("ScrollingFrame") then
		return false
	end

	if not p5.ScrollingEnabled then
		return false
	end

	if t1[p5] then
		return false
	end

	t1[p5] = true

	local Thumbstick2Vector = Input:GetThumbstick2Vector()
	local v40 = Properties.ScrollingSpeed * p7
	local ScrollingRadius = Properties.ScrollingRadius
	local AbsoluteCanvasSize = p5.AbsoluteCanvasSize
	local AbsoluteSize = p5.AbsoluteSize
	local ScrollingDirection = p5.ScrollingDirection
	local v45 = AbsoluteCanvasSize.X > AbsoluteSize.X and (ScrollingDirection == Enum.ScrollingDirection.XY or ScrollingDirection == Enum.ScrollingDirection.X)
	local v46 = AbsoluteCanvasSize.Y > AbsoluteSize.Y and (ScrollingDirection == Enum.ScrollingDirection.XY or ScrollingDirection == Enum.ScrollingDirection.Y)
	local AbsoluteSize2 = p5.AbsoluteSize
	local AbsolutePosition = p5.AbsolutePosition
	local v49 = p5.Rotation / 180 * 3.141592653589793

	if abs(Thumbstick2Vector.x) > Properties.ThumbstickDeadzone and v45 then
		p5.CanvasPosition = p5.CanvasPosition + Vector2.new(Thumbstick2Vector.x * v40, 0)
	end

	if abs(Thumbstick2Vector.y) > Properties.ThumbstickDeadzone and v46 then
		p5.CanvasPosition = p5.CanvasPosition + Vector2.new(0, Thumbstick2Vector.y * v40)
	end

	local vector2 = Vector2.new(cos(v49), (sin(v49)))
	local vector2_2 = Vector2.new(-sin(v49), (cos(v49)))
	local v52 = Vector2.new(p6.X, p6.Y) - AbsolutePosition
	local v53 = v52:Dot(vector2) - AbsoluteSize2.X / 2
	local v54 = v52:Dot(vector2_2) - AbsoluteSize2.Y / 2
	local v55 = Vector2.new(abs(v53), (abs(v54))) - AbsoluteSize2 / 2
	local Magnitude = Vector2.new(max(v55.x, 0), (max(v55.y, 0))).Magnitude

	if ScrollingRadius > abs(min(max(v55.x, v55.y), 0) + Magnitude) then
		if abs(v55.x) < abs(v55.y) and v45 then
			p5.CanvasPosition = p5.CanvasPosition + Vector2.new(sign(v53) * v40, 0)
			Interface:SetArrow(sign(v53), 0)

			return true
		end

		if abs(v55.x) >= abs(v55.y) and v46 then
			p5.CanvasPosition = p5.CanvasPosition + Vector2.new(0, sign(v54) * v40)
			Interface:SetArrow(0, (sign(v54)))

			return true
		end
	end

	return false
end
local function findClosestOrOccludingGuiObject(_, t2: {[any]: any}, p9, p10) -- line: 119
	-- upvalues: handleScrollingFrame (copy), u13 (ref), u22 (ref), RotatePointAroundObject (copy), n2 (ref), isCircleContainedInGuiObject (copy), Properties (copy), u23 (ref)
	for _, v in ipairs(t2) do
		if handleScrollingFrame(v, p9, p10) then
			u13 = true

			return
		end

		if ((if v:IsA("GuiButton") or v:IsA("TextBox") then not not v.Active and (if v.Selectable then v.AbsoluteSize.Magnitude ~= 0 else false) else false)) and not u22 then
			u22 = v
		end

		if if v:IsA("GuiButton") or v:IsA("TextBox") then not not v.Active and if v.Selectable then v.AbsoluteSize.Magnitude ~= 0 else false else false then
			local AbsolutePosition = v.AbsolutePosition
			local v64 = v.AbsolutePosition + v.AbsoluteSize
			local n3 = 0
			local v66 = if v.AbsoluteRotation == 0 then p9 else RotatePointAroundObject(p9, v)

			if v66.x < AbsolutePosition.x or v66.y < AbsolutePosition.y or v66.x > v64.x or v66.y > v64.y then
				local v67 = if not (v66.x < AbsolutePosition.x) then not (v66.x > v64.x) and 0 or v66.x - v64.x else AbsolutePosition.x - v66.x
				local v68 = if not (v66.y < AbsolutePosition.y) then not (v66.y > v64.y) and 0 or v66.y - v64.y else AbsolutePosition.y - v66.y

				n3 = math.sqrt(math.pow(v67, 2) + math.pow(v68, 2))
			end

			if n3 < n2 then
				u22 = v
				n2 = n3
			end
		end

		if v.Visible and v.Active and v.Interactable and isCircleContainedInGuiObject(p9, Properties.CursorRadius * Properties.OcclusionRadiusScale, v) then
			u23 = v

			return
		end
	end
end
local function handleScrollingInAncestors(p11, p12, p13, p14) -- line: 172
	-- upvalues: handleScrollingFrame (copy), u13 (ref)
	local p11Parent = p11.Parent

	while p11Parent and p11Parent ~= p12 do
		if handleScrollingFrame(p11Parent, p13, p14) then
			u13 = true

			return
		end

		p11Parent = p11Parent.Parent
	end
end
local function processCursorPosition(p15, p16, p17) -- line: 183
	-- upvalues: t1 (copy), u22 (ref), u23 (ref), n2 (ref), GuiService (copy), PlayerGui (ref), Players (copy), CoreGui (copy), u13 (ref), findClosestOrOccludingGuiObject (copy), handleScrollingInAncestors (copy)
	table.clear(t1)
	u22 = nil
	u23 = nil
	n2 = 1e999

	local v77 = p15 - GuiService:GetGuiInset()

	if PlayerGui == nil then
		PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local v78 = if not PlayerGui then {} else PlayerGui:GetGuiObjectsInCircle(v77, p16)
	local GuiObjectsInCircle = CoreGui:GetGuiObjectsInCircle(v77, p16)

	u13 = false

	local t3 = {
		{
			CoreGui,
			GuiObjectsInCircle
		},
		{
			PlayerGui,
			v78
		}
	}

	for _, v in ipairs(t3) do
		local v83 = v[1]
		local v84 = v[2]

		findClosestOrOccludingGuiObject(v83, v84, v77, p17)

		if u13 then
			return nil
		end

		if u22 then
			handleScrollingInAncestors(u22, v83, v77, p17)
		end

		if u13 then
			return nil
		end

		if u23 and u23 ~= u22 then
			handleScrollingInAncestors(u23, v83, v77, p17)
		end

		if u13 then
			return nil
		end

		if u23 then
			return u22
		end
	end

	return u22
end
local function getMaxSpeed() -- line: 248
	-- upvalues: GuiService (copy), Properties (copy)
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return function(p18, p19) -- line: 253
	-- upvalues: GuiService (copy), Input (copy), GamepadService (copy), n1 (ref), Interface (copy), u13 (ref), Properties (copy), processCursorPosition (copy), CoreGui (copy), PlayerGui (ref)
	local v87 = GuiService:GetScreenResolution() + GuiService:GetGuiInset()
	local ThumbstickVector = Input:GetThumbstickVector()
	local GamepadCursorPosition = GamepadService:GetGamepadCursorPosition()

	Vector2.new()

	if p18.SelectedObject == nil then
		n1 = 1
		Interface:SetCursorHighlight(false)
	end

	if u13 then
		n1 = Properties.ScrollingSlowDown
	end

	local v90 = ThumbstickVector * (GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative) * n1

	if v90.Magnitude > 0 then
		local v91 = GamepadCursorPosition + v90 * p19
		local v92 = math.clamp(v91.x, 0, v87.x)
		local v93 = math.clamp(v91.y, 0, v87.y)

		GamepadCursorPosition = Vector2.new(v92, v93)
	end

	Interface:SetCursorPosition(GamepadCursorPosition)
	GamepadService:SetGamepadCursorPosition(GamepadCursorPosition)
	p18.CursorPosition = GamepadCursorPosition

	local v94 = processCursorPosition(GamepadCursorPosition, Properties.SelectionRadius, p19)

	if v94 ~= p18.PreviouslySelectedObject then
		p18.PreviouslySelectedObject = v94
		Interface:SetCursorHighlight(v94 ~= nil)

		if v94 then
			if v94 ~= p18.SelectedObject then
				p18.SelectedObject = v94
				n1 = Properties.SpeedAdjustmentTarget
			end
		else
			p18.SelectedObject = nil
			n1 = 1
		end

		if p18.SelectedObject == nil then
			GuiService.SelectedObject = nil
			GuiService.SelectedCoreObject = nil

			return
		end

		if p18.SelectedObject:IsDescendantOf(CoreGui) then
			GuiService.SelectedCoreObject = p18.SelectedObject
			GuiService.SelectedObject = nil

			return
		end

		if p18.SelectedObject:IsDescendantOf(PlayerGui) then
			GuiService.SelectedObject = p18.SelectedObject
			GuiService.SelectedCoreObject = nil
		end
	end
end
