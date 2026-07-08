local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local FFlagSduiActionTelemetryHandler = require(Parent.SharedFlags).FFlagSduiActionTelemetryHandler
local CentralOverlay = require(Parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local sendSocialLinkClickEvent = DiscoveryAnalytics.Events.sendSocialLinkClickEvent
local sendOpenLeavingRobloxModalEvent = DiscoveryAnalytics.Events.sendOpenLeavingRobloxModalEvent

return function(p1, _, p3, _) -- line: 22
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), sendSocialLinkClickEvent (copy), CloseCentralOverlay (copy), FFlagSduiActionTelemetryHandler (copy), sendOpenLeavingRobloxModalEvent (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v17 = p1 and p1.actionParams or nil

	if v17 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenSocialLink
		}, p3.appPage)

		return
	end

	assert(v17, "actionParams must exist")

	local socialLinkUrl = v17.socialLinkUrl

	if typeof(socialLinkUrl) ~= "string" or socialLinkUrl == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "socialLinkUrl",
			name = SduiActionType.OpenSocialLink,
			message = `Invalid or missing socialLinkUrl: { socialLinkUrl }`
		}, p3.appPage)

		return
	end

	local dispatch = p3.dependencies.dispatch
	local linkingProtocol = p3.dependencies.linkingProtocol
	local t1 = {
		assignment_id = tonumber(v17.assignmentId) or 0,
		assignment_type = v17.assignmentType or "",
		social_link_type = v17.socialLinkType or "",
		social_link_display_type = v17.socialLinkDisplayType or ""
	}

	if not FFlagSduiActionTelemetryHandler then
		sendOpenLeavingRobloxModalEvent({
			assignment_id = t1.assignment_id,
			assignment_type = t1.assignment_type,
			social_link_type = t1.social_link_type,
			social_link_display_type = t1.social_link_display_type
		})
	end

	dispatch(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
		continueFunc = function() -- line: 58
			-- upvalues: sendSocialLinkClickEvent (copy), t1 (copy), socialLinkUrl (copy), linkingProtocol (copy), p3 (copy), SduiErrorType (copy), SduiActionType (copy), dispatch (copy), CloseCentralOverlay (copy)
			sendSocialLinkClickEvent({
				assignment_id = t1.assignment_id,
				assignment_type = t1.assignment_type,
				social_link_type = t1.social_link_type,
				social_link_url = socialLinkUrl,
				social_link_display_type = t1.social_link_display_type
			})
			linkingProtocol:openURL(socialLinkUrl):catch(function(p5) -- line: 67
				-- upvalues: p3 (copy), SduiErrorType (copy), SduiActionType (copy)
				p3.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
					name = SduiActionType.OpenSocialLink,
					message = typeof(p5) ~= "string" and "Unknown reason" or p5
				}, p3.appPage)
			end)
			dispatch(CloseCentralOverlay())
		end
	}))
end
