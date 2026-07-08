local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local PlayerMenuActions = Constants.PlayerMenuActions
local FFlagInGameMenuAddChatLineReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagInGameMenuAddChatLineReporting

local function reportPersonUIStateReducer(p1, p2) -- line: 11
	-- upvalues: PlayerMenuActions (copy), Constants (copy), FFlagInGameMenuAddChatLineReporting (copy)
	local v9 = table.clone(p1)
	local type = p2.type

	if type == PlayerMenuActions.UpdateAbuseReason then
		v9.abuseReason = p2.abuseReason

		return v9
	end

	if type == PlayerMenuActions.UpdateComment then
		v9.comment = p2.comment

		return v9
	end

	if type == PlayerMenuActions.UpdateMethodOfAbuse then
		v9.playerObjects = {}
		v9.abuseReason = nil
		v9.methodOfAbuse = p2.methodOfAbuse

		return v9
	end

	if type == PlayerMenuActions.UpdateAbuser then
		v9.allegedAbuserId = p2.abuseId
		v9.allegedAbuser = p2.abuser

		return v9
	end

	if type == PlayerMenuActions.UpdatePlayerNameMap then
		v9.playerObjects = p2.playerObjects

		return v9
	end

	if type == PlayerMenuActions.SetVoiceEnabled then
		v9.isVoiceEnabled = p2.enabled

		return v9
	end

	if type == PlayerMenuActions.SetMenuOpenTimestamp then
		v9.menuOpenedUnixTimestampMilliseconds = p2.timestamp

		return v9
	end

	if type == PlayerMenuActions.ClearState then
		return (table.clone(Constants.InitPersonUIState))
	end

	if type == PlayerMenuActions.SetShowModalSelector then
		v9.isModalSelectorShown = p2.isShown
		v9.modalSelectorCellData = p2.cellData

		return v9
	end

	if type == PlayerMenuActions.SetPreselectedPlayer then
		v9.preselectedPlayer = p2.player

		return v9
	end

	if FFlagInGameMenuAddChatLineReporting and type == PlayerMenuActions.UpdatedSelectedChatAndOrderedMessages then
		v9.selectedMessage = p2.selectedMessage
		v9.orderedMessages = p2.orderedMessages
	end

	return v9
end

return reportPersonUIStateReducer
