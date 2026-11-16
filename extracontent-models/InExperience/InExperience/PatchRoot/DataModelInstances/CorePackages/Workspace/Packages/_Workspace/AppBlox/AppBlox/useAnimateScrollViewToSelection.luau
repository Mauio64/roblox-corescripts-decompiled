local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")
local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent
local React = require(parent.React)
local GamepadService = game:GetService("GamepadService")

local SharedFlags = require(parent.SharedFlags)
local FFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local AnimateScrollViewToSelectionHelper = require(AppBlox.AnimateScrollViewToSelectionHelper)

local function useAnimateScrollViewToSelection(p, duration: number, flag: boolean?)
	if not FFlagUseAnimateScrollViewToSelectionHelper then
		React.useEffect(function()
			local connections = {}
			local v = nil

			if p and p.current ~= nil then
				local current = p.current
				local y = current.AbsolutePosition.Y
				local y2 = current.AbsoluteWindowSize.Y
				table.insert(connections, current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					y = current.AbsolutePosition.Y
				end))

				table.insert(connections, current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					y2 = current.AbsoluteWindowSize.Y
				end))

				table.insert(connections, current.SelectionChanged:Connect(function(_, _, instance)
					if
						instance == nil
						or not instance:IsDescendantOf(current)
						or GamepadService.GamepadCursorEnabled
					then
						return
					end

					if v then
						v:Cancel()
						v = nil
					end

					local y3 = instance.AbsoluteSize.Y
					local v2 = instance.AbsolutePosition.Y - (y2 * 0.5 - y3 * 0.5 + y)
					local canvasPosition = current.CanvasPosition
					local vector2 = Vector2.new(canvasPosition.X, canvasPosition.Y + v2)

					if UserGameSettings.ReducedMotion then
						current.CanvasPosition = vector2
						return
					end

					v = TweenService:Create(
						current,
						TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
						{ CanvasPosition = vector2 }
					)

					if v then
						v:Play()
					end
				end))
			end

			return function()
				for _, connection in connections do
					connection:Disconnect()
				end

				if v then
					v:Cancel()
				end
			end
		end, { p, duration })

		return
	end

	local useEffect = React.useEffect
	local function fn()
		local v, v2

		if p then
			local current = p.current
			local v3

			if FFlagLuaAppMediaGalleryGamepadSupport then
				v3 = flag
			end

			v, v2 = AnimateScrollViewToSelectionHelper(current, duration, nil, v3)
		else
			v = {}
			v2 = nil
		end

		return function()
			for _, connection in v do
				connection:Disconnect()
			end

			if v2 then
				v2:Cancel()
			end
		end
	end

	local v

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v = flag
	end

	useEffect(fn, { p, duration, v })
end

return useAnimateScrollViewToSelection
