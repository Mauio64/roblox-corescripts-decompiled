local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local AppLifecycleObserverService = nil

pcall(function() -- line: 10
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

local React = require(ProfilePlatformParent.React)
local Signals = require(ProfilePlatformParent.Signals)
local enableAudioPlaybackInApp = require(ProfilePlatformParent.MediaPlayback).enableAudioPlaybackInApp
local Media = require(ProfilePlatformParent.MomentsCommon).Media

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(ProfilePlatformParent.Moments.ToMediaItem)
local FFlagProfileMomentsVideoPlaybackFix = require(ProfilePlatformParent.SharedFlags).FFlagProfileMomentsVideoPlaybackFix
local FFlagProfileMomentsMuteCarouselAudio = require(ProfilePlatform.Flags.FFlagProfileMomentsMuteCarouselAudio)

local function shouldPauseWhenAppHidden() -- line: 40
	-- upvalues: UserInputService (copy)
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end
local function defaultCreateCoordinator(p1, n1: number?) -- line: 44
	-- upvalues: enableAudioPlaybackInApp (copy), CoreGui (copy), FFlagProfileMomentsVideoPlaybackFix (copy), RunService (copy), ContentProvider (copy), Media (copy)
	enableAudioPlaybackInApp()

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Name = "ProfileMomentsAudioOutput"
	AudioDeviceOutput.Parent = CoreGui

	local v21 = if not FFlagProfileMomentsVideoPlaybackFix then nil else Instance.new("Folder")

	if v21 ~= nil then
		v21.Name = "ProfileMomentsMediaHost"
		v21.Parent = CoreGui
	end

	local t1 = {
		runService = RunService,
		contentProvider = ContentProvider
	}
	local v23 = Media.createMediaPreloadCoordinator(p1, Media.selectPreloadPolicy(), Media.mediaTelemetry.noopSink, AudioDeviceOutput, t1, {
		parent = v21,
		masterVolume = n1
	})

	return {
		provider = v23,
		dispose = function() -- line: 77
			-- upvalues: v23 (copy), AudioDeviceOutput (copy), v21 (copy)
			v23.dispose()
			AudioDeviceOutput:Destroy()

			if v21 ~= nil then
				v21:Destroy()
			end
		end
	}
end
local function MomentsCarouselMediaProvider(t2: {[any]: any}) -- line: 97
	-- upvalues: React (copy), Signals (copy), UserInputService (copy), AppLifecycleObserverService (ref), ToMediaItem (copy), defaultCreateCoordinator (copy), FFlagProfileMomentsMuteCarouselAudio (copy), Media (copy)
	local activeIndex = t2.activeIndex
	local playbackActive = t2.playbackActive
	local v27 = React.useMemo(function() -- line: 103
		-- upvalues: Signals (copy), activeIndex (copy)
		local v36, v37 = Signals.createSignal(activeIndex)

		return {
			get = v36,
			set = v37
		}
	end, {})
	local v28 = React.useMemo(function() -- line: 108
		-- upvalues: Signals (copy), playbackActive (copy)
		local v38, v39 = Signals.createSignal(playbackActive)

		return {
			get = v38,
			set = v39
		}
	end, {})
	local v29 = React.useMemo(function() -- line: 114
		-- upvalues: Signals (copy)
		local v40, v41 = Signals.createSignal(true)

		return {
			get = v40,
			set = v41
		}
	end, {})

	React.useEffect(function() -- line: 119
		-- upvalues: v27 (copy), activeIndex (copy)
		v27.set(activeIndex)
	end, {
		activeIndex,
		v27
	})
	React.useEffect(function() -- line: 123
		-- upvalues: v28 (copy), playbackActive (copy)
		v28.set(playbackActive)
	end, {
		playbackActive,
		v28
	})
	React.useEffect(function() -- line: 127
		-- upvalues: UserInputService (copy), AppLifecycleObserverService (ref), v29 (copy)
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop or AppLifecycleObserverService == nil then
			return
		end

		local function onHidden() -- line: 131
			-- upvalues: v29 (copy)
			v29.set(false)
		end
		local function onShown() -- line: 134
			-- upvalues: v29 (copy)
			v29.set(true)
		end

		local t3 = {
			AppLifecycleObserverService.OnHide:Connect(onHidden),
			AppLifecycleObserverService.OnUnhide:Connect(onShown)
		}

		return function() -- line: 141
			-- upvalues: t3 (copy)
			for _, v50 in t3 do
				v50:Disconnect()
			end
		end
	end, { v29 })

	local v30 = React.useMemo(function() -- line: 148
		-- upvalues: t2 (copy), ToMediaItem (copy)
		local t4 = {}

		for _, v47 in t2.moments do
			local v48 = ToMediaItem({
				kind = "moment",
				moment = v47
			})

			if v48 ~= nil then
				v48.cornerRadius = t2.mediaCornerRadius
				table.insert(t4, v48)
			end
		end

		return t4
	end, {
		t2.moments,
		t2.mediaCornerRadius
	})
	local v31 = React.useMemo(function() -- line: 162
		-- upvalues: v28 (copy), v29 (copy)
		return function(p2) -- line: 163
			-- upvalues: v28 (copy), v29 (copy)
			return v28.get(p2) and v29.get(p2)
		end
	end, {
		v28,
		v29
	})
	local v32 = React.useMemo(function() -- line: 168
		-- upvalues: v27 (copy), v30 (copy), v31 (copy)
		return {
			getActiveIndex = v27.get,
			getItems = function(_) -- line: 171
				-- upvalues: v30 (copy)
				return v30
			end,
			getPlaybackActive = v31
		}
	end, {
		v30,
		v27,
		v31
	})
	local v33 = t2.createCoordinator or defaultCreateCoordinator
	local v34 = if not FFlagProfileMomentsMuteCarouselAudio then nil else 0
	local v35 = React.useMemo(function() -- line: 183
		-- upvalues: v33 (copy), v32 (copy), v34 (copy)
		return v33(v32, v34)
	end, {
		v32,
		v33,
		v34
	})

	React.useEffect(function() -- line: 187
		-- upvalues: v35 (copy)
		return function() -- line: 188
			-- upvalues: v35 (copy)
			v35.dispose()
		end
	end, { v35 })

	return React.createElement(Media.MediaPreloadProvider.Provider, {
		controllerProvider = v35.provider
	}, t2.children)
end

return MomentsCarouselMediaProvider
