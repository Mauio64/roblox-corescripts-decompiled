local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local MomentContext = require(Moments.Components.Feed.Items.Moment.MomentContext)

local useSignalState = SignalsReact.useSignalState

local function useIsPlaying()
	local controller = MomentContext.useMoment().controller

	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p)
			return controller ~= nil and controller.getState(p).isPlaying
		end)
	end, { controller })))
end

return useIsPlaying
