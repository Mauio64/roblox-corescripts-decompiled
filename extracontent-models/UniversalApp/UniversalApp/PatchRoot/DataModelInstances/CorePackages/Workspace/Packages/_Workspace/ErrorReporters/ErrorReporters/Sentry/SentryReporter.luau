local Parent = script:FindFirstAncestor("ErrorReporters").Parent
local Client = require(Parent.SentrySdk).Client
local RunService = game:GetService("RunService")
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local ErrorQueue = require(script.Parent.Parent.ErrorQueue)
local FIntOldestUAVersionToReportErrors = require(script.Parent.Parent.FIntOldestUAVersionToReportErrors)
local ErrorReport = require(script.Parent.ErrorReport)
local SentryReporterUtility = require(script.Parent.SentryReporterUtility)
local Constants = require(script.Parent.Constants)
local IAttributes = ErrorReport.IAttributes
local IAnnotations = ErrorReport.IAnnotations
local v13 = RunService:IsStudio()

local function truncateLog(s1: string) -- line: 43
	local v20 = string.len(s1)

	if v20 <= 20971520 then
		return s1, false
	end

	local v21 = string.format("[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n", v20 / 1048576, 20)

	return v21 .. string.sub(s1, v20 - (20971520 - string.len(v21)) + 1), true
end

local t1 = {}

t1.__index = t1

local function createSentryClient(s2: string, s3: string?, s4: string?, p1) -- line: 78
	-- upvalues: Client (copy)
	return Client:new({
		dsn = s2,
		environment = s3,
		release = s4
	}, p1)
end
local function buildErrorKey(s5: string, s6: string) -- line: 121
	local v28 = s5 or ""
	local v29 = s6 or ""

	return string.format("%s | %s", v28, v29)
end

local v18 = t.strictInterface({
	httpService = t.some(t.instanceOf("HttpService"), t.interface({
		JSONEncode = t.callback,
		JSONDecode = t.callback,
		RequestInternal = t.callback
	})),
	processErrorReportMethod = t.optional(t.callback),
	queueOptions = t.optional(t.table),
	generateLogMethod = t.optional(t.callback),
	logIntervalInSeconds = t.optional(t.numberPositive),
	dsn = t.string,
	environment = t.optional(t.string),
	release = t.optional(t.string),
	sentryClientSuccessCallback = t.optional(t.callback),
	sentryClientFailureCallback = t.optional(t.callback),
	logAttachmentSuccessCallback = t.optional(t.callback),
	logAttachmentFailureCallback = t.optional(t.callback)
})

function t1.new(p2) -- line: 155
	-- upvalues: v18 (copy), v13 (copy), Client (copy), t1 (copy), ErrorQueue (copy)
	local v31, v32 = v18(p2)

	if not v31 then
		if not v13 then
			return nil
		end

		error("invalid arguments for SentryReporter: " .. v32)
	end

	local t2 = {
		_isEnabled = true,
		_errorQueue = nil,
		_lastLogTime = 0,
		_httpService = p2.httpService,
		_processErrorReportMethod = p2.processErrorReportMethod,
		_sharedAttributes = {},
		_sharedAnnotations = {},
		_generateLogMethod = p2.generateLogMethod,
		_logIntervalInSeconds = p2.logIntervalInSeconds or 5,
		_dsn = p2.dsn,
		_environment = p2.environment,
		_release = p2.release
	}
	local dsn = p2.dsn
	local environment = p2.environment
	local release = p2.release
	local httpService = p2.httpService

	t2._sentryClient = Client:new({
		dsn = dsn,
		environment = environment,
		release = release
	}, httpService)
	t2._sentryClientSuccessCallback = p2.sentryClientSuccessCallback or nil
	t2._sentryClientFailureCallback = p2.sentryClientFailureCallback or nil
	t2._logAttachmentSuccessCallback = p2.logAttachmentSuccessCallback or nil
	t2._logAttachmentFailureCallback = p2.logAttachmentFailureCallback or nil
	setmetatable(t2, t1)

	local v38 = ErrorQueue.new(function(_: string, t3: {[any]: any}, _: number) -- line: 196
		-- upvalues: t2 (copy)
		t2:sendErrorReport(t3.errorReport, t3.log)
	end, p2.queueOptions)

	t2._errorQueue = v38
	v38:startTimer()

	return t2
