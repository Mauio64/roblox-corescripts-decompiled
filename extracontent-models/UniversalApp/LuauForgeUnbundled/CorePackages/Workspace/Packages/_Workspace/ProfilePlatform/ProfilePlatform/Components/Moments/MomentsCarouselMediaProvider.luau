local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")

local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")
local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MediaPlayback").enableAudioPlaybackInApp

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/MomentsCommon")
local media = MomentsCommon.Media
local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")
local ToMediaItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Moments/ToMediaItem")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local fFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster

local useSignalState = SignalsReact.useSignalState

local function shouldPauseWhenAppHidden(): boolean
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end

local function defaultCreateCoordinator(p2, p3)
	enableAudioPlaybackInApp()

	local profileMomentsAudioOutput = Instance.new("AudioDeviceOutput")
	profileMomentsAudioOutput.Name = "ProfileMomentsAudioOutput"
	profileMomentsAudioOutput.Parent = CoreGui

	local profileMomentsMediaHost = Instance.new("Folder")

	if profileMomentsMediaHost ~= nil then
		profileMomentsMediaHost.Name = "ProfileMomentsMediaHost"
		profileMomentsMediaHost.Parent = CoreGui
	end

	local mediaPreloadCoordinator = media.createMediaPreloadCoordinator(
		p2,
		media.selectPreloadPolicy(),
		media.mediaTelemetry.noopSink,
		profileMomentsAudioOutput,
		{ runService = RunService, contentProvider = ContentProvider },
		{ parent = profileMomentsMediaHost, masterVolume = p3 }
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
	local v6

	if fFlagMomentsAutoplayAmpPolicy then
		v6 = useSignalState(getMomentsCapabilities(false).getIsAutoPlayEnabled)
	else
		v6 = nil
	end

	local v7 = React.useMemo(function()
		local signal, v8 = Signals.createSignal(activeIndex)
		return { get = signal, set = v8 }
	end, {})

	local v8 = React.useMemo(function()
		local signal, v9 = Signals.createSignal(playbackActive)
		return { get = signal, set = v9 }
	end, {})
	local v9

	if fFlagMomentsAutoplayAmpPolicy then
		v9 = React.useMemo(function()
			local signal, v10 = Signals.createSignal(v6)
			return { get = signal, set = v10 }
		end, {})
	else
		v9 = nil
	end

	local v10 = React.useMemo(function()
		local signal, v11 = Signals.createSignal(true)
		return { get = signal, set = v11 }
	end, {})

	React.useEffect(function()
		v7.set(activeIndex)
	end, { activeIndex, v7 })

	React.useEffect(function()
		v8.set(playbackActive)
	end, { playbackActive, v8 })

	if fFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function()
			v9.set(v6)
		end, { v6, v9 })
	end

	React.useEffect(function()
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop or v5 == nil then
			return
		end

		local function onHidden()
			v10.set(false)
		end
		local function onShown()
			v10.set(true)
		end
		local v11 = { v5.OnHide:Connect(onHidden), v5.OnUnhide:Connect(onShown) }

		return function()
			for k, connection in v11 do
				connection:Disconnect()
			end
		end
	end, { v10 })

	local items = React.useMemo(function()
		local result = {}

		for k, moment in props.moments do
			local v11 = ToMediaItem({ kind = "moment", moment = moment })

			if v11 == nil then
				continue
			end

			v11.cornerRadius = props.mediaCornerRadius

			if fFlagProfileMomentSceneOutfitPoster and moment.metadata.isMomentScene == true then
				v11.captureType = Enum.CaptureType.Screenshot
				v11.posterContent = nil
			end

			table.insert(result, v11)
		end

		return result
	end, { props.moments, props.mediaCornerRadius })

	local v11 = React.useMemo(function()
		return function(p2)
			return v8.get(p2) and v10.get(p2)
		end
	end, { v8, v10 })

	local function fn()
		local v12 = {
			getActiveIndex = v7.get,
			getItems = function(p2)
				return items
			end,
			getPlaybackActive = v11,
			getCanAutoPlay = 0
		}

		local v13 = if fFlagMomentsAutoplayAmpPolicy then v9.get else nil
		v12.getCanAutoPlay = v13
		return v12
	end

	local v14 = React.useMemo(fn, {
		items,
		v7,
		v11,
		if fFlagMomentsAutoplayAmpPolicy then v9 else nil
	})

	local createCoordinator = props.createCoordinator or defaultCreateCoordinator

	local v15 = React.useMemo(function()
		return createCoordinator(v14, 0)
	end, { v14, createCoordinator, 0 })

	React.useEffect(function()
		return function()
			v15.dispose()
		end
	end, { v15 })
	React.useImperativeHandle(props.handoffRef, function()
		return { release = v15.dispose }
	end, { v15 })

	return React.createElement(
		media.MediaPreloadProvider.Provider,
		{ controllerProvider = v15.provider },
		props.children
	)
end

return MomentsCarouselMediaProvider
