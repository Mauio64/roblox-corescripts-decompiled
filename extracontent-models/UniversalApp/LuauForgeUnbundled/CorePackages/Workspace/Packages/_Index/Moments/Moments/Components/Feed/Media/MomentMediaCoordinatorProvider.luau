local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")

local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact").useSignalState

local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MediaPlayback").enableAudioPlaybackInApp

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local media = MomentsCommon.Media
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local fFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local createFeedMediaSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/createFeedMediaSource")

local function shouldPauseWhenAppHidden(): boolean
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end

local function defaultCreateCoordinator(p2)
	enableAudioPlaybackInApp()

	local momentMediaAudioOutput = Instance.new("AudioDeviceOutput")
	momentMediaAudioOutput.Name = "MomentMediaAudioOutput"
	momentMediaAudioOutput.Parent = CoreGui

	local folder = Instance.new("Folder")
	folder.Name = "MomentMediaRoot_" .. HttpService:GenerateGUID(false)
	folder.Parent = CoreGui

	local mediaPreloadCoordinator = media.createMediaPreloadCoordinator(
		p2,
		media.selectPreloadPolicy(),
		media.mediaTelemetry.noopSink,
		momentMediaAudioOutput,
		{ runService = RunService, contentProvider = ContentProvider },
		{ parent = folder }
	)

	return {
		provider = mediaPreloadCoordinator,
		dispose = function()
			mediaPreloadCoordinator.dispose()
			momentMediaAudioOutput:Destroy()
			folder:Destroy()
		end
	}
end

local function MomentMediaCoordinatorProvider(props)
	local pager = props.pager
	local v6

	if fFlagMomentsAutoplayAmpPolicy then
		v6 = useSignalState(getMomentsCapabilities(false).getIsAutoPlayEnabled)
	else
		v6 = nil
	end

	local playbackActive = props.playbackActive
	local createCoordinator = props.createCoordinator or defaultCreateCoordinator

	local v7 = React.useMemo(function()
		local signal, v8 = Signals.createSignal(playbackActive)
		return { get = signal, set = v8 }
	end, {})
	local v8

	if fFlagMomentsAutoplayAmpPolicy then
		v8 = React.useMemo(function()
			local signal, v9 = Signals.createSignal(v6)
			return { get = signal, set = v9 }
		end, {})
	else
		v8 = nil
	end

	local v9 = React.useMemo(function()
		local signal, v10 = Signals.createSignal(true)
		return { get = signal, set = v10 }
	end, {})

	React.useEffect(function()
		v7.set(playbackActive)
	end, { playbackActive, v7 })

	if fFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function()
			v8.set(v6)
		end, { v6, v8 })
	end

	React.useEffect(function()
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop then
			return
		end

		local function onHidden()
			v9.set(false)
		end
		local function onShown()
			v9.set(true)
		end
		local connections = {}

		if v5 ~= nil then
			table.insert(connections, v5.OnHide:Connect(onHidden))
			table.insert(connections, v5.OnUnhide:Connect(onShown))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v9 })

	local v10 = React.useMemo(function()
		return function(p2)
			return v7.get(p2) and v9.get(p2)
		end
	end, { v7, v9 })

	local function fn()
		local v14 = if fFlagMomentsAutoplayAmpPolicy then v8.get else nil
		return createCoordinator((createFeedMediaSource(pager, v10, v14)))
	end

	local v13 = React.useMemo(fn, {
		pager,
		createCoordinator,
		v10,
		if fFlagMomentsAutoplayAmpPolicy then v8 else nil
	})

	React.useEffect(function()
		return function()
			v13.dispose()
		end
	end, { v13 })

	React.useEffect(function()
		local onMediaItemLoadAttempted = props.onMediaItemLoadAttempted
		local onMediaItemFailed = props.onMediaItemFailed

		if onMediaItemLoadAttempted == nil and onMediaItemFailed == nil then
			return
		end

		local set = {}
		local set2 = {}
		local v14 = false
		local effect = Signals.createEffect(function(p2)
			local controllerMap = v13.provider.getControllerMap(p2)

			for k, controller in controllerMap do
				if onMediaItemLoadAttempted ~= nil and not set[k] then
					set[k] = true

					task.defer(function()
						if not v14 then
							onMediaItemLoadAttempted(k)
						end
					end)
				end

				local v15 = if onMediaItemFailed ~= nil then controller.getState(p2) else nil

				if v15 == nil or v15.readiness ~= "Failed" or set2[k] then
					continue
				end

				set2[k] = true

				local failureReason = v15.failureReason
				task.defer(function()
					if not v14 then
						onMediaItemFailed(k, failureReason)
					end
				end)
			end
		end)

		return function()
			v14 = true
			effect()
		end
	end, { v13, props.onMediaItemLoadAttempted, props.onMediaItemFailed })

	return React.createElement(
		media.MediaPreloadProvider.Provider,
		{ controllerProvider = v13.provider },
		props.children
	)
end

return MomentMediaCoordinatorProvider
