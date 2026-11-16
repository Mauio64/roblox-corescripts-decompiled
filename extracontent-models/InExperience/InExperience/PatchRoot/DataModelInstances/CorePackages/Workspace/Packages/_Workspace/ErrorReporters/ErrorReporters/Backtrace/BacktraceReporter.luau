local parent = script:FindFirstAncestor("ErrorReporters").Parent
local RunService = game:GetService("RunService")

local Cryo = require(parent.Cryo)
local t = require(parent.t)

local BacktraceReport = require(script.Parent.BacktraceReport)
local ErrorQueue = require(script.Parent.Parent.ErrorQueue)
local FFlagLuaAppEnableBacktraceSessionInfo = require(script.Parent.Flags.FFlagLuaAppEnableBacktraceSessionInfo)

local isStudio = RunService:IsStudio()

local FIntOldestUAVersionToReportErrors = require(script.Parent.Parent.FIntOldestUAVersionToReportErrors)

local BacktraceReporter = {}
BacktraceReporter.__index = BacktraceReporter

local strictInterface = t.strictInterface({
	httpService = t.some(
		t.instanceOf("HttpService"),
		t.interface({
			JSONEncode = t.callback,
			JSONDecode = t.callback,
			RequestInternal = t.callback
		})
	),
	token = t.string,
	processErrorReportMethod = t.optional(t.callback),
	queueOptions = t.optional(t.table),
	generateLogMethod = t.optional(t.callback),
	logIntervalInSeconds = t.optional(t.numberPositive)
})

function BacktraceReporter.new(data)
	local v, v2 = strictInterface(data)
	local v3 = nil

	if v then
		v3 = {
			_isEnabled = true,
			_httpService = data.httpService,
			_errorQueue = nil,
			_reportUrl = game:GetFastString("ErrorUploadToBacktraceBaseUrl") .. "token=" .. data.token,
			_processErrorReportMethod = data.processErrorReportMethod,
			_sharedAttributes = {},
			_sharedAnnotations = {},
			_generateLogMethod = data.generateLogMethod,
			_logIntervalInSeconds = data.logIntervalInSeconds or 60,
			_lastLogTime = 0
		}
	elseif isStudio or _G.__DEV__ then
		error("invalid arguments for BacktraceReporter: " .. v2)
	else
		v3 = { _isEnabled = false }
	end

	setmetatable(v3, BacktraceReporter)

	if v3._isEnabled then
		v3._errorQueue = ErrorQueue.new(function(...)
			v3:_reportErrorFromErrorQueue(...)
		end, data.queueOptions)

		v3._errorQueue:startTimer()
	end

	return v3
end

function BacktraceReporter:isTooOldToReportErrors(): boolean
	local robloxVersion = RunService:GetRobloxVersion()
	local v = tonumber(string.match(robloxVersion, ".(%d+)."))

	if v then
		return v < FIntOldestUAVersionToReportErrors
	end

	return false
end

function BacktraceReporter:sendErrorReport(object, p)
	if not self._isEnabled or self:isTooOldToReportErrors() then
		return
	end

	if isStudio or _G.__DEV__ then
		assert(object:validate())
	end

	local success, result = pcall(function()
		return self._httpService:JSONEncode(object)
	end)

	if success then
		pcall(function()
			self._httpService:RequestInternal({
				Url = self._reportUrl .. "&format=json",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = result
			}):Start(function(_, p2)
				if p2.StatusCode == 200 and p ~= nil then
					local success2, result2 = pcall(function()
						return self._httpService:JSONDecode(p2.Body)
					end)

					if success2 and result2._rxid ~= nil then
						self:_sendLogToReport(result2._rxid, p)
					end
				end
			end)
		end)
	else
		warn("Cannot convert report to Json")
	end
end

function BacktraceReporter:_sendLogToReport(p, body)
	if type(body) ~= "string" or #body == 0 then
		return
	end

	pcall(function()
		self._httpService:RequestInternal({
			Url = self._reportUrl .. "&object=" .. p .. "&attachment_name=log.txt",
			Method = "POST",
			Headers = { ["Content-Type"] = "text/plain" },
			Body = body
		}):Start(function(_, _) end)
	end)
end

function BacktraceReporter:_generateLog()
	if self._generateLogMethod == nil or not (tick() - self._lastLogTime > self._logIntervalInSeconds) then
		return nil
	end

	self._lastLogTime = tick()

	local success, result = pcall(function()
		return self._generateLogMethod()
	end)

	if success and type(result) == "string" and #result > 0 then
		return result
	end

	return nil
end

function BacktraceReporter:_generateErrorReport(p, p2, stackDetails, p3)
	local errorReport

	if type(stackDetails) == "table" then
		errorReport = BacktraceReport.fromDetails(stackDetails)
	else
		errorReport = BacktraceReport.fromMessageAndStack(p, p2)
	end

	if FFlagLuaAppEnableBacktraceSessionInfo and p3 ~= nil then
		errorReport:addAttributes(p3)
	end

	errorReport:addAttributes(self._sharedAttributes)
	errorReport:addAnnotations(self._sharedAnnotations)

	if type(stackDetails) == "string" and stackDetails ~= "" then
		errorReport:addAnnotations({ stackDetails = stackDetails })
	end

	return errorReport
end

function BacktraceReporter:reportErrorImmediately(p, p2, p3, p4)
	if not self._isEnabled then
		return
	end

	local errorReport = self:_generateErrorReport(p, p2, p3, p4)

	if self._processErrorReportMethod ~= nil then
		errorReport = self._processErrorReportMethod(errorReport)
	end

	self:sendErrorReport(errorReport, (self:_generateLog()))
end

function BacktraceReporter:reportErrorDeferred(p, p2, p3, p4)
	if not self._isEnabled then
		return
	end

	local v = string.format("%s | %s", p, p2)
	local v2

	if self._errorQueue:hasError(v) then
		v2 = {}
	else
		local errorReport = self:_generateErrorReport(p, p2, p3, p4)

		if self._processErrorReportMethod ~= nil then
			errorReport = self._processErrorReportMethod(errorReport)
		end

		v2 = { backtraceReport = errorReport, log = self:_generateLog() }
	end

	self._errorQueue:addError(v, v2)
end

function BacktraceReporter:_reportErrorFromErrorQueue(_, p, errorCount)
	local backtraceReport = p.backtraceReport
	local log = p.log

	backtraceReport:addAttributes({ ErrorCount = errorCount })

	self:sendErrorReport(backtraceReport, log)
end

local IAttributes = BacktraceReport.IAttributes

function BacktraceReporter:updateSharedAttributes(p)
	local joined = Cryo.Dictionary.join(self._sharedAttributes, p)

	local v, v2 = IAttributes(joined)

	if not v then
		if isStudio or _G.__DEV__ then
			assert(v, v2)
		else
			return
		end
	end

	self._sharedAttributes = joined
end

local IAnnotations = BacktraceReport.IAnnotations

function BacktraceReporter:updateSharedAnnotations(p)
	local joined = Cryo.Dictionary.join(self._sharedAnnotations, p)

	local v, v2 = IAnnotations(joined)

	if not v then
		if isStudio or _G.__DEV__ then
			assert(v, v2)
		else
			return
		end
	end

	self._sharedAnnotations = joined
end

function BacktraceReporter:reportAllErrors()
	if self._errorQueue ~= nil then
		self._errorQueue:reportAllErrors()
	end
end

function BacktraceReporter:stop()
	self._isEnabled = false

	if self._errorQueue ~= nil then
		self:reportAllErrors()
		self._errorQueue:stopTimer()
	end
end

return BacktraceReporter
