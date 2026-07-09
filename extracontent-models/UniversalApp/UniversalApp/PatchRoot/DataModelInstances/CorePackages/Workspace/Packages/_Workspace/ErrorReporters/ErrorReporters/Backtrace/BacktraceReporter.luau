local Parent = script:FindFirstAncestor("ErrorReporters").Parent
local RunService = game:GetService("RunService")
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local BacktraceReport = require(script.Parent.BacktraceReport)
local ErrorQueue = require(script.Parent.Parent.ErrorQueue)
local FFlagLuaAppEnableBacktraceSessionInfo = require(script.Parent.Flags.FFlagLuaAppEnableBacktraceSessionInfo)
local v8 = RunService:IsStudio()
local FIntOldestUAVersionToReportErrors = require(script.Parent.Parent.FIntOldestUAVersionToReportErrors)
local t1 = {}

t1.__index = t1

local v11 = t.strictInterface({
	httpService = t.some(t.instanceOf("HttpService"), t.interface({
		JSONEncode = t.callback,
		JSONDecode = t.callback,
		RequestInternal = t.callback
	})),
	token = t.string,
	processErrorReportMethod = t.optional(t.callback),
	queueOptions = t.optional(t.table),
	generateLogMethod = t.optional(t.callback),
	logIntervalInSeconds = t.optional(t.numberPositive)
})

function t1.new(p1) -- line: 42
	-- upvalues: v11 (copy), v8 (copy), t1 (copy), ErrorQueue (copy)
	local v15, v16 = v11(p1)
	local t2 = nil

	if v15 then
		t2 = {
			_isEnabled = true,
			_errorQueue = nil,
			_lastLogTime = 0,
			_httpService = p1.httpService,
			_reportUrl = game:GetFastString("ErrorUploadToBacktraceBaseUrl") .. "token=" .. p1.token,
			_processErrorReportMethod = p1.processErrorReportMethod,
			_sharedAttributes = {},
			_sharedAnnotations = {},
			_generateLogMethod = p1.generateLogMethod,
			_logIntervalInSeconds = p1.logIntervalInSeconds or 60
		}
	elseif v8 or _G.__DEV__ then
		error("invalid arguments for BacktraceReporter: " .. v16)
	else
		t2 = {
			_isEnabled = false
		}
	end

	setmetatable(t2, t1)

	if t2._isEnabled then
		t2._errorQueue = ErrorQueue.new(function(...) -- line: 72
			-- upvalues: t2 (ref)
			t2:_reportErrorFromErrorQueue(...)
		end, p1.queueOptions)
		t2._errorQueue:startTimer()
	end

	return t2
end
function t1.isTooOldToReportErrors(_) -- line: 85
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
function t1.sendErrorReport(p3, p4, p5) -- line: 97
	-- upvalues: v8 (copy)
	if not p3._isEnabled then
		return
	end

	if p3:isTooOldToReportErrors() then
		return
	end

	if v8 or _G.__DEV__ then
		assert(p4:validate())
	end

	local ok, result = pcall(function() -- line: 113
		-- upvalues: p3 (copy), p4 (copy)
		return p3._httpService:JSONEncode(p4)
	end)

	if not ok then
		warn("Cannot convert report to Json")

		return
	end

	pcall(function() -- line: 122
		-- upvalues: p3 (copy), result (copy), p5 (copy)
		p3._httpService:RequestInternal({
			Method = "POST",
			Url = p3._reportUrl .. "&format=json",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = result
		}):Start(function(_, p7) -- line: 132
			-- upvalues: p5 (copy), p3 (copy)
			if p7.StatusCode == 200 and p5 ~= nil then
				local ok2, result2 = pcall(function() -- line: 136
					-- upvalues: p3 (copy), p7 (copy)
					return p3._httpService:JSONDecode(p7.Body)
				end)

				if ok2 and result2._rxid ~= nil then
					p3:_sendLogToReport(result2._rxid, p5)
				end
			end
		end)
	end)
