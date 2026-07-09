local Parent = script:FindFirstAncestor("BugReporting").Parent

require(Parent.SystemInfoProtocol)

local t1 = {
	FailedToCaptureScreenshot = "FailedToCaptureScreenshot",
	FailedToUploadScreenshot = "FailedToUploadScreenshot",
	FailedToUploadDeviceLogs = "FailedToUploadDeviceLogs",
	InvalidBugReportMetadata = "InvalidBugReportMetadata",
	FailedToUploadBugReport = "FailedToUploadBugReport",
	UnexpectedResponseBody = "UnexpectedResponseBody",
	UnexpectedResponseCode = "UnexpectedResponseCode"
}
local t2 = {
	ReportInitiated = "ReportInitiated",
	ReportOpened = "ReportOpened",
	ReportSubmitted = "ReportSubmitted",
	ReportSucceeded = "ReportSucceeded",
	ReportAbandoned = "ReportAbandoned",
	ScreenshotCaptured = "ScreenshotCaptured",
	ScreenshotUploaded = "ScreenshotUploaded"
}

return {
	BugReporterErrorType = t1,
	BugReporterCounterName = t2
}
