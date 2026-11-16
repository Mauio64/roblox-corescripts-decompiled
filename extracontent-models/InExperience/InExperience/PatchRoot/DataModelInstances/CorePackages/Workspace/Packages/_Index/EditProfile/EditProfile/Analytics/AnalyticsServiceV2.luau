local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local TelemetryService = game:GetService("TelemetryService")

local Cryo = require(parent.Cryo)
local Constants = require(EditProfile.Common.Constants)

local _ = {
	OpenEditDisplayName = "openEditDisplayName",
	SaveDisplayName = "saveDisplayName",
	OpenEditUsername = "openEditUsername",
	OpenAvatarMarketplace = "openAvatarMarketplace"
}

local _ = { EditProfilePage = "EditProfilePage", EditDisplayNameModal = "EditDisplayNameModal" }

local telemetryEventType = {
	EditProfileOpened = "EditProfileOpened",
	DisplayNameModalOpened = "DisplayNameModalOpened",
	DisplayNameModalLoaded = "DisplayNameModalLoaded",
	DisplayNameSaved = "DisplayNameSaved",
	DisplayNameTooShort = "DisplayNameTooShort",
	FilteredDisplayName = "FilteredDisplayName",
	EditUsernameOpened = "EditUsernameOpened",
	UsernameSaved = "UsernameSaved",
	DescriptionPINBlocked = "DescriptionPINBlocked",
	OpenAvatarMarketplace = "OpenAvatarMarketplace"
}

local v = {
	eventName = "EditProfileEvent",
	description = "Event to track edit profile",
	lastUpdated = { 2025, 1, 20 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("EditProfileThrottleHundredthsPercent", 10000),
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/edit_profile/lua_edit_profile_button_events.proto"
}

local function sendAnalyticsEvent(options, p)
	TelemetryService:LogEvent(v, {
		customFields = Cryo.Dictionary.join(options or {}, p),
		standardizedFields = { "addSessionInfo" }
	})
end

local AnalyticsServiceV2 = {}
AnalyticsServiceV2.TelemetryEventType = telemetryEventType

function AnalyticsServiceV2.sendEditProfileOpened()
	sendAnalyticsEvent({ page = "EditProfilePage" }, {
		sub_event_type = telemetryEventType.EditProfileOpened
	})
end

function AnalyticsServiceV2.sendDisplayNameModalOpened()
	sendAnalyticsEvent({ btn = "openEditDisplayName" }, {
		sub_event_type = telemetryEventType.DisplayNameModalOpened
	})
end

function AnalyticsServiceV2.sendDisplayNameModalLoaded(statValue: number?)
	sendAnalyticsEvent({ page = "EditDisplayNameModal", statValue = statValue }, {
		sub_event_type = telemetryEventType.DisplayNameModalLoaded,
		statValue = statValue
	})
end

function AnalyticsServiceV2.sendDisplayNameSaved(displayName: string?, statValue: number?)
	sendAnalyticsEvent({ btn = "saveDisplayName", displayName = displayName, statValue = statValue }, {
		sub_event_type = telemetryEventType.DisplayNameSaved,
		displayName = displayName,
		statValue = statValue
	})
end

function AnalyticsServiceV2.sendDisplayNameTooShort(displayName: string?)
	sendAnalyticsEvent({ displayName = displayName }, {
		sub_event_type = telemetryEventType.DisplayNameTooShort,
		displayName = displayName
	})
end

function AnalyticsServiceV2.sendFilteredDisplayName(displayName: string?)
	sendAnalyticsEvent({ displayName = displayName }, {
		sub_event_type = telemetryEventType.FilteredDisplayName,
		displayName = displayName
	})
end

function AnalyticsServiceV2.sendEditUsernameOpened()
	sendAnalyticsEvent({ btn = "openEditUsername" }, {
		sub_event_type = telemetryEventType.EditUsernameOpened
	})
end

function AnalyticsServiceV2.sendUsernameSaved(statValue: number?)
	sendAnalyticsEvent({ statValue = statValue }, {
		sub_event_type = telemetryEventType.UsernameSaved,
		statValue = statValue
	})
end

function AnalyticsServiceV2.sendOpenAvatarMarketplace()
	sendAnalyticsEvent({ btn = "openAvatarMarketplace" }, {
		sub_event_type = telemetryEventType.OpenAvatarMarketplace
	})
end

function AnalyticsServiceV2.sendError(p: number)
	if p == Constants.DescriptionErrorCodes.PinLocked then
		sendAnalyticsEvent(nil, { sub_event_type = telemetryEventType.DescriptionPINBlocked })
	end
end

return AnalyticsServiceV2
