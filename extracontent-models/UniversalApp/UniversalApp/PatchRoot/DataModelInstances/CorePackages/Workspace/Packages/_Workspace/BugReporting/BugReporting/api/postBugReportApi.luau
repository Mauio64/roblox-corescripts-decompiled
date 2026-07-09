local Parent = script:FindFirstAncestor("BugReporting").Parent
local mutedError = require(Parent.Loggers).mutedError
local Promise = require(Parent.Promise)
local t = require(Parent.t)
local tutils = require(Parent.tutils)
local Http = require(Parent.Http)
local Url = Http.Url
local StatusCodes = Http.StatusCodes
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local formatBugReportContent = require(script.Parent.formatBugReportContent)
local SharedConstants = require(script.Parent.Parent.SharedConstants)
local BugReporterErrorType = require(script.Parent.Parent.BugReporterTypes).BugReporterErrorType
local v13 = game:DefineFastInt("InAppBugReporterMaxTitleLength", 100)
local v14 = t.interface({
	manufacturer = t.string,
	deviceName = t.string,
	baseOs = t.string,
	systemVersion = t.string,
	appVersion = t.string,
	networkType = t.string
})
local v15 = t.strictInterface({
	screen = t.string,
	locale = t.string,
	clientChannel = t.string,
	coreScriptVersion = t.string
})
local v16 = t.strictInterface({
	userId = t.number,
	userDisplayName = t.string,
	screenshotId = t.string,
	description = t.string,
	logUrl = t.string,
	systemInfo = v14,
	additionalInfo = v15
})
local v17 = t.interface({
	responseBody = t.strictInterface({
		issue = t.interface({
			id = t.string
		})
	}),
	responseCode = t.number
})
local v18 = UrlBuilder.new({
	path = "feedback/v1/issues",
	base = Url.APIS_URL
})

return function(p1, p2) -- line: 63
	-- upvalues: v16 (copy), v13 (copy), mutedError (copy), formatBugReportContent (copy), SharedConstants (copy), v18 (copy), StatusCodes (copy), Promise (copy), BugReporterErrorType (copy), v17 (copy), tutils (copy)
	local v21, v22 = v16(p2)
	local v23 = v13

	if not _G.__TEST_SUITE_PACKAGE__ and (not _G.__TESTEZ_RUNNING_TEST__ and not v21) then
		mutedError(v22)
	end

	local v24 = formatBugReportContent(p2, v23)
	local t1 = {
		channel = SharedConstants.ISSUE_CHANNEL,
		title = v24.title,
		description = v24.description,
		attachmentUniformResourceNames = { `{ SharedConstants.SCREENSHOT_URN_PREFIX }:{ p2.screenshotId }` }
	}

	return p1(v18(), "POST", {
		postBody = t1
	}):andThen(function(p3) -- line: 85
		-- upvalues: StatusCodes (copy), Promise (copy), BugReporterErrorType (copy), v17 (copy), tutils (copy)
		if p3.responseCode ~= StatusCodes.OK then
			return Promise.reject({
				type = BugReporterErrorType.UnexpectedResponseCode,
				message = `Unexpected response code: { p3.responseCode }`
			})
		end

		local v27, v28 = v17(p3)

		if not v27 then
			return Promise.reject({
				type = BugReporterErrorType.UnexpectedResponseBody,
				message = `Unexpected response body: { v28 } \n{ tutils.toString(p3.responseBody) }`
			})
		end

		return Promise.resolve(p3.responseBody)
	end, function(p4) -- line: 102
		-- upvalues: Promise (copy), BugReporterErrorType (copy)
		return Promise.reject({
			type = BugReporterErrorType.FailedToUploadBugReport,
			message = `Request failure { p4.StatusCode } { p4.StatusMessage }`
		})
	end)
end
