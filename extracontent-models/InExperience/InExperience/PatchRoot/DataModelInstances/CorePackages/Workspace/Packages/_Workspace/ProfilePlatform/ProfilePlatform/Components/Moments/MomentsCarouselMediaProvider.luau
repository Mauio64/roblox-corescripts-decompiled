local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")

local v = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v = AppLifecycleObserverService
end)

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MediaPlayback = require(parent.MediaPlayback)
local enableAudioPlaybackInApp = MediaPlayback.enableAudioPlaybackInApp

local MomentsCommon = require(parent.MomentsCommon)
local Media = MomentsCommon.Media
local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
require(parent.DataHydration.MomentsStoreTypes)
local ToMediaItem = require(parent.Moments.ToMediaItem)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster

local useSignalState = SignalsReact.useSignalState

local function shouldPauseWhenAppHidden(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end

local function defaultCreateCoordinator(p, masterVolume: number?)
	enableAudioPlaybackInApp()

	local profileMomentsAudioOutput = Instance.new("AudioDeviceOutput")
	profileMomentsAudioOutput.Name = "ProfileMomentsAudioOutput"
	profileMomentsAudioOutput.Parent = CoreGui

	local profileMomentsMediaHost = Instance.new("Folder")

	if profileMomentsMediaHost ~= nil then
		profileMomentsMediaHost.Name = "ProfileMomentsMediaHost"
		profileMomentsMediaHost.Parent = CoreGui
	end

	local mediaPreloadCoordinator = Media.createMediaPreloadCoordinator(
		p,
		Media.selectPreloadPolicy(),
		Media.mediaTelemetry.noopSink,
		profileMomentsAudioOutput,
		{ runService = RunService, contentProvider = ContentProvider },
		{ parent = profileMomentsMediaHost, masterVolume = masterVolume }
	)

	local flag = false

	return {
		provider = mediaPreloadCoordinator,
		dispose = function()
			if flag then
				return
			end

			flag = true
			mediaPreloadCoordinator.dispose()
			profileMomentsAudioOutput:Destroy()

			if profileMomentsMediaHost ~= nil then
				profileMomentsMediaHost:Destroy()
			end
		end
	}
end

local function MomentsCarouselMediaProvider(props)
	local activeIndex = props.activeIndex
	local playbackActive = props.playbackActive
	local v2

	if FFlagMomentsAutoplayAmpPolicy then
		v2 = useSignalState(GetMomentsCapabilities(false).getIsAutoPlayEnabled)
	else
		v2 = nil
	end

	local v3 = React.useMemo(function()
		local signal, set = Signals.createSignal(activeIndex)
		return { get = signal, set = set }
	end, {})

	local v4 = React.useMemo(function()
		local signal, set = Signals.createSignal(playbackActive)
		return { get = signal, set = set }
	end, {})
	local v5

	if FFlagMomentsAutoplayAmpPolicy then
		v5 = React.useMemo(function()
			local signal, set = Signals.createSignal(v2)
			return { get = signal, set = set }
		end, {})
	else
		v5 = nil
	end

	local v6 = React.useMemo(function()
		local signal, set = Signals.createSignal(true)
		return { get = signal, set = set }
	end, {})

	React.useEffect(function()
		v3.set(activeIndex)
	end, { activeIndex, v3 })

	React.useEffect(function()
		v4.set(playbackActive)
	end, { playbackActive, v4 })

	if FFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function()
			v5.set(v2)
		end, { v2, v5 })
	end

	React.useEffect(function()
		if not shouldPauseWhenAppHidden() or v == nil then -- inferred equivalent call
			return
		end

		local function onHidden()
			v6.set(false)
		end
		local function onShown()
			v6.set(true)
		end
		local v7 = { v.OnHide:Connect(onHidden), v.OnUnhide:Connect(onShown) }

		return function()
			for _, connection in v7 do
				connection:Disconnect()
			end
		end
	end, { v6 })

	local items = React.useMemo(function()
		local result = {}

		for _, moment in props.moments do
			local toMediaItem = ToMediaItem({ kind = "moment", moment = moment })

			if toMediaItem == nil then
				continue
			end

			toMediaItem.cornerRadius = props.mediaCornerRadius

			if FFlagProfileMomentSceneOutfitPoster and moment.metadata.isMomentScene == true then
				toMediaItem.captureType = Enum.CaptureType.Screenshot
				toMediaItem.posterContent = nil
			end

			table.insert(result, toMediaItem)
		end

		return result
	end, { props.moments, props.mediaCornerRadius })

	local getPlaybackActive = React.useMemo(function()
		return function(p)
			return v4.get(p) and v6.get(p)
		end
	end, { v4, v6 })

	local useMemo = React.useMemo
	local function fn()
		local v7 = {
			getActiveIndex = v3.get,
			getItems = function(_)
				return items
			end,
			getPlaybackActive = getPlaybackActive,
			getCanAutoPlay = 0
		}
		local getCanAutoPlay

		if FFlagMomentsAutoplayAmpPolicy then
			getCanAutoPlay = v5.get
		end

		v7.getCanAutoPlay = getCanAutoPlay
		return v7
	end

	local v7

	if FFlagMomentsAutoplayAmpPolicy then
		v7 = v5
	end

	local v8 = useMemo(fn, { items, v3, getPlaybackActive, v7 })

	local createCoordinator = props.createCoordinator or defaultCreateCoordinator

	local v9 = React.useMemo(function()
		return createCoordinator(v8, 0)
	end, { v8, createCoordinator, 0 })

	React.useEffect(function()
		return function()
			v9.dispose()
		end
	end, { v9 })
	React.useImperativeHandle(props.handoffRef, function()
		return { release = v9.dispose }
	end, { v9 })

	return React.createElement(
		Media.MediaPreloadProvider.Provider,
		{ controllerProvider = v9.provider },
		props.children
	)
end

return MomentsCarouselMediaProvider
