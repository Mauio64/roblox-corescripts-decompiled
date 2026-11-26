local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
local useHasPresentedFrame = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/useHasPresentedFrame")
local MomentsSurfaceLoadManager = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Performance/MomentsSurfaceLoadManager")
local CaptureKind = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/CaptureKind")

local function useMomentsSurfaceReadyTracking(data)
	local controller = data.controller
	local isVideo = data.isVideo
	local enabled = data.enabled

	local ref = React.useRef(nil)

	local v5 = useHasPresentedFrame(controller, enabled and isVideo)

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if controller == nil then
				return nil
			end

			return controller.getState(p2).readiness
		end)
	end, { controller })
	local v7 = SignalsReact.useSignalState(v6)

	if not isVideo then
		v5 = v7 == "Ready"
	end

	React.useEffect(function()
		if enabled and v5 and controller ~= nil and ref.current ~= controller then
			ref.current = controller
			local markSurfaceReady = MomentsSurfaceLoadManager.markSurfaceReady
			local v8 = if isVideo then CaptureKind.Video else CaptureKind.Screenshot
			markSurfaceReady(v8)
		end
	end, { enabled, v5, isVideo, controller })
end

return useMomentsSurfaceReadyTracking
