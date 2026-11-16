local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")

local v = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v = AppLifecycleObserverService
end)

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local MediaPlayback = require(parent.MediaPlayback)
local enableAudioPlaybackInApp = MediaPlayback.enableAudioPlaybackInApp

local MomentsCommon = require(parent.MomentsCommon)
local Media = MomentsCommon.Media
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy

require(Moments.Components.Feed.FeedTypes)
local createFeedMediaSource = require(script.Parent.createFeedMediaSource)

local function shouldPauseWhenAppHidden(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end

local function defaultCreateCoordinator(p)
	enableAudioPlaybackInApp()

	local momentMediaAudioOutput = Instance.new("AudioDeviceOutput")
	momentMediaAudioOutput.Name = "MomentMediaAudioOutput"
	momentMediaAudioOutput.Parent = CoreGui

	local folder = Instance.new("Folder")
	folder.Name = "MomentMediaRoot_" .. HttpService:GenerateGUID(false)
	folder.Parent = CoreGui

	local mediaPreloadCoordinator = Media.createMediaPreloadCoordinator(
		p,
		Media.selectPreloadPolicy(),
		Media.mediaTelemetry.noopSink,
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
	local v2

	if FFlagMomentsAutoplayAmpPolicy then
		v2 = useSignalState(GetMomentsCapabilities(false).getIsAutoPlayEnabled)
	else
		v2 = nil
	end

	local playbackActive = props.playbackActive
	local createCoordinator = props.createCoordinator or defaultCreateCoordinator

	local v3 = React.useMemo(function()
		local signal, set = Signals.createSignal(playbackActive)
		return { get = signal, set = set }
	end, {})
	local v4

	if FFlagMomentsAutoplayAmpPolicy then
		v4 = React.useMemo(function()
			local signal, set = Signals.createSignal(v2)
			return { get = signal, set = set }
		end, {})
	else
		v4 = nil
	end

	local v5 = React.useMemo(function()
		local signal, set = Signals.createSignal(true)
		return { get = signal, set = set }
	end, {})

	React.useEffect(function()
		v3.set(playbackActive)
	end, { playbackActive, v3 })

	if FFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function()
			v4.set(v2)
		end, { v2, v4 })
	end

	React.useEffect(function()
		if not shouldPauseWhenAppHidden() then -- inferred equivalent call
			return
		end

		local function onHidden()
			v5.set(false)
		end
		local function onShown()
			v5.set(true)
		end
		local connections = {}

		if v ~= nil then
			table.insert(connections, v.OnHide:Connect(onHidden))
			table.insert(connections, v.OnUnhide:Connect(onShown))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v5 })

	local v6 = React.useMemo(function()
		return function(p)
			return v3.get(p) and v5.get(p)
		end
	end, { v3, v5 })

	local useMemo = React.useMemo
	local function fn()
		local v7

		if FFlagMomentsAutoplayAmpPolicy then
			v7 = v4.get
		end

		return createCoordinator((createFeedMediaSource(pager, v6, v7)))
	end

	local v7

	if FFlagMomentsAutoplayAmpPolicy then
		v7 = v4
	end

	local v8 = useMemo(fn, { pager, createCoordinator, v6, v7 })

	React.useEffect(function()
		return function()
			v8.dispose()
		end
	end, { v8 })

	React.useEffect(function()
		local onMediaItemLoadAttempted = props.onMediaItemLoadAttempted
		local onMediaItemFailed = props.onMediaItemFailed

		if onMediaItemLoadAttempted == nil and onMediaItemFailed == nil then
			return
		end

		local set = {}
		local set2 = {}
		local v9 = false
		local effect = Signals.createEffect(function(p)
			local controllerMap = v8.provider.getControllerMap(p)

			for k, controller in controllerMap do
				if onMediaItemLoadAttempted ~= nil and not set[k] then
					set[k] = true

					task.defer(function()
						if not v9 then
							onMediaItemLoadAttempted(k)
						end
					end)
				end

				local v10

				if onMediaItemFailed ~= nil then
					v10 = controller.getState(p)
				end

				if v10 == nil or v10.readiness ~= "Failed" or set2[k] then
					continue
				end

				set2[k] = true

				local failureReason = v10.failureReason
				task.defer(function()
					if not v9 then
						onMediaItemFailed(k, failureReason)
					end
				end)
			end
		end)

		return function()
			v9 = true
			effect()
		end
	end, { v8, props.onMediaItemLoadAttempted, props.onMediaItemFailed })

	return React.createElement(
		Media.MediaPreloadProvider.Provider,
		{ controllerProvider = v8.provider },
		props.children
	)
end

return MomentMediaCoordinatorProvider
