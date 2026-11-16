local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities")
local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents")

local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Actions.SetCentralOverlay
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local getExperienceEventInfoStore = DataHydration.ExperienceEvents.getExperienceEventInfoStore
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore

local function showRsvpSuccessToast(data, entryPointKey, title, derivedField)
	local v5 = data.dependencies.localization:Format("Feature.VirtualEvents.Label.ReminderSetForEventTime"):gsub(
		"{(.-)}",
		{ eventName = title, eventTime = derivedField }
	)

	getSduiPageEntrySnackbarStore().show(entryPointKey, {
		title = v5,
		icon = Foundation.Enums.IconName.CircleCheck
	})
end

return function(p2, p3, data, p4)
	local actionParams = if p2 then p2.actionParams or nil else nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "RsvpToEvent", message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId

	if eventId == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "RsvpToEvent", message = "Missing eventId", propName = "eventId" },
			data.appPage
		)
		return
	end

	local userRsvp = actionParams.userRsvp

	VirtualEvents.fireVirtualEventRSVP({
		virtualEventId = tostring(eventId),
		universeId = tostring(getActionTelemetryFieldValue(p2, p3, "universeId", "")),
		channel = tostring(getActionTelemetryFieldValue(p2, p3, "channel", "")),
		status = userRsvp and "going" or "notGoing"
	})

	local experienceEventInfoStore = getExperienceEventInfoStore(false)
	local v5 = experienceEventInfoStore.patchRsvpStatus(eventId, userRsvp)

	if v5 then
		local entryPointKey = actionParams.entryPointKey or data.configKey

		v5:andThen(function(p5)
			if userRsvp ~= true or not entryPointKey then
				return
			end

			local v6 = p5 and p5.shouldSeeNotificationsUpsellModal == true

			local notificationsModalIdentifier = actionParams.notificationsModalIdentifier

			if v6 and notificationsModalIdentifier then
				data.dependencies.dispatch(setCentralOverlay(centralOverlayType.SduiOverlay, {
					configKey = data.configKey,
					identifier = notificationsModalIdentifier,
					appPage = data.appPage
				}))

				return
			end

			local experienceEventInfo = experienceEventInfoStore.getExperienceEventInfo(eventId)
			local v7 = experienceEventInfo and experienceEventInfo.data and experienceEventInfo.data(false)

			if not v7 then
				return
			end

			local title = v7.title
			local derivedField = experienceEventInfoStore.calculateDerivedField(
				"formattedStartDate",
				v7,
				false,
				data.dependencies.localization
			)

			if title and derivedField and v7.userRsvp then
				showRsvpSuccessToast(data, entryPointKey, title, derivedField)
			end
		end):catch(function(): nil
			return nil
		end)
	end
end
