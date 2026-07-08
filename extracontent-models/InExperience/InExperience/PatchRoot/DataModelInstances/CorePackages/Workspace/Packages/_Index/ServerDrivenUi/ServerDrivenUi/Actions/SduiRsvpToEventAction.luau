local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local DataHydration = require(Parent.DataHydration)
local Foundation = require(Parent.Foundation)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SharedFlags = require(Parent.SharedFlags)
local VirtualEvents = require(Parent.VirtualEvents)
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local getExperienceEventInfoStore = DataHydration.ExperienceEvents.getExperienceEventInfoStore
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport

local function showRsvpSuccessToast(p1, s1: string, s2: string, s3: string) -- line: 26
	-- upvalues: getSduiPageEntrySnackbarStore (copy), Foundation (copy)
	local v21 = p1.dependencies.localization:Format("Feature.VirtualEvents.Label.ReminderSetForEventTime"):gsub("{(.-)}", {
		eventName = s2,
		eventTime = s3
	})

	getSduiPageEntrySnackbarStore().show(s1, {
		title = v21,
		icon = Foundation.Enums.IconName.CircleCheck
	})
end

return function(p2, p3, p4, _) -- line: 45
	-- upvalues: SduiErrorType (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), VirtualEvents (copy), getActionTelemetryFieldValue (copy), getExperienceEventInfoStore (copy), SetCentralOverlay (copy), CentralOverlayType (copy), showRsvpSuccessToast (copy)
	local v26 = p2 and p2.actionParams or nil

	if v26 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "RsvpToEvent",
			message = "Missing actionParams"
		}, p4.appPage)

		return
	end

	assert(v26, "actionParams must exist")

	local eventId = v26.eventId

	if eventId == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "RsvpToEvent",
			message = "Missing eventId",
			propName = "eventId"
		}, p4.appPage)

		return
	end

	local userRsvp = v26.userRsvp

	if FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport then
		VirtualEvents.fireVirtualEventRSVP({
			virtualEventId = tostring(eventId),
			universeId = tostring(getActionTelemetryFieldValue(p2, p3, "universeId", "")),
			channel = tostring(getActionTelemetryFieldValue(p2, p3, "channel", "")),
			status = not userRsvp and "notGoing" or "going"
		})
	end

	local v29 = getExperienceEventInfoStore(false)
	local v30 = v29.patchRsvpStatus(eventId, userRsvp)

	if (FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport) and v30 then
		local v31 = v26.entryPointKey or p4.configKey

		v30:andThen(function(p6) -- line: 89
			-- upvalues: userRsvp (copy), v31 (copy), v26 (copy), p4 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v29 (copy), eventId (copy), showRsvpSuccessToast (copy)
			if userRsvp ~= true or not v31 then
				return
			end

			local v33 = p6 and p6.shouldSeeNotificationsUpsellModal == true
			local notificationsModalIdentifier = v26.notificationsModalIdentifier

			if v33 and notificationsModalIdentifier then
				p4.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.SduiOverlay, {
					configKey = p4.configKey,
					identifier = notificationsModalIdentifier,
					appPage = p4.appPage
				}))

				return
			end

			local v35 = v29.getExperienceEventInfo(eventId)
			local v36 = v35 and (v35.data and v35.data(false))

			if not v36 then
				return
			end

			local title = v36.title
			local v38 = v29.calculateDerivedField("formattedStartDate", v36, false, p4.dependencies.localization)

			if title and v38 and v36.userRsvp then
				showRsvpSuccessToast(p4, v31, title, v38)
			end
		end):catch(function() -- line: 127
			return nil
		end)
	end
end
