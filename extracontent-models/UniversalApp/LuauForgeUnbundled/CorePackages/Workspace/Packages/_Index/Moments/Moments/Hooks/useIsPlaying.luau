local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local useSignalState = SignalsReact.useSignalState

local function useIsPlaying()
	local controller = MomentContext.useMoment().controller

	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if controller == nil then
				return false
			end

			return controller.getState(p2).isPlaying
		end)
	end, { controller })))
end

return useIsPlaying