end
function t1.isTooOldToReportErrors(_) -- line: 215
	-- upvalues: RunService (copy), FIntOldestUAVersionToReportErrors (copy)
	local RobloxVersion = RunService:GetRobloxVersion()
	local num = tonumber(string.match(RobloxVersion, ".(%d+)."))

	if not num then
		return false
	end

	if num < FIntOldestUAVersionToReportErrors then
		return true
	end

	return false
end
function t1._sendLogAttachment(t4: {[any]: any}, s8: string, s9: string) -- line: 239
	-- upvalues: v13 (copy)
	local v45 = string.len(s9)
	local v46 = string.len(s9)
	local v47

	if v46 <= 20971520 then
		v47 = false
	else
		local v48 = string.format("[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n", v46 / 1048576, 20)

		s9 = v48 .. string.sub(s9, v46 - (20971520 - string.len(v48)) + 1)
		v47 = true
	end

	if v47 and v13 then
		local v49 = string.format("Log attachment truncated: original %.2f MB, sending latest %.2f MB", v45 / 1048576, 20)

		print("[Sentry] " .. v49)
	end

	local t5 = {{
		filename = "app.log",
		content_type = "text/plain",
		data = s9
	}}

	if v13 and not v47 then
		local v51 = string.format("Sending log attachment for event: %s (%.2f KB)", s8, v45 / 1024)

		print("[Sentry] " .. v51)
	end

	t4._sentryClient:send_event_with_attachments(s8, t5, function(p4, p5, _) -- line: 270
		-- upvalues: v13 (copy), s8 (copy), t4 (copy)
		if p4 then
			if v13 then
				print("[Sentry] Successfully attached log to event:", s8)
			end

			if t4._logAttachmentSuccessCallback ~= nil then
				t4._logAttachmentSuccessCallback()

				return
			end
		else
			if v13 then
				local v125 = if type(p5) ~= "table" then tostring(p5) else p5.error or "unknown error"

				warn("[Sentry] Failed to attach log:", v125)
			end

			if t4._logAttachmentFailureCallback ~= nil then
				t4._logAttachmentFailureCallback(p5)
			end
		end
	end)
end
function t1._handleSentryExceptionCallback(t6: {[any]: any}, b1: boolean, p7, s10: string?, s11: string?) -- line: 303
	-- upvalues: v13 (copy)
	if b1 then
		if v13 then
			print("[Sentry] Successfully reported error to Sentry:", s10)
		end

		if t6._sentryClientSuccessCallback ~= nil then
			t6._sentryClientSuccessCallback()
		end

		if s11 and s10 then
			t6:_sendLogAttachment(s10, s11)

			return
		end
	else
		if v13 then
			local v57 = if type(p7) ~= "table" then tostring(p7) else p7.error or "unknown error"

			warn("[Sentry] Failed to report error to Sentry:", v57)
		end

		if t6._sentryClientFailureCallback ~= nil then
			t6._sentryClientFailureCallback(p7)
		end
	end
end
function t1.sendErrorReport(t7: {[any]: any}, p8, s12: string?) -- line: 335
	-- upvalues: v13 (copy), Constants (copy), SentryReporterUtility (copy)
	if not t7._isEnabled then
		return
	end

	if t7:isTooOldToReportErrors() then
		return
	end

	if v13 then
		assert(p8:validate())
	end

	local v61 = p8.message or "Unknown error message"
	local v62 = p8.level or Constants.DEFAULT_ERROR_LEVEL
	local v63 = SentryReporterUtility.parseErrorToContext(p8)
	local v64 = SentryReporterUtility.parseThreadsToSentry(p8.threads)
	local stacktrace = nil

	if v64 and v64.values then
		for _, v in ipairs(v64.values) do
			if v.main == true or v.crashed == true then
				stacktrace = v.stacktrace

				break
			end
		end
	end

	if v13 then
		print("[Sentry] Report Context:", v63)
		print("[Sentry] Threads:", v64)
		print("[Sentry] Main Stacktrace:", stacktrace)
		print("[Sentry] Level:", v62)
	end

	t7._sentryClient:capture_exception({
		type = "LuaError",
		message = v61,
		stacktrace = stacktrace
	}, v62, v63, v64, function(p9, p10, p11) -- line: 387
		-- upvalues: t7 (copy), s12 (copy)
		t7:_handleSentryExceptionCallback(p9, p10, p11, s12)
	end)
