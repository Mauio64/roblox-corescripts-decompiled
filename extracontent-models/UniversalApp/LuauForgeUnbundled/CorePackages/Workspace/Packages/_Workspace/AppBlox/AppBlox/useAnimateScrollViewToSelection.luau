local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local GamepadService = game:GetService("GamepadService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local fFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local AnimateScrollViewToSelectionHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/AnimateScrollViewToSelectionHelper")

local function useAnimateScrollViewToSelection(p2, duration, p3)
	if not fFlagUseAnimateScrollViewToSelectionHelper then
		React.useEffect(function()
			local connections = {}
			local v5 = nil

			if p2 and p2.current ~= nil then
				local current = p2.current
				local y = current.AbsolutePosition.Y
				local y2 = current.AbsoluteWindowSize.Y
				table.insert(
					connections,
					current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
						y = current.AbsolutePosition.Y
					end)
				)

				table.insert(
					connections,
					current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
						y2 = current.AbsoluteWindowSize.Y
					end)
				)

				table.insert(connections, current.SelectionChanged:Connect(function(p4, p5, instance)
					if
						instance == nil
						or not instance:IsDescendantOf(current)
						or GamepadService.GamepadCursorEnabled
					then
						return
					end

					if v5 then
						v5:Cancel()
						v5 = nil
					end

					local y3 = instance.AbsoluteSize.Y
					local v6 = instance.AbsolutePosition.Y - (y2 * 0.5 - y3 * 0.5 + y)
					local canvasPosition = current.CanvasPosition
					local vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v6)

					if UserGameSettings.ReducedMotion then
						current.CanvasPosition = vector2
						return
					end

					v5 = TweenService:Create(
						current,
						TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
						{ CanvasPosition = vector2 }
					)

					if v5 then
						v5:Play()
					end
				end))
			end

			return function()
				for k, connection in connections do
					connection:Disconnect()
				end

				if v5 then
					v5:Cancel()
				end
			end
		end, { p2, duration })

		return
	end

	local function fn()
		local v5, v6

		if p2 then
			local current = p2.current
			local v10 = if fFlagLuaAppMediaGalleryGamepadSupport then p3 else nil
			v5, v6 = AnimateScrollViewToSelectionHelper(current, duration, nil, v10)
		else
			v5 = {}
			v6 = nil
		end

		return function()
			for k, connection in v5 do
				connection:Disconnect()
			end

			if v6 then
				v6:Cancel()
			end
		end
	end

	React.useEffect(fn, { p2, duration, if fFlagLuaAppMediaGalleryGamepadSupport then p3 else nil })
end

return useAnimateScrollViewToSelection
