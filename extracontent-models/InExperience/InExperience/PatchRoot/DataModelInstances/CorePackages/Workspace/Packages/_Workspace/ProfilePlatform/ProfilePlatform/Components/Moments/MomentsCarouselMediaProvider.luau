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
local useAppPolicy = require(ProfilePlatformParent.UniversalAppPolicy).useAppPolicy
local Media = require(ProfilePlatformParent.MomentsCommon).Media

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(ProfilePlatformParent.Moments.ToMediaItem)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local FFlagProfileMomentsVideoPlaybackFix = SharedFlags.FFlagProfileMomentsVideoPlaybackFix
local FFlagProfileMomentsMuteCarouselAudio = require(ProfilePlatform.Flags.FFlagProfileMomentsMuteCarouselAudio)

local function shouldPauseWhenAppHidden() -- line: 43
	-- upvalues: UserInputService (copy)
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end
local function defaultCreateCoordinator(p1, n1: number?) -- line: 47
	-- upvalues: enableAudioPlaybackInApp (copy), CoreGui (copy), FFlagProfileMomentsVideoPlaybackFix (copy), RunService (copy), ContentProvider (copy), Media (copy)
	enableAudioPlaybackInApp()

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Name = "ProfileMomentsAudioOutput"
	AudioDeviceOutput.Parent = CoreGui

	local v24 = if not FFlagProfileMomentsVideoPlaybackFix then nil else Instance.new("Folder")

	if v24 ~= nil then
		v24.Name = "ProfileMomentsMediaHost"
		v24.Parent = CoreGui
	end

	local t1 = {
		runService = RunService,
		contentProvider = ContentProvider
	}
	local v26 = Media.createMediaPreloadCoordinator(p1, Media.selectPreloadPolicy(), Media.mediaTelemetry.noopSink, AudioDeviceOutput, t1, {
		parent = v24,
		masterVolume = n1
	})

	return {
		provider = v26,
		dispose = function() -- line: 80
			-- upvalues: v26 (copy), AudioDeviceOutput (copy), v24 (copy)
			v26.dispose()
			AudioDeviceOutput:Destroy()

			if v24 ~= nil then
				v24:Destroy()
			end
		end
	}
end
local function MomentsCarouselMediaProvider(t2: {[any]: any}) -- line: 100
	-- upvalues: FFlagMomentsAutoplayAmpPolicy (copy), useAppPolicy (copy), React (copy), Signals (copy), UserInputService (copy), AppLifecycleObserverService (ref), ToMediaItem (copy), defaultCreateCoordinator (copy), FFlagProfileMomentsMuteCarouselAudio (copy), Media (copy)
	local activeIndex = t2.activeIndex
	local playbackActive = t2.playbackActive
	local v30 = if not FFlagMomentsAutoplayAmpPolicy then nil else useAppPolicy(function(p2) -- line: 104
		return p2.getMomentsCanAutoPlay()
	end)
	local v31 = React.useMemo(function() -- line: 111
		-- upvalues: Signals (copy), activeIndex (copy)
		local v42, v43 = Signals.createSignal(activeIndex)

		return {
			get = v42,
			set = v43
		}
	end, {})
	local v32 = React.useMemo(function() -- line: 116
		-- upvalues: Signals (copy), playbackActive (copy)
		local v44, v45 = Signals.createSignal(playbackActive)

		return {
			get = v44,
			set = v45
		}
	end, {})
	local v33 = if not FFlagMomentsAutoplayAmpPolicy then nil else React.useMemo(function() -- line: 122
		-- upvalues: Signals (copy), v30 (copy)
		local v46, v47 = Signals.createSignal(v30)

		return {
			get = v46,
			set = v47
		}
	end, {})
	local v34 = React.useMemo(function() -- line: 129
		-- upvalues: Signals (copy)
		local v48, v49 = Signals.createSignal(true)

		return {
			get = v48,
			set = v49
		}
	end, {})

	React.useEffect(function() -- line: 134
		-- upvalues: v31 (copy), activeIndex (copy)
		v31.set(activeIndex)
	end, {
		activeIndex,
		v31
	})
	React.useEffect(function() -- line: 138
		-- upvalues: v32 (copy), playbackActive (copy)
		v32.set(playbackActive)
	end, {
		playbackActive,
		v32
	})

	if FFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function() -- line: 143
			-- upvalues: v33 (copy), v30 (copy)
			v33.set(v30)
		end, {
			v30,
			v33
		})
	end

	React.useEffect(function() -- line: 148
		-- upvalues: UserInputService (copy), AppLifecycleObserverService (ref), v34 (copy)
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop or AppLifecycleObserverService == nil then
			return
		end

		local function onHidden() -- line: 152
			-- upvalues: v34 (copy)
			v34.set(false)
		end
		local function onShown() -- line: 155
			-- upvalues: v34 (copy)
			v34.set(true)
		end

		local t3 = {
			AppLifecycleObserverService.OnHide:Connect(onHidden),
			AppLifecycleObserverService.OnUnhide:Connect(onShown)
		}

		return function() -- line: 162
			-- upvalues: t3 (copy)
			for _, v58 in t3 do
				v58:Disconnect()
			end
		end
	end, { v34 })

	local v35 = React.useMemo(function() -- line: 169
		-- upvalues: t2 (copy), ToMediaItem (copy)
		local t4 = {}

		for _, v55 in t2.moments do
			local v56 = ToMediaItem({
				kind = "moment",
				moment = v55
			})

			if v56 ~= nil then
				v56.cornerRadius = t2.mediaCornerRadius
				table.insert(t4, v56)
			end
		end

		return t4
	end, {
		t2.moments,
		t2.mediaCornerRadius
	})
	local v36 = React.useMemo(function() -- line: 183
		-- upvalues: v32 (copy), v34 (copy)
		return function(p3) -- line: 184
			-- upvalues: v32 (copy), v34 (copy)
			return v32.get(p3) and v34.get(p3)
		end
	end, {
		v32,
		v34
	})
	local v37 = React.useMemo(function() -- line: 189
		-- upvalues: v31 (copy), v35 (copy), v36 (copy), FFlagMomentsAutoplayAmpPolicy (copy), v33 (copy)
		return {
			getActiveIndex = v31.get,
			getItems = function(_) -- line: 192
				-- upvalues: v35 (copy)
				return v35
			end,
			getPlaybackActive = v36,
			getCanAutoPlay = if not FFlagMomentsAutoplayAmpPolicy then nil else v33.get
		}
	end, {
		v35,
		v31,
		v36,
		if not FFlagMomentsAutoplayAmpPolicy then nil else v33
	})
	local v38 = t2.createCoordinator or defaultCreateCoordinator
	local v39 = if not FFlagProfileMomentsMuteCarouselAudio then nil else 0
	local v40 = React.useMemo(function() -- line: 210
		-- upvalues: v38 (copy), v37 (copy), v39 (copy)
		return v38(v37, v39)
	end, {
		v37,
		v38,
		v39
	})

	React.useEffect(function() -- line: 214
		-- upvalues: v40 (copy)
		return function() -- line: 215
			-- upvalues: v40 (copy)
			v40.dispose()
		end
	end, { v40 })

	return React.createElement(Media.MediaPreloadProvider.Provider, {
		controllerProvider = v40.provider
	}, t2.children)
end

return MomentsCarouselMediaProvider
