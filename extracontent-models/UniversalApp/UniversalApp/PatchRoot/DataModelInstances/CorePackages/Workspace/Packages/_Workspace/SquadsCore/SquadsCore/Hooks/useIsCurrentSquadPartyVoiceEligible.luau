local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local useCurrentSquadParentChannelId = require(SquadsCore.Hooks.useCurrentSquadParentChannelId)
local React = require(SquadsCoreParent.React)
local GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads = require(SquadsCore.Flags.GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads)

function useIsCurrentSquadPartyVoiceEligible() -- line: 13
	-- upvalues: React (copy), SquadExternalContractContext (copy), useCurrentSquadParentChannelId (copy)
	local v7 = React.useContext(SquadExternalContractContext)
	local v8 = useCurrentSquadParentChannelId() or ""

	return v7.useParentChannelIsPartyVoiceEligible(v8)
end

if not GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads() then
	return function() -- line: 22
		return true
	end
end

return useIsCurrentSquadPartyVoiceEligible
