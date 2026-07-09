local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)

local useHasPresentedFrame = require(MomentsCommon.Media.useHasPresentedFrame)
local MomentsSurfaceLoadManager = require(script.Parent.MomentsSurfaceLoadManager)

local function useMomentsSurfaceReadyTracking(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), useHasPresentedFrame (copy), Signals (copy), SignalsReact (copy), MomentsSurfaceLoadManager (copy)
	local controller = t1.controller
	local isVideo = t1.isVideo
	local enabled = t1.enabled
	local v13 = React.useRef(nil)
	local v14 = useHasPresentedFrame(controller, enabled and isVideo)
	local v15 = React.useMemo(function() -- line: 36
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 37
			-- upvalues: controller (copy)
			if controller == nil then
				return nil
			end

			return controller.getState(p1).readiness
		end)
	end, { controller })
	local v16 = SignalsReact.useSignalState(v15)
	local v17 = if not isVideo then v16 == "Ready" else v14

	React.useEffect(function() -- line: 48
		-- upvalues: enabled (copy), v17 (copy), controller (copy), v13 (copy), MomentsSurfaceLoadManager (copy)
		if enabled and (v17 and controller ~= nil and v13.current ~= controller) then
			v13.current = controller
			MomentsSurfaceLoadManager.markSurfaceReady()
		end
	end, {
		enabled,
		v17,
		controller
	})
end

return useMomentsSurfaceReadyTracking
