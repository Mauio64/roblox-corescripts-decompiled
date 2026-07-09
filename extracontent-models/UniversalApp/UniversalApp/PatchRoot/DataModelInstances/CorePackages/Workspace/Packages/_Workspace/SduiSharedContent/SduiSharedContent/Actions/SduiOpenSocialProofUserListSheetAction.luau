local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local gameConnectionsPlayedChipClicked = require(Parent.DiscoveryAnalytics).Events.gameConnectionsPlayedChipClicked
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiOpenSocialProofUserListSheetAction(p1, _, p3, _) -- line: 19
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Players (copy), gameConnectionsPlayedChipClicked (copy), AppPage (copy)
	local v13 = p1 and p1.actionParams or nil

	if v13 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.OpenSocialProofUserListSheet
		}, p3.appPage)

		return
	end

	local userIds = v13.userIds

	if userIds == nil or typeof(userIds) ~= "table" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing or invalid userIds",
			name = SduiActionType.OpenSocialProofUserListSheet
		}, p3.appPage)

		return
	end

	local sheetTitle = v13.sheetTitle
	local universeId = v13.universeId
	local placeId = v13.placeId
	local totalConnections = v13.totalConnections
	local analyticsSource = v13.analyticsSource

	if universeId and placeId and totalConnections and analyticsSource then
		local v20 = Players.LocalPlayer and Players.LocalPlayer.UserId

		gameConnectionsPlayedChipClicked({
			uid = not v20 and "" or tostring(v20),
			universeId = universeId,
			placeId = placeId,
			totalConnections = totalConnections
		}, analyticsSource)
	end

	local t1 = {}

	for _, v23 in userIds do
		local num = tonumber(if typeof(v23) ~= "table" then v23 else v23.userId)

		if num then
			table.insert(t1, num)
		end
	end

	p3.dependencies.getNavigation().navigate(AppPage.SocialProofVerticalUserListSheet, {
		extraProps = {
			userIds = t1,
			title = sheetTitle
		}
	})
end

return SduiOpenSocialProofUserListSheetAction
