local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameConnectionsPlayedChipClicked = DiscoveryAnalytics.Events.gameConnectionsPlayedChipClicked

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiOpenSocialProofUserListSheetAction(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSocialProofUserListSheet,
				message = "Missing action params"
			},
			p2.appPage
		)
		return
	end

	local userIds = actionParams.userIds

	if userIds == nil or typeof(userIds) ~= "table" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSocialProofUserListSheet,
				message = "Missing or invalid userIds"
			},
			p2.appPage
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

	local userIds2 = {}

	for _, userId in userIds do
		if typeof(userId) == "table" then
			userId = userId.userId
		end

		local v = tonumber(userId)

		if v then
			table.insert(userIds2, v)
		end
	end

	p2.dependencies.getNavigation().navigate(AppPage.SocialProofVerticalUserListSheet, {
		extraProps = { userIds = userIds2, title = sheetTitle }
	})
end

return SduiOpenSocialProofUserListSheetAction