end
function t1._sendLogToReport(p8, p9, p10) -- line: 148
	if type(p10) ~= "string" or #p10 == 0 then
		return
	end

	pcall(function() -- line: 153
		-- upvalues: p8 (copy), p9 (copy), p10 (copy)
		p8._httpService:RequestInternal({
			Method = "POST",
			Url = p8._reportUrl .. "&object=" .. p9 .. "&attachment_name=log.txt",
			Headers = {
				["Content-Type"] = "text/plain"
			},
			Body = p10
		}):Start(function(_, _) -- line: 163
		end)
	end)
end
function t1._generateLog(p13) -- line: 169
	if p13._generateLogMethod ~= nil and tick() - p13._lastLogTime > p13._logIntervalInSeconds then
		p13._lastLogTime = tick()

		local ok, result = pcall(function() -- line: 173
			-- upvalues: p13 (copy)
			return p13._generateLogMethod()
		end)

		if ok and type(result) == "string" and #result > 0 then
			return result
		end
	end

	return nil
end
function t1._generateErrorReport(p14, p15, p16, p17, p18) -- line: 185
	-- upvalues: BacktraceReport (copy), FFlagLuaAppEnableBacktraceSessionInfo (copy)
	local v37 = if type(p17) ~= "table" then BacktraceReport.fromMessageAndStack(p15, p16) else BacktraceReport.fromDetails(p17)

	if FFlagLuaAppEnableBacktraceSessionInfo and p18 ~= nil then
		v37:addAttributes(p18)
	end

	v37:addAttributes(p14._sharedAttributes)
	v37:addAnnotations(p14._sharedAnnotations)

	if type(p17) == "string" and p17 ~= "" then
		v37:addAnnotations({
			stackDetails = p17
		})
	end

	return v37
end
function t1.reportErrorImmediately(p19, p20, p21, p22, p23) -- line: 211
	if not p19._isEnabled then
		return
	end

	local v43 = p19:_generateErrorReport(p20, p21, p22, p23)

	if p19._processErrorReportMethod ~= nil then
		v43 = p19._processErrorReportMethod(v43)
	end

	p19:sendErrorReport(v43, (p19:_generateLog()))
end
function t1.reportErrorDeferred(p24, p25, p26, p27, p28) -- line: 228
	if not p24._isEnabled then
		return
	end

	local v49 = string.format("%s | %s", p25, p26)
	local t3 = {}

	if not p24._errorQueue:hasError(v49) then
		local v51 = p24:_generateErrorReport(p25, p26, p27, p28)

		if p24._processErrorReportMethod ~= nil then
			v51 = p24._processErrorReportMethod(v51)
		end

		t3 = {
			backtraceReport = v51,
			log = p24:_generateLog()
		}
	end

	p24._errorQueue:addError(v49, t3)
end
function t1._reportErrorFromErrorQueue(p29, _, p31, p32) -- line: 255
	local backtraceReport = p31.backtraceReport
	local log = p31.log

	backtraceReport:addAttributes({
		ErrorCount = p32
	})
	p29:sendErrorReport(backtraceReport, log)
end

local IAttributes = BacktraceReport.IAttributes

function t1.updateSharedAttributes(p33, p34) -- line: 269
	-- upvalues: Cryo (copy), IAttributes (copy), v8 (copy)
	local v60 = Cryo.Dictionary.join(p33._sharedAttributes, p34)
	local v61, v62 = IAttributes(v60)

	if not v61 then
		if not v8 and not _G.__DEV__ then
			return
		end

		assert(v61, v62)
	end

	p33._sharedAttributes = v60
end

local IAnnotations = BacktraceReport.IAnnotations

function t1.updateSharedAnnotations(p35, p36) -- line: 288
	-- upvalues: Cryo (copy), IAnnotations (copy), v8 (copy)
	local v65 = Cryo.Dictionary.join(p35._sharedAnnotations, p36)
	local v66, v67 = IAnnotations(v65)

	if not v66 then
		if not v8 and not _G.__DEV__ then
			return
		end

		assert(v66, v67)
	end

	p35._sharedAnnotations = v65
end
function t1.reportAllErrors(p37) -- line: 305
	if p37._errorQueue ~= nil then
		p37._errorQueue:reportAllErrors()
	end
end
function t1.stop(p38) -- line: 311
	p38._isEnabled = false

	if p38._errorQueue ~= nil then
		p38:reportAllErrors()
		p38._errorQueue:stopTimer()
	end
end

return t1
