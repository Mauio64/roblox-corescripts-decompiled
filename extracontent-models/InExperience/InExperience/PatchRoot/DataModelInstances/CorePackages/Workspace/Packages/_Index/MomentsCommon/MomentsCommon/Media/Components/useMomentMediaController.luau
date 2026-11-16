local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)
local MediaPreloadProvider = require(MomentsCommon.Media.Components.MediaPreloadProvider)

local useSignalState = SignalsReact.useSignalState

local function useMomentMediaController(p: string)
	local v = MediaPreloadProvider.useMediaControllerProvider()

	return useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v == nil then
				return nil
			end

			return v.getControllerMap(p2)[p]
		end)
	end, { v, p })))
end

return useMomentMediaController
