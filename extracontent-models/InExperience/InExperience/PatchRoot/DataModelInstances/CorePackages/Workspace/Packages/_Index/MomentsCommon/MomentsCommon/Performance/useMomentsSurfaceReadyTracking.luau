local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)
local useHasPresentedFrame = require(MomentsCommon.Media.useHasPresentedFrame)
local MomentsSurfaceLoadManager = require(script.Parent.MomentsSurfaceLoadManager)
local CaptureKind = require(MomentsCommon.Enums.CaptureKind)

local function useMomentsSurfaceReadyTracking(data)
	local controller = data.controller
	local isVideo = data.isVideo
	local enabled = data.enabled

	local ref = React.useRef(nil)

	local v = useHasPresentedFrame(controller, enabled and isVideo)

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if controller == nil then
				return nil
			end

			return controller.getState(p).readiness
		end)
	end, { controller })
	local v3 = SignalsReact.useSignalState(v2)

	if not isVideo then
		v = v3 == "Ready"
	end

	React.useEffect(function()
		if enabled and v and controller ~= nil and ref.current ~= controller then
			ref.current = controller
			local markSurfaceReady = MomentsSurfaceLoadManager.markSurfaceReady
			local v4

			if isVideo then
				v4 = CaptureKind.Video
			else
				v4 = CaptureKind.Screenshot
			end

			markSurfaceReady(v4)
		end
	end, { enabled, v, isVideo, controller })
end

return useMomentsSurfaceReadyTracking
