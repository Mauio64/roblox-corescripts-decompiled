local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local OpenSongDetail = require(Parent.DiscoveryRouting).OpenSongDetail
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p1, _, p3, _) -- line: 13
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), OpenSongDetail (copy)
	local v10 = p1 and p1.actionParams or nil

	if v10 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenSongDetail
		}, p3.appPage)

		return
	end

	assert(v10, "actionParams must exist")

	local songId = v10.songId

	if typeof(songId) ~= "string" or songId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "songId",
			name = SduiActionType.OpenSongDetail,
			message = `Invalid or missing songId: { songId }`
		}, p3.appPage)

		return
	end

	p3.dependencies.dispatch(OpenSongDetail(songId))
end
