local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.Components.Types)
local PlayerMenuActions = Constants.PlayerMenuActions

local function reportPersonUIStateReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	if kind == PlayerMenuActions.UpdateAbuseReason then
		clone.abuseReason = data.abuseReason
		return clone
	end

	if kind == PlayerMenuActions.UpdateComment then
		clone.comment = data.comment
		return clone
	end

	if kind == PlayerMenuActions.UpdateMethodOfAbuse then
		clone.playerObjects = {}
		clone.abuseReason = nil
		clone.methodOfAbuse = data.methodOfAbuse
	elseif kind == PlayerMenuActions.UpdateAbuser then
		clone.allegedAbuserId = data.abuseId
		clone.allegedAbuser = data.abuser
	else
		if kind == PlayerMenuActions.UpdatePlayerNameMap then
			clone.playerObjects = data.playerObjects
			return clone
		end

		if kind == PlayerMenuActions.SetVoiceEnabled then
			clone.isVoiceEnabled = data.enabled
			return clone
		end

		if kind == PlayerMenuActions.SetMenuOpenTimestamp then
			clone.menuOpenedUnixTimestampMilliseconds = data.timestamp
			return clone
		end

		if kind == PlayerMenuActions.ClearState then
			return (table.clone(Constants.InitPersonUIState))
		end

		if kind == PlayerMenuActions.SetShowModalSelector then
			clone.isModalSelectorShown = data.isShown
			clone.modalSelectorCellData = data.cellData
		elseif kind == PlayerMenuActions.SetPreselectedPlayer then
			clone.preselectedPlayer = data.player
		end
	end

	return clone
end

return reportPersonUIStateReducer
