local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/t")

local BacktraceReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Backtrace/BacktraceReport")
local ErrorQueue = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/ErrorQueue")
local FFlagLuaAppEnableBacktraceSessionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Backtrace/Flags/FFlagLuaAppEnableBacktraceSessionInfo")

local isStudio = RunService:IsStudio()

local FIntOldestUAVersionToReportErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/FIntOldestUAVersionToReportErrors")

local class = {}
class.__index = class

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

function class.new(data)
	local v5, v6 = strictInterface(data)
	local v7 = nil

	if v5 then
		v7 = {
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
		error("invalid arguments for BacktraceReporter: " .. v6)
	else
		v7 = { _isEnabled = false }
	end

	setmetatable(v7, class)

	if v7._isEnabled then
		v7._errorQueue = ErrorQueue.new(function(...)
			v7:_reportErrorFromErrorQueue(...)
		end, data.queueOptions)

		v7._errorQueue:startTimer()
	end

	return v7
end

function class:isTooOldToReportErrors(): boolean
	local robloxVersion = RunService:GetRobloxVersion()
	local v5 = tonumber(string.match(robloxVersion, ".(%d+)."))

	if v5 then
		return v5 < FIntOldestUAVersionToReportErrors
	end

	return false
end

function class:sendErrorReport(object2, p2)
	if not self._isEnabled or self:isTooOldToReportErrors() then
		return
	end

	if isStudio or _G.__DEV__ then
		assert(object2:validate())
	end

	local success, result = pcall(function()
		return self._httpService:JSONEncode(object2)
	end)

	if success then
		pcall(function()
			self._httpService:RequestInternal({
				Url = self._reportUrl .. "&format=json",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = result
			}):Start(function(p3, p4)
				if p4.StatusCode == 200 and p2 ~= nil then
					local success2, result2 = pcall(function()
						return self._httpService:JSONDecode(p4.Body)
					end)

					if success2 and result2._rxid ~= nil then
						self:_sendLogToReport(result2._rxid, p2)
					end
				end
			end)
		end)
	else
		warn("Cannot convert report to Json")
	end
end

function class:_sendLogToReport(p3, value)
	if type(value) ~= "string" or #value == 0 then
		return
	end

	pcall(function()
		self._httpService:RequestInternal({
			Url = self._reportUrl .. "&object=" .. p3 .. "&attachment_name=log.txt",
			Method = "POST",
			Headers = { ["Content-Type"] = "text/plain" },
			Body = value
		}):Start(function(p4, p5) end)
	end)
end

function class:_generateLog()
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

function class:_generateErrorReport(p3, p4, value, p5)
	local errorReport

	if type(value) == "table" then
		errorReport = BacktraceReport.fromDetails(value)
	else
		errorReport = BacktraceReport.fromMessageAndStack(p3, p4)
	end

	if FFlagLuaAppEnableBacktraceSessionInfo and p5 ~= nil then
		errorReport:addAttributes(p5)
	end

	errorReport:addAttributes(self._sharedAttributes)
	errorReport:addAnnotations(self._sharedAnnotations)

	if type(value) == "string" and value ~= "" then
		errorReport:addAnnotations({ stackDetails = value })
	end

	return errorReport
end

function class:reportErrorImmediately(p2, p3, p4, p5)
	if not self._isEnabled then
		return
	end

	local errorReport = self:_generateErrorReport(p2, p3, p4, p5)

	if self._processErrorReportMethod ~= nil then
		errorReport = self._processErrorReportMethod(errorReport)
	end

	self:sendErrorReport(errorReport, (self:_generateLog()))
end

function class:reportErrorDeferred(p2, p3, p4, p5)
	if not self._isEnabled then
		return
	end

	local v5 = string.format("%s | %s", p2, p3)
	local v6

	if self._errorQueue:hasError(v5) then
		v6 = {}
	else
		local errorReport = self:_generateErrorReport(p2, p3, p4, p5)

		if self._processErrorReportMethod ~= nil then
			errorReport = self._processErrorReportMethod(errorReport)
		end

		v6 = { backtraceReport = errorReport, log = self:_generateLog() }
	end

	self._errorQueue:addError(v5, v6)
end

function class:_reportErrorFromErrorQueue(p2, p3, p4)
	local backtraceReport = p3.backtraceReport
	local log = p3.log

	backtraceReport:addAttributes({ ErrorCount = p4 })

	self:sendErrorReport(backtraceReport, log)
end

local iAttributes = BacktraceReport.IAttributes

function class:updateSharedAttributes(p3)
	local joined = Cryo.Dictionary.join(self._sharedAttributes, p3)

	local v5, v6 = iAttributes(joined)

	if not v5 then
		if isStudio or _G.__DEV__ then
			assert(v5, v6)
		else
			return
		end
	end

	self._sharedAttributes = joined
end

local iAnnotations = BacktraceReport.IAnnotations

function class:updateSharedAnnotations(p3)
	local joined = Cryo.Dictionary.join(self._sharedAnnotations, p3)

	local v5, v6 = iAnnotations(joined)

	if not v5 then
		if isStudio or _G.__DEV__ then
			assert(v5, v6)
		else
			return
		end
	end

	self._sharedAnnotations = joined
end

function class:reportAllErrors()
	if self._errorQueue ~= nil then
		self._errorQueue:reportAllErrors()
	end
end

function class:stop()
	self._isEnabled = false

	if self._errorQueue ~= nil then
		self:reportAllErrors()
		self._errorQueue:stopTimer()
	end
end

return class
