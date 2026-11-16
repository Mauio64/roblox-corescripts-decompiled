local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local MomentContext = require(script.Parent.Parent.MomentContext)
local computeVideoLiftLayout = require(script.Parent.computeVideoLiftLayout)

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local getSmartFillScaleType = MomentsCommon.Utils.getSmartFillScaleType

local FFlagMomentsSmartVideoFill = MomentsCommon.Flags.FFlagMomentsSmartVideoFill

local udim = UDim2.fromScale(1, 1)
local udim2 = UDim2.fromScale(0.5, 0.5)

local function scaleLayout(value, p: number) -- 1 equivalent call inferred from this helper
	return {
		scale = 1 + (value.scale - 1) * p,
		offsetY = value.offsetY * p,
		cornerRadius = value.cornerRadius * p
	}
end

local function useSettlingLayout(callback, p: number)
	local v, v2 = React.useBinding(callback(false))

	React.useLayoutEffect(function()
		local heartbeatConnection = nil
		local function stopSettling() -- 3 equivalent calls inferred from this helper
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end

		local function settle()
			local value = v:getValue()

			if value == nil or heartbeatConnection ~= nil then
				return
			end

			if p <= 0 then
				v2(nil)
				return
			end

			local total = 0
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
				total += dt
				local v3 = total / p

				if v3 >= 1 then
					stopSettling() -- inferred equivalent call
					v2(nil)
				else
					v2(scaleLayout( -- inferred equivalent call
						value,
						1 - TweenService:GetValue(v3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					))
				end
			end)
		end

		local effect = Signals.createEffect(function(p2)
			local v3 = callback(p2)

			if v3 == nil then
				settle()
				return
			end

			stopSettling() -- inferred equivalent call
			v2(v3)
		end)
		return function()
			stopSettling() -- inferred equivalent call
			effect()
		end
	end, { callback, p, v, v2 })

	return v
end

local function useVideoLiftViewModel(p: string?)
	local v = useTokens()
	local small = v.Padding.Small
	local medium = v.Radius.Medium
	local v2 = usePreferences().reducedMotion and 0 or v.Time.Time_200
	local controller = MomentContext.useMoment().controller

	local v3 = React.useMemo(function()
		local signal, v3 = Signals.createSignal(0)
		local signal2, v4 = Signals.createSignal(Vector2.zero)
		return {
			getTop = signal,
			getSize = signal2,
			onChanged = function(p2)
				v3(p2.AbsolutePosition.Y)
				v4(p2.AbsoluteSize)
			end
		}
	end, {})

	local v4 = useSettlingLayout(React.useMemo(function()
		return Signals.createComputed(function(p2)
			local commentsSheetStore = getCommentsSheetStore(false)

			if p == nil or commentsSheetStore.getFeedItemId(p2) ~= p then
				return nil
			end

			local videoLift = commentsSheetStore.getVideoLift(p2)

			if videoLift == nil then
				return nil
			end

			local v4 = {
				lift = videoLift,
				itemTop = v3.getTop(p2),
				itemSize = v3.getSize(p2),
				resolution = 0,
				scaleType = 0,
				padding = 0,
				cornerRadius = 0
			}
			local resolution

			if controller ~= nil then
				resolution = controller.getState(p2).resolution
			end

			v4.resolution = resolution
			local scaleType

			if FFlagMomentsSmartVideoFill then
				local mediaScaleType = GetMomentsPreferencesStore(false).getMediaScaleType(p2)
				local size = v3.getSize(p2)
				local v5

				if controller ~= nil then
					v5 = controller.getState(p2).resolution
				end

				scaleType = getSmartFillScaleType(mediaScaleType, size, v5)
			else
				scaleType = GetMomentsPreferencesStore(false).getMediaScaleType(p2)
			end

			v4.scaleType = scaleType

			v4.padding = small
			v4.cornerRadius = medium
			return computeVideoLiftLayout(v4)
		end)
	end, {
		p or false,
		controller or false,
		v3,
		small,
		medium
	}), v2)

	return React.useMemo(function()
		return {
			size = v4:map(function(p2)
				if p2 == nil then
					return udim
				end

				return (UDim2.fromScale(p2.scale, p2.scale))
			end),
			position = v4:map(function(p2)
				if p2 == nil then
					return udim2
				end

				return (UDim2.new(0.5, 0, 0.5, p2.offsetY))
			end),
			mediaSurface = {
				cornerRadius = v4:map(function(p2)
					return UDim.new(0, p2 == nil and 0 or p2.cornerRadius)
				end)
			},
			onItemRectChanged = v3.onChanged
		}
	end, { v4, v3 })
end

return useVideoLiftViewModel
