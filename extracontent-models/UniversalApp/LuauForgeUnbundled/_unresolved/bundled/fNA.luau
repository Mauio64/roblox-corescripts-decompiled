return {
	Attempted = {
		eventName = "iosAuthServiceSignupPasswordSaveAttempted",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 2, 10 },
		description = "Event fired when save password to iOS Keychain is attempted on signup",
		links = ""
	},
	Success = {
		eventName = "iosAuthServiceSignupPasswordSaveSuccess",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 2, 10 },
		description = "Event fired when save password to iOS Keychain succeeds on signup",
		links = ""
	},
	Failure = {
		eventName = "iosAuthServiceSignupPasswordSaveFailure",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 2, 10 },
		description = "Event fired when save password to iOS Keychain fails on signup",
		links = ""
	},
	Skipped = {
		eventName = "iosAuthServiceSignupPasswordSaveSkipped",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 2, 10 },
		description = "Event fired when save password to iOS Keychain is skipped on signup",
		links = ""
	}
}
