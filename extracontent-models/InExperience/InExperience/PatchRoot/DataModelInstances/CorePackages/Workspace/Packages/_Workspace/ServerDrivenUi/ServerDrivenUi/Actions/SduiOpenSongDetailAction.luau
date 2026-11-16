local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenSongDetail = DiscoveryRouting.OpenSongDetail
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenSongDetail, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local songId = actionParams.songId

	if typeof(songId) == "string" and songId ~= "" then
		p2.dependencies.dispatch(OpenSongDetail(songId))
	else
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSongDetail,
				message = `Invalid or missing songId: {songId}`,
				propName = "songId"
			},
			p2.appPage
		)
	end
end
