local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local getCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local computeVideoLiftLayout = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/VideoLift/computeVideoLiftLayout")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local getSmartFillScaleType = MomentsCommon.Utils.getSmartFillScaleType

local fFlagMomentsSmartVideoFill = MomentsCommon.Flags.FFlagMomentsSmartVideoFill

local udim = UDim2.fromScale(1, 1)
local udim2 = UDim2.fromScale(0.5, 0.5)

local function scaleLayout(data, p2)
	return {
		scale = 1 + (data.scale - 1) * p2,
		offsetY = data.offsetY * p2,
		cornerRadius = data.cornerRadius * p2
	}
end

local function useSettlingLayout(callback, p2)
	local v5, v6 = React.useBinding(callback(false))

	React.useLayoutEffect(function()
		local heartbeatConnection = nil
		local function stopSettling()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end

		local function settle()
			local value = v5:getValue()

			if value == nil or heartbeatConnection ~= nil then
				return
			end

			if p2 <= 0 then
				v6(nil)
				return
			end

			local total = 0
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				total += dt
				local v7 = total / p2

				if v7 >= 1 then
					if heartbeatConnection ~= nil then
						heartbeatConnection:Disconnect()
						heartbeatConnection = nil
					end

					v6(nil)
				else
					local v9 = value
					local v10 = 1 - TweenService:GetValue(
						v7,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out
					)
					v6({
						scale = 1 + (v9.scale - 1) * v10,
						offsetY = v9.offsetY * v10,
						cornerRadius = v9.cornerRadius * v10
					})
				end
			end)
		end

		local effect = Signals.createEffect(function(p3)
			local v7 = callback(p3)

			if v7 == nil then
				settle()
				return
			end

			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			v6(v7)
		end)
		return function()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end

			effect()
		end
	end, { callback, p2, v5, v6 })

	return v5
end

local function useVideoLiftViewModel(p2)
	local v5 = useTokens()
	local small = v5.Padding.Small
	local medium = v5.Radius.Medium
	local v6 = usePreferences().reducedMotion and 0 or v5.Time.Time_200
	local controller = MomentContext.useMoment().controller

	local v7 = React.useMemo(function()
		local signal, v8 = Signals.createSignal(0)
		local signal2, v9 = Signals.createSignal(Vector2.zero)
		return {
			getTop = signal,
			getSize = signal2,
			onChanged = function(p3)
				v8(p3.AbsolutePosition.Y)
				v9(p3.AbsoluteSize)
			end
		}
	end, {})

	local v9 = useSettlingLayout(React.useMemo(function()
		return Signals.createComputed(function(p3)
			local v9 = getCommentsSheetStore(false)

			if p2 == nil or v9.getFeedItemId(p3) ~= p2 then
				return nil
			end

			local videoLift = v9.getVideoLift(p3)

			if videoLift == nil then
				return nil
			end

			local v11 = {
				lift = videoLift,
				itemTop = v7.getTop(p3),
				itemSize = v7.getSize(p3),
				resolution = 0,
				scaleType = 0,
				padding = 0,
				cornerRadius = 0
			}
			local v12 = if controller ~= nil then controller.getState(p3).resolution else nil
			v11.resolution = v12
			local v13

			if fFlagMomentsSmartVideoFill then
				local mediaScaleType = GetMomentsPreferencesStore(false).getMediaScaleType(p3)
				local size = v7.getSize(p3)
				local v15 = if controller ~= nil then controller.getState(p3).resolution else nil
				v13 = getSmartFillScaleType(mediaScaleType, size, v15)
			else
				v13 = GetMomentsPreferencesStore(false).getMediaScaleType(p3)
			end

			v11.scaleType = v13

			v11.padding = small
			v11.cornerRadius = medium
			return computeVideoLiftLayout(v11)
		end)
	end, {
		p2 or false,
		controller or false,
		v7,
		small,
		medium
	}), v6)

	return React.useMemo(function()
		return {
			size = v9:map(function(p3)
				if p3 == nil then
					return udim
				end

				return (UDim2.fromScale(p3.scale, p3.scale))
			end),
			position = v9:map(function(p3)
				if p3 == nil then
					return udim2
				end

				return (UDim2.new(0.5, 0, 0.5, p3.offsetY))
			end),
			mediaSurface = {
				cornerRadius = v9:map(function(p3)
					return UDim.new(0, p3 == nil and 0 or p3.cornerRadius)
				end)
			},
			onItemRectChanged = v7.onChanged
		}
	end, { v9, v7 })
end

return useVideoLiftViewModel
