local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local AppLifecycleObserverService = nil

pcall(function() -- line: 30
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

local React = require(MomentsParent.React)
local Signals = require(MomentsParent.Signals)
local enableAudioPlaybackInApp = require(MomentsParent.MediaPlayback).enableAudioPlaybackInApp
local Media = require(MomentsParent.MomentsCommon).Media

require(Moments.Components.Feed.FeedTypes)

local createFeedMediaSource = require(script.Parent.createFeedMediaSource)

local function shouldPauseWhenAppHidden() -- line: 84
	-- upvalues: UserInputService (copy)
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end
local function defaultCreateCoordinator(p1) -- line: 89
	-- upvalues: enableAudioPlaybackInApp (copy), CoreGui (copy), HttpService (copy), RunService (copy), ContentProvider (copy), Media (copy)
	enableAudioPlaybackInApp()

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Name = "MomentMediaAudioOutput"
	AudioDeviceOutput.Parent = CoreGui

	local Folder = Instance.new("Folder")

	Folder.Name = "MomentMediaRoot_" .. HttpService:GenerateGUID(false)
	Folder.Parent = CoreGui

	local t1 = {
		runService = RunService,
		contentProvider = ContentProvider
	}
	local v21 = Media.createMediaPreloadCoordinator(p1, Media.selectPreloadPolicy(), Media.mediaTelemetry.noopSink, AudioDeviceOutput, t1, {
		parent = Folder
	})

	return {
		provider = v21,
		dispose = function() -- line: 127
			-- upvalues: v21 (copy), AudioDeviceOutput (copy), Folder (copy)
			v21.dispose()
			AudioDeviceOutput:Destroy()
			Folder:Destroy()
		end
	}
end
local function MomentMediaCoordinatorProvider(t2: {[any]: any}) -- line: 135
	-- upvalues: defaultCreateCoordinator (copy), React (copy), Signals (copy), UserInputService (copy), AppLifecycleObserverService (ref), createFeedMediaSource (copy), Media (copy)
	local pager = t2.pager
	local playbackActive = t2.playbackActive
	local v25 = t2.createCoordinator or defaultCreateCoordinator
	local v26 = React.useMemo(function() -- line: 152
		-- upvalues: Signals (copy), playbackActive (copy)
		local v30, v31 = Signals.createSignal(playbackActive)

		return {
			get = v30,
			set = v31
		}
	end, {})
	local v27 = React.useMemo(function() -- line: 156
		-- upvalues: Signals (copy)
		local v32, v33 = Signals.createSignal(true)

		return {
			get = v32,
			set = v33
		}
	end, {})

	React.useEffect(function() -- line: 161
		-- upvalues: v26 (copy), playbackActive (copy)
		v26.set(playbackActive)
	end, {
		playbackActive,
		v26
	})
	React.useEffect(function() -- line: 168
		-- upvalues: UserInputService (copy), v27 (copy), AppLifecycleObserverService (ref)
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop then
			return
		end

		local function onHidden() -- line: 172
			-- upvalues: v27 (copy)
			v27.set(false)
		end
		local function onShown() -- line: 175
			-- upvalues: v27 (copy)
			v27.set(true)
		end

		local t3 = {}

		if AppLifecycleObserverService ~= nil then
			table.insert(t3, AppLifecycleObserverService.OnHide:Connect(onHidden))
			table.insert(t3, AppLifecycleObserverService.OnUnhide:Connect(onShown))
		end

		return function() -- line: 183
			-- upvalues: t3 (copy)
			for _, v43 in t3 do
				v43:Disconnect()
			end
		end
	end, { v27 })

	local v28 = React.useMemo(function() -- line: 194
		-- upvalues: v26 (copy), v27 (copy)
		return function(p2) -- line: 195
			-- upvalues: v26 (copy), v27 (copy)
			return v26.get(p2) and v27.get(p2)
		end
	end, {
		v26,
		v27
	})
	local v29 = React.useMemo(function() -- line: 203
		-- upvalues: createFeedMediaSource (copy), pager (copy), v28 (copy), v25 (copy)
		local v37 = createFeedMediaSource(pager, v28)

		return v25(v37)
	end, {
		pager,
		v25,
		v28
	})

	React.useEffect(function() -- line: 210
		-- upvalues: v29 (copy)
		return function() -- line: 211
			-- upvalues: v29 (copy)
			v29.dispose()
		end
	end, { v29 })
	React.useEffect(function() -- line: 216
		-- upvalues: t2 (copy), Signals (copy), v29 (copy)
		local onMediaItemFailed = t2.onMediaItemFailed

		if onMediaItemFailed == nil then
			return
		end

		local t4 = {}
		local u40 = false
		local v41 = Signals.createEffect(function(p3) -- line: 224
			-- upvalues: v29 (copy), t4 (copy), u40 (ref), onMediaItemFailed (copy)
			for v46, v47 in (v29.provider.getControllerMap(p3)) do
				local v48 = v47.getState(p3)

				if v48.readiness == "Failed" and not t4[v46] then
					t4[v46] = true

					local failureReason = v48.failureReason

					task.defer(function() -- line: 231
						-- upvalues: u40 (ref), onMediaItemFailed (copy), v46 (copy), failureReason (copy)
						if not u40 then
							onMediaItemFailed(v46, failureReason)
						end
					end)
				end
			end
		end)

		return function() -- line: 240
			-- upvalues: u40 (ref), v41 (copy)
			u40 = true
			v41()
		end
	end, {
		v29,
		t2.onMediaItemFailed
	})

	return React.createElement(Media.MediaPreloadProvider.Provider, {
		controllerProvider = v29.provider
	}, t2.children)
end

return MomentMediaCoordinatorProvider
