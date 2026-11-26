local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/SentryReporter")

return {
	BacktraceReporter = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Backtrace/BacktraceReporter"),
	SentryReporter = module,
	ErrorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/ErrorReport"),
	ErrorQueue = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/ErrorQueue"),
	TokenBucketRateLimiter = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/TokenBucketRateLimiter"),
	FFlagLuaAppEnableBacktraceSessionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Backtrace/Flags/FFlagLuaAppEnableBacktraceSessionInfo")
}
