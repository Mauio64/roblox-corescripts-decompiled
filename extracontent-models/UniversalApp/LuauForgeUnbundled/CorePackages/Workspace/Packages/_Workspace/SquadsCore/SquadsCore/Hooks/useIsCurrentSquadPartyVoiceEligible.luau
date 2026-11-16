local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadParentChannelId")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")

local GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads")

function LUAUFORGE_MODULE_GLOBALS_btd_useIsCurrentSquadPartyVoiceEligible()
	local v5 = React.useContext(SquadExternalContractContext)
	local v6 = useCurrentSquadParentChannelId() or ""

	return v5.useParentChannelIsPartyVoiceEligible(v6)
end

if GetFFlagEnablePartyVoiceOnlyForUnfilteredThreads() then
	return LUAUFORGE_MODULE_GLOBALS_btd_useIsCurrentSquadPartyVoiceEligible
end

return function(): boolean
	return true
end
