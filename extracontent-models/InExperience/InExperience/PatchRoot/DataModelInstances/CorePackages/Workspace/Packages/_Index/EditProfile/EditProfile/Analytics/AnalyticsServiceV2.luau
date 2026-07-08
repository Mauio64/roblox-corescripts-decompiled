local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local TelemetryService = game:GetService("TelemetryService")
local Cryo = require(EditProfileParent.Cryo)
local Constants = require(EditProfile.Common.Constants)
local _ = {
	OpenEditDisplayName = "openEditDisplayName",
	SaveDisplayName = "saveDisplayName",
	OpenEditUsername = "openEditUsername",
	OpenAvatarMarketplace = "openAvatarMarketplace"
}
local _ = {
	EditProfilePage = "EditProfilePage",
	EditDisplayNameModal = "EditDisplayNameModal"
}
local t1 = {
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
local t2 = {
	eventName = "EditProfileEvent",
	description = "Event to track edit profile",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/edit_profile/lua_edit_profile_button_events.proto",
	lastUpdated = {
		2025,
		1,
		20
	},
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("EditProfileThrottleHundredthsPercent", 10000)
}

local function sendAnalyticsEvent(t3: {[any]: any}?, t4: {[any]: any}) -- line: 68
	-- upvalues: Cryo (copy), TelemetryService (copy), t2 (copy)
	local v13 = Cryo.Dictionary.join(t3 or {}, t4)

	TelemetryService:LogEvent(t2, {
		customFields = v13,
		standardizedFields = { "addSessionInfo" }
	})
end

return {
	TelemetryEventType = t1,
	sendEditProfileOpened = function() -- line: 89
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			page = "EditProfilePage"
		}, {
			sub_event_type = t1.EditProfileOpened
		})
	end,
	sendDisplayNameModalOpened = function() -- line: 93
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			btn = "openEditDisplayName"
		}, {
			sub_event_type = t1.DisplayNameModalOpened
		})
	end,
	sendDisplayNameModalLoaded = function(n1: number?) -- line: 100
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			page = "EditDisplayNameModal",
			statValue = n1
		}, {
			sub_event_type = t1.DisplayNameModalLoaded,
			statValue = n1
		})
	end,
	sendDisplayNameSaved = function(s1: string?, n2: number?) -- line: 107
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			btn = "saveDisplayName",
			displayName = s1,
			statValue = n2
		}, {
			sub_event_type = t1.DisplayNameSaved,
			displayName = s1,
			statValue = n2
		})
	end,
	sendDisplayNameTooShort = function(s2: string?) -- line: 114
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			displayName = s2
		}, {
			sub_event_type = t1.DisplayNameTooShort,
			displayName = s2
		})
	end,
	sendFilteredDisplayName = function(s3: string?) -- line: 121
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			displayName = s3
		}, {
			sub_event_type = t1.FilteredDisplayName,
			displayName = s3
		})
	end,
	sendEditUsernameOpened = function() -- line: 128
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			btn = "openEditUsername"
		}, {
			sub_event_type = t1.EditUsernameOpened
		})
	end,
	sendUsernameSaved = function(n3: number?) -- line: 132
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			statValue = n3
		}, {
			sub_event_type = t1.UsernameSaved,
			statValue = n3
		})
	end,
	sendOpenAvatarMarketplace = function() -- line: 145
		-- upvalues: sendAnalyticsEvent (copy), t1 (copy)
		sendAnalyticsEvent({
			btn = "openAvatarMarketplace"
		}, {
			sub_event_type = t1.OpenAvatarMarketplace
		})
	end,
	sendError = function(n4: number) -- line: 139
		-- upvalues: Constants (copy), sendAnalyticsEvent (copy), t1 (copy)
		if n4 == Constants.DescriptionErrorCodes.PinLocked then
			sendAnalyticsEvent(nil, {
				sub_event_type = t1.DescriptionPINBlocked
			})
		end
	end
}
