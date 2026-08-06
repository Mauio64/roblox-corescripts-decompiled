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
local SharedFlags = require(MomentsParent.SharedFlags)
local Signals = require(MomentsParent.Signals)
local useAppPolicy = require(MomentsParent.UniversalAppPolicy).useAppPolicy
local enableAudioPlaybackInApp = require(MomentsParent.MediaPlayback).enableAudioPlaybackInApp
local Media = require(MomentsParent.MomentsCommon).Media
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy

require(Moments.Components.Feed.FeedTypes)

local createFeedMediaSource = require(script.Parent.createFeedMediaSource)

local function shouldPauseWhenAppHidden() -- line: 87
	-- upvalues: UserInputService (copy)
	return UserInputService:GetDeviceType() ~= Enum.DeviceType.Desktop
end
local function defaultCreateCoordinator(p1) -- line: 92
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
	local v24 = Media.createMediaPreloadCoordinator(p1, Media.selectPreloadPolicy(), Media.mediaTelemetry.noopSink, AudioDeviceOutput, t1, {
		parent = Folder
	})

	return {
		provider = v24,
		dispose = function() -- line: 130
			-- upvalues: v24 (copy), AudioDeviceOutput (copy), Folder (copy)
			v24.dispose()
			AudioDeviceOutput:Destroy()
			Folder:Destroy()
		end
	}
end
local function MomentMediaCoordinatorProvider(t2: {[any]: any}) -- line: 138
	-- upvalues: FFlagMomentsAutoplayAmpPolicy (copy), useAppPolicy (copy), defaultCreateCoordinator (copy), React (copy), Signals (copy), UserInputService (copy), AppLifecycleObserverService (ref), createFeedMediaSource (copy), Media (copy)
	local pager = t2.pager
	local v27 = if not FFlagMomentsAutoplayAmpPolicy then nil else useAppPolicy(function(p2) -- line: 141
		return p2.getMomentsCanAutoPlay()
	end)
	local playbackActive = t2.playbackActive
	local v29 = t2.createCoordinator or defaultCreateCoordinator
	local v30 = React.useMemo(function() -- line: 162
		-- upvalues: Signals (copy), playbackActive (copy)
		local v36, v37 = Signals.createSignal(playbackActive)

		return {
			get = v36,
			set = v37
		}
	end, {})
	local v31 = if not FFlagMomentsAutoplayAmpPolicy then nil else React.useMemo(function() -- line: 168
		-- upvalues: Signals (copy), v27 (copy)
		local v38, v39 = Signals.createSignal(v27)

		return {
			get = v38,
			set = v39
		}
	end, {})
	local v32 = React.useMemo(function() -- line: 173
		-- upvalues: Signals (copy)
		local v40, v41 = Signals.createSignal(true)

		return {
			get = v40,
			set = v41
		}
	end, {})

	React.useEffect(function() -- line: 178
		-- upvalues: v30 (copy), playbackActive (copy)
		v30.set(playbackActive)
	end, {
		playbackActive,
		v30
	})

	if FFlagMomentsAutoplayAmpPolicy then
		React.useEffect(function() -- line: 182
			-- upvalues: v31 (copy), v27 (copy)
			v31.set(v27)
		end, {
			v27,
			v31
		})
	end

	React.useEffect(function() -- line: 190
		-- upvalues: UserInputService (copy), v32 (copy), AppLifecycleObserverService (ref)
		if UserInputService:GetDeviceType() == Enum.DeviceType.Desktop then
			return
		end

		local function onHidden() -- line: 194
			-- upvalues: v32 (copy)
			v32.set(false)
		end
		local function onShown() -- line: 197
			-- upvalues: v32 (copy)
			v32.set(true)
		end

		local t3 = {}

		if AppLifecycleObserverService ~= nil then
			table.insert(t3, AppLifecycleObserverService.OnHide:Connect(onHidden))
			table.insert(t3, AppLifecycleObserverService.OnUnhide:Connect(onShown))
		end

		return function() -- line: 205
			-- upvalues: t3 (copy)
			for _, v51 in t3 do
				v51:Disconnect()
			end
		end
	end, { v32 })

	local v33 = React.useMemo(function() -- line: 216
		-- upvalues: v30 (copy), v32 (copy)
		return function(p3) -- line: 217
			-- upvalues: v30 (copy), v32 (copy)
			return v30.get(p3) and v32.get(p3)
		end
	end, {
		v30,
		v32
	})
	local v34 = React.useMemo(function() -- line: 225
		-- upvalues: createFeedMediaSource (copy), pager (copy), v33 (copy), FFlagMomentsAutoplayAmpPolicy (copy), v31 (copy), v29 (copy)
		local v45 = createFeedMediaSource(pager, v33, if not FFlagMomentsAutoplayAmpPolicy then nil else v31.get)

		return v29(v45)
	end, {
		pager,
		v29,
		v33,
		if not FFlagMomentsAutoplayAmpPolicy then nil else v31
	})

	React.useEffect(function() -- line: 241
		-- upvalues: v34 (copy)
		return function() -- line: 242
			-- upvalues: v34 (copy)
			v34.dispose()
		end
	end, { v34 })
	React.useEffect(function() -- line: 247
		-- upvalues: t2 (copy), Signals (copy), v34 (copy)
		local onMediaItemFailed = t2.onMediaItemFailed

		if onMediaItemFailed == nil then
			return
		end

		local t4 = {}
		local u48 = false
		local v49 = Signals.createEffect(function(p4) -- line: 255
			-- upvalues: v34 (copy), t4 (copy), u48 (ref), onMediaItemFailed (copy)
			for v54, v55 in (v34.provider.getControllerMap(p4)) do
				local v56 = v55.getState(p4)

				if v56.readiness == "Failed" and not t4[v54] then
					t4[v54] = true

					local failureReason = v56.failureReason

					task.defer(function() -- line: 262
						-- upvalues: u48 (ref), onMediaItemFailed (copy), v54 (copy), failureReason (copy)
						if not u48 then
							onMediaItemFailed(v54, failureReason)
						end
					end)
				end
			end
		end)

		return function() -- line: 271
			-- upvalues: u48 (ref), v49 (copy)
			u48 = true
			v49()
		end
	end, {
		v34,
		t2.onMediaItemFailed
	})

	return React.createElement(Media.MediaPreloadProvider.Provider, {
		controllerProvider = v34.provider
	}, t2.children)
end

return MomentMediaCoordinatorProvider
