local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Cryo")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")

local v5 = {
	OpenEditDisplayName = "openEditDisplayName",
	SaveDisplayName = "saveDisplayName",
	OpenEditUsername = "openEditUsername",
	OpenAvatarMarketplace = "openAvatarMarketplace"
}

local v6 = {
	EditProfilePage = "EditProfilePage",
	EditDisplayNameModal = "EditDisplayNameModal"
}

local v7 = {
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

local v8 = {
	eventName = "EditProfileEvent",
	description = "Event to track edit profile",
	lastUpdated = { 2025, 1, 20 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("EditProfileThrottleHundredthsPercent", 10000),
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/edit_profile/lua_edit_profile_button_events.proto"
}

local function sendAnalyticsEvent(options, p2)
	TelemetryService:LogEvent(v8, {
		customFields = Cryo.Dictionary.join(options or {}, p2),
		standardizedFields = { "addSessionInfo" }
	})
end

return {
	TelemetryEventType = v7,
	sendEditProfileOpened = function()
		sendAnalyticsEvent({ page = "EditProfilePage" }, {
			sub_event_type = v7.EditProfileOpened
		})
	end,
	sendDisplayNameModalOpened = function()
		sendAnalyticsEvent({ btn = "openEditDisplayName" }, {
			sub_event_type = v7.DisplayNameModalOpened
		})
	end,
	sendDisplayNameModalLoaded = function(p2)
		sendAnalyticsEvent({ page = "EditDisplayNameModal", statValue = p2 }, {
			sub_event_type = v7.DisplayNameModalLoaded,
			statValue = p2
		})
	end,
	sendDisplayNameSaved = function(p2, p3)
		sendAnalyticsEvent({ btn = "saveDisplayName", displayName = p2, statValue = p3 }, {
			sub_event_type = v7.DisplayNameSaved,
			displayName = p2,
			statValue = p3
		})
	end,
	sendDisplayNameTooShort = function(p2)
		sendAnalyticsEvent({ displayName = p2 }, {
			sub_event_type = v7.DisplayNameTooShort,
			displayName = p2
		})
	end,
	sendFilteredDisplayName = function(p2)
		sendAnalyticsEvent({ displayName = p2 }, {
			sub_event_type = v7.FilteredDisplayName,
			displayName = p2
		})
	end,
	sendEditUsernameOpened = function()
		sendAnalyticsEvent({ btn = "openEditUsername" }, {
			sub_event_type = v7.EditUsernameOpened
		})
	end,
	sendUsernameSaved = function(p2)
		sendAnalyticsEvent({ statValue = p2 }, {
			sub_event_type = v7.UsernameSaved,
			statValue = p2
		})
	end,
	sendOpenAvatarMarketplace = function()
		sendAnalyticsEvent({ btn = "openAvatarMarketplace" }, {
			sub_event_type = v7.OpenAvatarMarketplace
		})
	end,
	sendError = function(p2)
		if p2 == Constants.DescriptionErrorCodes.PinLocked then
			sendAnalyticsEvent(nil, { sub_event_type = v7.DescriptionPINBlocked })
		end
	end
}
