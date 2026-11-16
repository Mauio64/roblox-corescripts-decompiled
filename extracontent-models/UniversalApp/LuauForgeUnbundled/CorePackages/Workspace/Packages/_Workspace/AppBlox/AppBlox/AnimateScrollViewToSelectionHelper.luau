local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

local CenterOnFocusScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/CenterOnFocusScroll")
local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport
local defineFastFlag = game:DefineFastFlag("AnimateScrollViewIgnoreStaleSelection", false)

function LUAUFORGE_MODULE_GLOBALS_alI_AnimateScrollViewToSelectionHelper(instance, duration, callback, p2)
	local connections = {}
	local v5 = nil

	if not instance then
		return connections
	end

	local y = instance.AbsolutePosition.Y
	local y2 = instance.AbsoluteWindowSize.Y
	table.insert(connections, instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		y = instance.AbsolutePosition.Y
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
		y2 = instance.AbsoluteWindowSize.Y
	end))

	table.insert(connections, instance.SelectionChanged:Connect(function(p3, p4, instance2)
		if
			not instance2
			or not instance2:IsDescendantOf(instance)
			or GamepadService.GamepadCursorEnabled
			or defineFastFlag
			and instance2 ~= GuiService.SelectedCoreObject
			and instance2 ~= GuiService.SelectedObject
		then
			return
		end

		if v5 then
			v5:Cancel()
			v5 = nil
		end

		local y3 = instance2.AbsoluteSize.Y
		local y4 = instance2.AbsolutePosition.Y
		local canvasPosition = instance.CanvasPosition
		local vector2

		if fFlagLuaAppMediaGalleryGamepadSupport and p2 then
			local revealOnlyCanvasY = CenterOnFocusScroll.getRevealOnlyCanvasY(y4, y3, canvasPosition, y, y2)

			if revealOnlyCanvasY == nil then
				return
			end

			vector2 = Vector2.new(canvasPosition.X, revealOnlyCanvasY)
		else
			local v6 = y4 - (y2 * 0.5 - y3 * 0.5 + y)
			vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v6)
		end

		if UserGameSettings.ReducedMotion or callback and callback() then
			instance.CanvasPosition = vector2
			return
		end

		v5 = TweenService:Create(
			instance,
			TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
			{ CanvasPosition = vector2 }
		)

		if v5 then
			v5:Play()
		end
	end))

	return connections, v5
end

return LUAUFORGE_MODULE_GLOBALS_alI_AnimateScrollViewToSelectionHelper
