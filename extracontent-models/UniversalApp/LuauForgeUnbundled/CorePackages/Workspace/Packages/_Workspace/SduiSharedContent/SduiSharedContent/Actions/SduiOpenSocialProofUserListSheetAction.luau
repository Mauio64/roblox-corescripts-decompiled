local Players = game:GetService("Players")

local gameConnectionsPlayedChipClicked = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics").Events.gameConnectionsPlayedChipClicked

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppEnums").AppPage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiOpenSocialProofUserListSheetAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSocialProofUserListSheet,
				message = "Missing action params"
			},
			p4.appPage
		)
		return
	end

	local userIds = actionParams.userIds

	if userIds == nil or typeof(userIds) ~= "table" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSocialProofUserListSheet,
				message = "Missing or invalid userIds"
			},
			p4.appPage
		)
		return
	end

	local sheetTitle = actionParams.sheetTitle

	local universeId = actionParams.universeId
	local placeId = actionParams.placeId
	local totalConnections = actionParams.totalConnections
	local analyticsSource = actionParams.analyticsSource

	if universeId and placeId and totalConnections and analyticsSource then
		local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
		gameConnectionsPlayedChipClicked({
			uid = not userId and "" or tostring(userId),
			universeId = universeId,
			placeId = placeId,
			totalConnections = totalConnections
		}, analyticsSource)
	end

	local v5 = {}

	for k, userId in userIds do
		if typeof(userId) == "table" then
			userId = userId.userId
		end

		local v6 = tonumber(userId)

		if v6 then
			table.insert(v5, v6)
		end
	end

	p4.dependencies.getNavigation().navigate(appPage.SocialProofVerticalUserListSheet, {
		extraProps = { userIds = v5, title = sheetTitle }
	})
end

return SduiOpenSocialProofUserListSheetAction
