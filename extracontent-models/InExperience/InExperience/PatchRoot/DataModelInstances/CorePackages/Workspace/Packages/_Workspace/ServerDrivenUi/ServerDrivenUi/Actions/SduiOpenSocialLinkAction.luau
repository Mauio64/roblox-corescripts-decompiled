local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendSocialLinkClickEvent = DiscoveryAnalytics.Events.sendSocialLinkClickEvent

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenSocialLink, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local socialLinkUrl = actionParams.socialLinkUrl

	if typeof(socialLinkUrl) ~= "string" or socialLinkUrl == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSocialLink,
				message = `Invalid or missing socialLinkUrl: {socialLinkUrl}`,
				propName = "socialLinkUrl"
			},
			p2.appPage
		)
		return
	end

	local dispatch = p2.dependencies.dispatch
	local linkingProtocol = p2.dependencies.linkingProtocol

	local v = {
		assignment_id = tonumber(actionParams.assignmentId) or 0,
		assignment_type = actionParams.assignmentType or "",
		social_link_type = actionParams.socialLinkType or "",
		social_link_display_type = actionParams.socialLinkDisplayType or ""
	}

	local function fn()
		sendSocialLinkClickEvent({
			assignment_id = v.assignment_id,
			assignment_type = v.assignment_type,
			social_link_type = v.social_link_type,
			social_link_url = socialLinkUrl,
			social_link_display_type = v.social_link_display_type
		})

		linkingProtocol:openURL(socialLinkUrl):catch(function(value)
			p2.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
				name = SduiActionType.OpenSocialLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p2.appPage)
		end)

		dispatch(CloseCentralOverlay())
	end

	dispatch(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, { continueFunc = fn }))
end
