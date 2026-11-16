local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local VirtualEvents = require(parent.VirtualEvents)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local getExperienceEventInfoStore = DataHydration.ExperienceEvents.getExperienceEventInfoStore
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore

local function showRsvpSuccessToast(data, entryPointKey: string, title: string, derivedField: string)
	local title2 = data.dependencies.localization:Format("Feature.VirtualEvents.Label.ReminderSetForEventTime"):gsub(
		"{(.-)}",
		{ eventName = title, eventTime = derivedField }
	)

	getSduiPageEntrySnackbarStore().show(entryPointKey, {
		title = title2,
		icon = Foundation.Enums.IconName.CircleCheck
	})
end

return function(p, p2, data, _)
	local actionParams

	if p then
		actionParams = p.actionParams or nil
	else
		actionParams = nil
	end

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "RsvpToEvent", message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId

	if eventId == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "RsvpToEvent", message = "Missing eventId", propName = "eventId" },
			data.appPage
		)
		return
	end

	local userRsvp = actionParams.userRsvp

	VirtualEvents.fireVirtualEventRSVP({
		virtualEventId = tostring(eventId),
		universeId = tostring(getActionTelemetryFieldValue(p, p2, "universeId", "")),
		channel = tostring(getActionTelemetryFieldValue(p, p2, "channel", "")),
		status = userRsvp and "going" or "notGoing"
	})

	local experienceEventInfoStore = getExperienceEventInfoStore(false)
	local v = experienceEventInfoStore.patchRsvpStatus(eventId, userRsvp)

	if v then
		local entryPointKey = actionParams.entryPointKey or data.configKey

		v:andThen(function(p3)
			if userRsvp ~= true or not entryPointKey then
				return
			end

			local v2 = p3 and p3.shouldSeeNotificationsUpsellModal == true

			local notificationsModalIdentifier = actionParams.notificationsModalIdentifier

			if v2 and notificationsModalIdentifier then
				data.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.SduiOverlay, {
					configKey = data.configKey,
					identifier = notificationsModalIdentifier,
					appPage = data.appPage
				}))

				return
			end

			local experienceEventInfo = experienceEventInfoStore.getExperienceEventInfo(eventId)
			local v3 = experienceEventInfo and experienceEventInfo.data and experienceEventInfo.data(false)

			if not v3 then
				return
			end

			local title = v3.title
			local derivedField = experienceEventInfoStore.calculateDerivedField(
				"formattedStartDate",
				v3,
				false,
				data.dependencies.localization
			)

			if title and derivedField and v3.userRsvp then
				showRsvpSuccessToast(data, entryPointKey, title, derivedField)
			end
		end):catch(function(): nil
			return nil
		end)
	end
end
