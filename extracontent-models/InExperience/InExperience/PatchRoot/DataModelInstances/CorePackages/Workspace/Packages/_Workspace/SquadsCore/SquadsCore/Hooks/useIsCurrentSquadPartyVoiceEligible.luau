local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local useCurrentSquadParentChannelId = require(SquadsCore.Hooks.useCurrentSquadParentChannelId)

local React = require(parent.React)

local GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads = require(SquadsCore.Flags.GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads)

function useIsCurrentSquadPartyVoiceEligible()
	local v = React.useContext(SquadExternalContractContext)
	local v2 = useCurrentSquadParentChannelId() or ""

	return v.useParentChannelIsPartyVoiceEligible(v2)
end

if GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads() then
	return useIsCurrentSquadPartyVoiceEligible
end

return function(): boolean
	return true
end