end
function t1._sendLogToReport(_: {[any]: any}, _: string, s14: string?) -- line: 399
	if type(s14) ~= "string" or #s14 == 0 then
		return
	end

	pcall(function() -- line: 404
	end)
end
function t1._generateLog(p12) -- line: 414
	if p12._generateLogMethod ~= nil and tick() - p12._lastLogTime > p12._logIntervalInSeconds then
		p12._lastLogTime = tick()

		local ok, result = pcall(function() -- line: 418
			-- upvalues: p12 (copy)
			return p12._generateLogMethod()
		end)

		if ok and type(result) == "string" and #result > 0 then
			return result
		end
	end

	return nil
end
function t1._generateErrorReport(t9: {[any]: any}, s15: string, s16: string, p13, p14, p15) -- line: 440
	-- upvalues: Cryo (copy), ErrorReport (copy)
	local v81

	if type(p13) == "table" then
		local v80 = if p15 == nil then p13 else Cryo.Dictionary.join(p13, {
			level = p15
		})

		v81 = ErrorReport.fromDetails(v80)
	else
		v81 = ErrorReport.fromMessageAndStack(s15, s16, p15)

		if type(p13) == "string" then
			v81:addAnnotations({
				stackDetails = p13
			})
		end
	end

	if p14 ~= nil then
		v81:addCustomMetadata(p14)
	end

	v81:addAttributes(t9._sharedAttributes)

	if t9._sharedAnnotations and next(t9._sharedAnnotations) ~= nil then
		v81:addAnnotations(t9._sharedAnnotations)
	end

	if t9._processErrorReportMethod ~= nil then
		v81 = t9._processErrorReportMethod(v81)
	end

	return v81, (t9:_generateLog())
end
function t1.reportErrorImmediately(t10: {[any]: any}, s17: string, s18: string, p16, p17, p18) -- line: 500
	if not t10._isEnabled then
		return
	end

	local v88, v89 = t10:_generateErrorReport(s17, s18, p16, p17, p18)

	t10:sendErrorReport(v88, v89)
end
function t1.reportErrorDeferred(t11: {[any]: any}, s19: string, s20: string, p19, p20, p21) -- line: 526
	if not t11._isEnabled then
		return
	end

	local v96 = s19 or ""
	local v97 = s20 or ""
	local v98 = string.format("%s | %s", v96, v97)
	local t12 = {
		errorReport = nil,
		log = nil
	}

	if not t11._errorQueue:hasError(v98) then
		local v100, v101 = t11:_generateErrorReport(s19, s20, p19, p20, p21)

		t12 = {
			errorReport = v100,
			log = v101
		}
	end

	t11._errorQueue:addError(v98, t12)
end
function t1.reportAllErrors(p22) -- line: 562
	if p22._errorQueue ~= nil then
		p22._errorQueue:reportAllErrors()
	end
end
function t1.stop(p23) -- line: 571
	p23._isEnabled = false

	if p23._errorQueue ~= nil then
		p23:reportAllErrors()
		p23._errorQueue:stopTimer()
	end
end
function t1.updateSharedAttributes(p24, p25) -- line: 589
	-- upvalues: Cryo (copy), IAttributes (copy), v13 (copy)
	local v106 = Cryo.Dictionary.join(p24._sharedAttributes, p25)
	local v107, v108 = IAttributes(v106)

	if not v107 then
		if not v13 then
			return
		end

		assert(v107, v108)
	end

	p24._sharedAttributes = v106
end
function t1.setTag(t13: {[any]: any}, s21: string, s22: string) -- line: 613
	t13._sentryClient:set_tag(s21, s22)
end
function t1.setUser(p26, p27) -- line: 622
	p26._sentryClient:set_user(p27)
end
function t1.updateSharedAnnotations(p28, p29) -- line: 631
	-- upvalues: Cryo (copy), IAnnotations (copy), v13 (copy)
	local v116 = Cryo.Dictionary.join(p28._sharedAnnotations, p29)
	local v117, v118 = IAnnotations(v116)

	if not v117 then
		if not v13 then
			return
		end

		assert(v117, v118)
	end

	p28._sharedAnnotations = v116
end

return t1
