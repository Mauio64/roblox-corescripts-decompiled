local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent
local CenterOnFocusScroll = require(AppBlox.CenterOnFocusScroll)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local defineFastFlag = game:DefineFastFlag("AnimateScrollViewIgnoreStaleSelection", false)

function AnimateScrollViewToSelectionHelper(instance, duration: number, callback, flag: boolean?)
	local connections = {}
	local v = nil

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

	table.insert(connections, instance.SelectionChanged:Connect(function(_, _, instance2)
		if
			not instance2
			or not instance2:IsDescendantOf(instance)
			or GamepadService.GamepadCursorEnabled
			or defineFastFlag and instance2 ~= GuiService.SelectedCoreObject and instance2 ~= GuiService.SelectedObject
		then
			return
		end

		if v then
			v:Cancel()
			v = nil
		end

		local y3 = instance2.AbsoluteSize.Y
		local y4 = instance2.AbsolutePosition.Y
		local canvasPosition = instance.CanvasPosition
		local vector2

		if FFlagLuaAppMediaGalleryGamepadSupport and flag then
			local revealOnlyCanvasY = CenterOnFocusScroll.getRevealOnlyCanvasY(y4, y3, canvasPosition, y, y2)

			if revealOnlyCanvasY == nil then
				return
			end

			vector2 = Vector2.new(canvasPosition.X, revealOnlyCanvasY)
		else
			local v2 = y4 - (y2 * 0.5 - y3 * 0.5 + y)
			vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v2)
		end

		if UserGameSettings.ReducedMotion or callback and callback() then
			instance.CanvasPosition = vector2
			return
		end

		v = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CanvasPosition = vector2
		})

		if v then
			v:Play()
		end
	end))

	return connections, v
end

return AnimateScrollViewToSelectionHelper
