local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sendSocialLinkClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.sendSocialLinkClickEvent

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenSocialLink, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local socialLinkUrl = actionParams.socialLinkUrl

	if typeof(socialLinkUrl) ~= "string" or socialLinkUrl == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSocialLink,
				message = `Invalid or missing socialLinkUrl: {socialLinkUrl}`,
				propName = "socialLinkUrl"
			},
			p4.appPage
		)
		return
	end

	local dispatch = p4.dependencies.dispatch
	local linkingProtocol = p4.dependencies.linkingProtocol

	local v5 = {
		assignment_id = tonumber(actionParams.assignmentId) or 0,
		assignment_type = actionParams.assignmentType or "",
		social_link_type = actionParams.socialLinkType or "",
		social_link_display_type = actionParams.socialLinkDisplayType or ""
	}

	local function fn()
		sendSocialLinkClickEvent({
			assignment_id = v5.assignment_id,
			assignment_type = v5.assignment_type,
			social_link_type = v5.social_link_type,
			social_link_url = socialLinkUrl,
			social_link_display_type = v5.social_link_display_type
		})

		linkingProtocol:openURL(socialLinkUrl):catch(function(value)
			p4.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
				name = sduiActionType.OpenSocialLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p4.appPage)
		end)

		dispatch(closeCentralOverlay())
	end

	dispatch(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, {
		continueFunc = fn
	}))
end
