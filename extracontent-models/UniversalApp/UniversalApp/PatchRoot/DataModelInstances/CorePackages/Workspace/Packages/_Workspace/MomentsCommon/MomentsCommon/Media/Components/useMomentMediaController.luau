local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)

local MediaPreloadProvider = require(MomentsCommon.Media.Components.MediaPreloadProvider)
local useSignalState = SignalsReact.useSignalState

local function useMomentMediaController(s1: string) -- line: 28
	-- upvalues: MediaPreloadProvider (copy), React (copy), Signals (copy), useSignalState (copy)
	local v10 = MediaPreloadProvider.useMediaControllerProvider()
	local v11 = React.useMemo(function() -- line: 35
		-- upvalues: Signals (copy), v10 (copy), s1 (copy)
		return Signals.createComputed(function(p1) -- line: 36
			-- upvalues: v10 (copy), s1 (copy)
			if v10 == nil then
				return nil
			end

			return v10.getControllerMap(p1)[s1]
		end)
	end, {
		v10,
		s1
	})

	return useSignalState(v11)
end

return useMomentMediaController
