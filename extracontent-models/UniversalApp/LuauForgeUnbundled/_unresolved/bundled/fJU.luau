local EventIngestService = game:GetService("EventIngestService")
local TelemetryService = game:GetService("TelemetryService")

local eventIngest = require("@luauforge/bundled/fJV").AnalyticsReporters.EventIngest.new(EventIngestService)

local module = require("@luauforge/bundled/fJW")
local module2 = require("@luauforge/bundled/fJX")

local recoveryEventName = module.recoveryEventName

local v5 = {
	eventName = module.context.passwordUpdateAttempted,
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 2, 4 },
	description = "Event fired when update password to iOS Keychain is attempted after recovery",
	links = ""
}

local v6 = {
	eventName = module.context.passwordUpdateSuccess,
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 2, 4 },
	description = "Event fired when update password to iOS Keychain succeeds after recovery",
	links = ""
}

local v7 = {
	eventName = module.context.passwordUpdateFailure,
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 2, 4 },
	description = "Event fired when update password to iOS Keychain fails after recovery",
	links = ""
}

local v8 = {
	eventName = module.context.passwordUpdateSkipped,
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 2, 4 },
	description = "Event fired when update password to iOS Keychain is skipped after recovery",
	links = ""
}
return {
	sendPageLoadEvent = function()
		eventIngest:sendEventDeferred(module.context.pageLoad, recoveryEventName, {
			is_luafied = true
		})
	end,
	sendRecoveryInitializedFromAutofillEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(module.context.recoveryInitializedFromAutofill, recoveryEventName, {
			recovery_session_id = p2,
			identifier_type = p3,
			next_component = p4,
			is_luafied = true
		})
	end,
	sendIdentifierSentEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(module.context.identifierSent, recoveryEventName, {
			recovery_session_id = p2,
			identifier_type = p3,
			next_component = p4,
			is_luafied = true
		})
	end,
	sendContactMethodSentEvent = function(p2, p3)
		eventIngest:sendEventDeferred(module.context.contactMethodSent, recoveryEventName, {
			recovery_session_id = p2,
			contact_method_type = p3,
			is_luafied = true
		})
	end,
	sendUserSelectedEvent = function(p2)
		eventIngest:sendEventDeferred(module.context.userSelected, recoveryEventName, {
			recovery_session_id = p2,
			is_luafied = true
		})
	end,
	sendPasswordResetEvent = function(p2, p3)
		eventIngest:sendEventDeferred(module.context.passwordReset, recoveryEventName, {
			recovery_session_id = p2,
			redirect_after_reset = p3,
			is_luafied = true
		})
	end,
	sendSwitchedInputEvent = function(p2, p3, p4)
		local switchedToPhoneInput = p3 and module.context.switchedToPhoneInput
			or module.context.switchedToEmailInput
		eventIngest:sendEventDeferred(switchedToPhoneInput, recoveryEventName, {
			recovery_session_id = p2,
			is_luafied = true,
			current_component = p4
		})
	end,
	sendRecoveryMethodInputSwitchEvent = function(p2, p3, p4)
		local v9

		if p3 == module2.Phone then
			v9 = module.context.switchedToPhoneInput
		elseif p3 == module2.BackupCode then
			v9 = module.context.switchedToBackupCodeInput
		else
			v9 = module.context.switchedToEmailInput
		end

		eventIngest:sendEventDeferred(v9, recoveryEventName, {
			recovery_session_id = p2,
			is_luafied = true,
			current_component = p4
		})
	end,
	sendBackButtonClickedEvent = function(p2, p3)
		eventIngest:sendEventDeferred(module.context.backButtonClicked, recoveryEventName, {
			recovery_session_id = p2,
			current_component = p3,
			is_luafied = true
		})
	end,
	sendPasswordUpdateAttemptedEvent = function(p2, p3)
		TelemetryService:LogEvent(v5, {
			customFields = {
				recovery_session_id = p2,
				username = p3,
				is_luafied = true
			}
		})
	end,
	sendPasswordUpdateSuccessEvent = function(p2, p3)
		TelemetryService:LogEvent(v6, {
			customFields = {
				recovery_session_id = p2,
				username = p3,
				is_luafied = true
			}
		})
	end,
	sendPasswordUpdateFailureEvent = function(p2, p3, value)
		TelemetryService:LogEvent(v7, {
			customFields = {
				recovery_session_id = p2,
				username = p3,
				error_message = value or "unknown",
				is_luafied = true
			}
		})
	end,
	sendPasswordUpdateSkippedEvent = function(p2, p3)
		TelemetryService:LogEvent(v8, {
			customFields = {
				recovery_session_id = p2,
				skip_reason = p3,
				is_luafied = true
			}
		})
	end
}
