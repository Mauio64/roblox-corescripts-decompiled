local mutedError = require("@luauforge/bundled/hZj").mutedError
local module = require("@luauforge/bundled/hZm")
local module2 = require("@luauforge/bundled/hZn")
local module3 = require("@luauforge/bundled/hZo")
local module4 = require("@luauforge/bundled/hZp")
local url = module4.Url
local statusCodes = module4.StatusCodes
local urlBuilder = require("@luauforge/bundled/hZq").UrlBuilder
local module5 = require("@luauforge/bundled/hZr")
local module6 = require("@luauforge/bundled/hZs")
local bugReporterErrorType = require("@luauforge/bundled/hZk").BugReporterErrorType

local defineFastInt = game:DefineFastInt("InAppBugReporterMaxTitleLength", 100)

local interface = module2.interface({
	manufacturer = module2.string,
	deviceName = module2.string,
	baseOs = module2.string,
	systemVersion = module2.string,
	appVersion = module2.string,
	networkType = module2.string
})

local strictInterface = module2.strictInterface({
	screen = module2.string,
	locale = module2.string,
	clientChannel = module2.string,
	coreScriptVersion = module2.string
})

local strictInterface2 = module2.strictInterface({
	userId = module2.number,
	userDisplayName = module2.string,
	screenshotId = module2.string,
	description = module2.string,
	logUrl = module2.string,
	systemInfo = interface,
	additionalInfo = strictInterface
})

local interface2 = module2.interface({
	responseBody = module2.strictInterface({
		issue = module2.interface({ id = module2.string })
	}),
	responseCode = module2.number
})

local v5 = urlBuilder.new({ base = url.APIS_URL, path = "feedback/v1/issues" })

return function(callback, p2)
	local v6, v7 = strictInterface2(p2)

	if not (_G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__ or v6) then
		mutedError(v7)
	end

	local v9 = module5(p2, defineFastInt)

	local v10 = {
		channel = module6.ISSUE_CHANNEL,
		title = v9.title,
		description = v9.description,
		attachmentUniformResourceNames = { `{module6.SCREENSHOT_URN_PREFIX}:{p2.screenshotId}` }
	}

	return callback(v5(), "POST", { postBody = v10 }):andThen(function(p3)
		if p3.responseCode ~= statusCodes.OK then
			return module.reject({
				type = bugReporterErrorType.UnexpectedResponseCode,
				message = `Unexpected response code: {p3.responseCode}`
			})
		end

		local v11, v12 = interface2(p3)

		if v11 then
			return module.resolve(p3.responseBody)
		end

		return module.reject({
			type = bugReporterErrorType.UnexpectedResponseBody,
			message = `Unexpected response body: {v12} \n{module3.toString(p3.responseBody)}`
		})
	end, function(p3)
		return module.reject({
			type = bugReporterErrorType.FailedToUploadBugReport,
			message = `Request failure {p3.StatusCode} {p3.StatusMessage}`
		})
	end)
end
