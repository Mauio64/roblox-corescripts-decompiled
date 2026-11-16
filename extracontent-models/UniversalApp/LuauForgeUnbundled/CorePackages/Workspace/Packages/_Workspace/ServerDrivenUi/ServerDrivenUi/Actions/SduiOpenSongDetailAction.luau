local openSongDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryRouting").OpenSongDetail
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenSongDetail, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local songId = actionParams.songId

	if typeof(songId) == "string" and songId ~= "" then
		p4.dependencies.dispatch(openSongDetail(songId))
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSongDetail,
				message = `Invalid or missing songId: {songId}`,
				propName = "songId"
			},
			p4.appPage
		)
	end
end
