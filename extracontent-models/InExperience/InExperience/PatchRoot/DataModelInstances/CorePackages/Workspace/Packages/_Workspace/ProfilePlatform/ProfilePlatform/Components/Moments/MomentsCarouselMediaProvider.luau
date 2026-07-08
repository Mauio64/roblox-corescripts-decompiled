local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local AppLifecycleObserverService = nil

pcall(function() -- line: 10
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

local React = require(Parent.React)
local Signals = require(Parent.Signals)
local enableAudioPlaybackInApp = require(Parent.MediaPlayback).enableAudioPlaybackInApp
local Media = require(Parent.MomentsCommon).Media

require(Parent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(Parent.Moments.ToMediaItem)
local FFlagProfileMomentsVideoPlaybackFix = require(Parent.SharedFlags).FFlagProfileMomentsVideoPlaybackFix

local function shouldPauseWhenAppHidden() -- line: 36
	-- upvalues: UserInputService (copy)
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end
local function MomentsCarouselMediaProvider(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), Signals (copy), UserInputService (copy), AppLifecycleObserverService (ref), ToMediaItem (copy), enableAudioPlaybackInApp (copy), CoreGui (copy), FFlagProfileMomentsVideoPlaybackFix (copy), RunService (copy), ContentProvider (copy), Media (copy)
	local activeIndex = t1.activeIndex
	local playbackActive = t1.playbackActive
	local v18 = React.useMemo(function() -- line: 54
		-- upvalues: Signals (copy), activeIndex (copy)
		local v25, v26 = Signals.createSignal(activeIndex)

		return {
			get = v25,
			set = v26
		}
	end, {})
	local v19 = React.useMemo(function() -- line: 59
		-- upvalues: Signals (copy), playbackActive (copy)
		local v27, v28 = Signals.createSignal(playbackActive)

		return {
			get = v27,
			set = v28
		}
	end, {})
	local v20 = React.useMemo(function() -- line: 65
		-- upvalues: Signals (copy)
		local v29, v30 = Signals.createSignal(true)

		return {
			get = v29,
			set = v30
		}
	end, {})

	React.useEffect(function() -- line: 70
		-- upvalues: v18 (copy), activeIndex (copy)
		v18.set(activeIndex)
	end, {
		activeIndex,
		v18
	})
	React.useEffect(function() -- line: 74
		-- upvalues: v19 (copy), playbackActive (copy)
		v19.set(playbackActive)
	end, {
		playbackActive,
		v19
	})
	React.useEffect(function() -- line: 78
		-- upvalues: UserInputService (copy), AppLifecycleObserverService (ref), v20 (copy)
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop or AppLifecycleObserverService == nil then
			return
		end

		local function onHidden() -- line: 82
			-- upvalues: v20 (copy)
			v20.set(false)
		end
		local function onShown() -- line: 85
			-- upvalues: v20 (copy)
			v20.set(true)
		end

		local t2 = {
			AppLifecycleObserverService.OnHide:Connect(onHidden),
			AppLifecycleObserverService.OnUnhide:Connect(onShown)
		}

		return function() -- line: 92
			-- upvalues: t2 (copy)
			for _, v43 in t2 do
				v43:Disconnect()
			end
		end
	end, { v20 })

	local v21 = React.useMemo(function() -- line: 99
		-- upvalues: t1 (copy), ToMediaItem (copy)
		local t3 = {}

		for _, v36 in t1.moments do
			local v37 = ToMediaItem({
				kind = "moment",
				moment = v36
			})

			if v37 ~= nil then
				v37.cornerRadius = t1.mediaCornerRadius
				table.insert(t3, v37)
			end
		end

		return t3
	end, {
		t1.moments,
		t1.mediaCornerRadius
	})
	local v22 = React.useMemo(function() -- line: 113
		-- upvalues: v19 (copy), v20 (copy)
		return function(p1) -- line: 114
			-- upvalues: v19 (copy), v20 (copy)
			return v19.get(p1) and v20.get(p1)
		end
	end, {
		v19,
		v20
	})
	local v23 = React.useMemo(function() -- line: 119
		-- upvalues: v18 (copy), v21 (copy), v22 (copy)
		return {
			getActiveIndex = v18.get,
			getItems = function(_) -- line: 122
				-- upvalues: v21 (copy)
				return v21
			end,
			getPlaybackActive = v22
		}
	end, {
		v21,
		v18,
		v22
	})
	local v24 = React.useMemo(function() -- line: 129
		-- upvalues: enableAudioPlaybackInApp (copy), CoreGui (copy), FFlagProfileMomentsVideoPlaybackFix (copy), RunService (copy), ContentProvider (copy), Media (copy), v23 (copy)
		enableAudioPlaybackInApp()

		local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

		AudioDeviceOutput.Name = "ProfileMomentsAudioOutput"
		AudioDeviceOutput.Parent = CoreGui

		local v39 = if not FFlagProfileMomentsVideoPlaybackFix then nil else Instance.new("Folder")

		if v39 ~= nil then
			v39.Name = "ProfileMomentsMediaHost"
			v39.Parent = CoreGui
		end

		local t4 = {
			runService = RunService,
			contentProvider = ContentProvider
		}
		local v41 = Media.createMediaPreloadCoordinator(v23, Media.selectPreloadPolicy(), Media.mediaTelemetry.noopSink, AudioDeviceOutput, t4, {
			parent = v39
		})

		return {
			provider = v41,
			dispose = function() -- line: 162
				-- upvalues: v41 (copy), AudioDeviceOutput (copy), v39 (copy)
				v41.dispose()
				AudioDeviceOutput:Destroy()

				if v39 ~= nil then
					v39:Destroy()
				end
			end
		}
	end, { v23 })

	React.useEffect(function() -- line: 172
		-- upvalues: v24 (copy)
		return function() -- line: 173
			-- upvalues: v24 (copy)
			v24.dispose()
		end
	end, { v24 })

	return React.createElement(Media.MediaPreloadProvider.Provider, {
		controllerProvider = v24.provider
	}, t1.children)
end

return MomentsCarouselMediaProvider
