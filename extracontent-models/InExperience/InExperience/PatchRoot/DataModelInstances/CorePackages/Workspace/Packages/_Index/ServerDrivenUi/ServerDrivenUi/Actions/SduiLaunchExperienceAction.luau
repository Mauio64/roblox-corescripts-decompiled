local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local LaunchGame = require(Parent.GameLaunch).LaunchGame
local SduiSharedContent = require(Parent.SduiSharedContent)
local FFlagLuaAppFixLaunchGameSourceParam = require(Parent.SharedFlags).FFlagLuaAppFixLaunchGameSourceParam
local sduiReportGamePlayIntent = SduiSharedContent.sduiReportGamePlayIntent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local LaunchExperience = SduiActionType.LaunchExperience

return function(p1, p2, p3, _) -- line: 30
	-- upvalues: SduiErrorType (copy), LaunchExperience (copy), sduiReportGamePlayIntent (copy), FFlagLuaAppFixLaunchGameSourceParam (copy), LaunchGame (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = LaunchExperience
		}, p3.appPage)

		return
	end

	assert(v14, "actionParams must exist")

	local placeId = v14.placeId

	if placeId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing placeId",
			propName = "placeId",
			name = LaunchExperience
		}, p3.appPage)

		return
	end

	local universeId = v14.universeId
	local launchSource = v14.launchSource
	local experienceJoinData = v14.experienceJoinData

	sduiReportGamePlayIntent({
		sduiContext = p3,
		analyticsContext = p2,
		universeId = tostring(universeId or ""),
		placeId = placeId
	})

	if FFlagLuaAppFixLaunchGameSourceParam then
		LaunchGame(placeId, nil, experienceJoinData, nil, launchSource)

		return
	end

	LaunchGame(placeId, launchSource, experienceJoinData, nil)
end
