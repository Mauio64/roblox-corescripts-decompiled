local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local EventIngestService = game:GetService("EventIngestService")
local TelemetryService = game:GetService("TelemetryService")
local AccountRecoveryParent = AccountRecovery.Parent
local v5 = require(AccountRecoveryParent.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)
local EventConstants = require(AccountRecovery.Analytics.EventConstants)
local RecoveryMethodInputType = require(AccountRecovery.Enums.RecoveryMethodInputType)
local recoveryEventName = EventConstants.recoveryEventName
local t1 = {
	throttlingPercentage = 10000,
	description = "Event fired when update password to iOS Keychain is attempted after recovery",
	links = "",
	eventName = EventConstants.context.passwordUpdateAttempted,
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		2,
		4
	}
}
local t2 = {
	throttlingPercentage = 10000,
	description = "Event fired when update password to iOS Keychain succeeds after recovery",
	links = "",
	eventName = EventConstants.context.passwordUpdateSuccess,
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		2,
		4
	}
}
local t3 = {
	throttlingPercentage = 10000,
	description = "Event fired when update password to iOS Keychain fails after recovery",
	links = "",
	eventName = EventConstants.context.passwordUpdateFailure,
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		2,
		4
	}
}
local t4 = {
	throttlingPercentage = 10000,
	description = "Event fired when update password to iOS Keychain is skipped after recovery",
	links = "",
	eventName = EventConstants.context.passwordUpdateSkipped,
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		2,
		4
	}
}

return {
	sendPageLoadEvent = function() -- line: 13
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t5 = {
			is_luafied = true
		}

		v5:sendEventDeferred(EventConstants.context.pageLoad, recoveryEventName, t5)
	end,
	sendRecoveryInitializedFromAutofillEvent = function(s1: string, s2: string, s3: string) -- line: 20
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t6 = {
			is_luafied = true,
			recovery_session_id = s1,
			identifier_type = s2,
			next_component = s3
		}

		v5:sendEventDeferred(EventConstants.context.recoveryInitializedFromAutofill, recoveryEventName, t6)
	end,
	sendIdentifierSentEvent = function(s4: string, s5: string, s6: string) -- line: 38
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t7 = {
			is_luafied = true,
			recovery_session_id = s4,
			identifier_type = s5,
			next_component = s6
		}

		v5:sendEventDeferred(EventConstants.context.identifierSent, recoveryEventName, t7)
	end,
	sendContactMethodSentEvent = function(s7: string, s8: string) -- line: 48
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t8 = {
			is_luafied = true,
			recovery_session_id = s7,
			contact_method_type = s8
		}

		v5:sendEventDeferred(EventConstants.context.contactMethodSent, recoveryEventName, t8)
	end,
	sendUserSelectedEvent = function(s9: string) -- line: 57
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t9 = {
			is_luafied = true,
			recovery_session_id = s9
		}

		v5:sendEventDeferred(EventConstants.context.userSelected, recoveryEventName, t9)
	end,
	sendPasswordResetEvent = function(s10: string, s11: string) -- line: 65
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t10 = {
			is_luafied = true,
			recovery_session_id = s10,
			redirect_after_reset = s11
		}

		v5:sendEventDeferred(EventConstants.context.passwordReset, recoveryEventName, t10)
	end,
	sendSwitchedInputEvent = function(s12: string, b1: boolean, s13: string) -- line: 74
		-- upvalues: EventConstants (copy), v5 (copy), recoveryEventName (copy)
		local v33 = b1 and EventConstants.context.switchedToPhoneInput or EventConstants.context.switchedToEmailInput
		local t11 = {
			is_luafied = true,
			recovery_session_id = s12,
			current_component = s13
		}

		v5:sendEventDeferred(v33, recoveryEventName, t11)
	end,
	sendRecoveryMethodInputSwitchEvent = function(s14: string, p1, s15: string) -- line: 89
		-- upvalues: RecoveryMethodInputType (copy), EventConstants (copy), v5 (copy), recoveryEventName (copy)
		local v38 = if p1 ~= RecoveryMethodInputType.Phone then if p1 ~= RecoveryMethodInputType.BackupCode then EventConstants.context.switchedToEmailInput else EventConstants.context.switchedToBackupCodeInput else EventConstants.context.switchedToPhoneInput
		local t12 = {
			is_luafied = true,
			recovery_session_id = s14,
			current_component = s15
		}

		v5:sendEventDeferred(v38, recoveryEventName, t12)
	end,
	sendBackButtonClickedEvent = function(s16: string, s17: string) -- line: 106
		-- upvalues: v5 (copy), EventConstants (copy), recoveryEventName (copy)
		local t13 = {
			is_luafied = true,
			recovery_session_id = s16,
			current_component = s17
		}

		v5:sendEventDeferred(EventConstants.context.backButtonClicked, recoveryEventName, t13)
	end,
	sendPasswordUpdateAttemptedEvent = function(s18: string, s19: string) -- line: 152
		-- upvalues: TelemetryService (copy), t1 (copy)
		local t14 = {
			is_luafied = true,
			recovery_session_id = s18,
			username = s19
		}

		TelemetryService:LogEvent(t1, {
			customFields = t14
		})
	end,
	sendPasswordUpdateSuccessEvent = function(s20: string, s21: string) -- line: 161
		-- upvalues: TelemetryService (copy), t2 (copy)
		local t15 = {
			is_luafied = true,
			recovery_session_id = s20,
			username = s21
		}

		TelemetryService:LogEvent(t2, {
			customFields = t15
		})
	end,
	sendPasswordUpdateFailureEvent = function(s22: string, s23: string, s24: string?) -- line: 170
		-- upvalues: TelemetryService (copy), t3 (copy)
		local t16 = {
			is_luafied = true,
			recovery_session_id = s22,
			username = s23,
			error_message = s24 or "unknown"
		}

		TelemetryService:LogEvent(t3, {
			customFields = t16
		})
	end,
	sendPasswordUpdateSkippedEvent = function(s25: string, s26: string) -- line: 180
		-- upvalues: TelemetryService (copy), t4 (copy)
		local t17 = {
			is_luafied = true,
			recovery_session_id = s25,
			skip_reason = s26
		}

		TelemetryService:LogEvent(t4, {
			customFields = t17
		})
	end
}
