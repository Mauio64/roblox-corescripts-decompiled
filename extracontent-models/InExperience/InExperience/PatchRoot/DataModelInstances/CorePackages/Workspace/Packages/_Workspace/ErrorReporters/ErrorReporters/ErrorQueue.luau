local parent = script.Parent.Parent

local RunService = game:GetService("RunService")

local Cryo = require(parent.Cryo)
local t = require(parent.t)

local ErrorQueue = {}
ErrorQueue.__index = ErrorQueue

local tuple = t.tuple(
	t.callback,
	t.optional(t.strictInterface({
		queueTimeLimit = t.optional(t.numberPositive),
		queueErrorLimit = t.optional(t.numberPositive),
		queueKeyLimit = t.optional(t.numberPositive),
		flushImmediately = t.optional(t.boolean)
	}))
)

function ErrorQueue.new(reportMethod, options)
	assert(tuple(reportMethod, options))

	local v = options or {}

	local v2 = {
		_reportMethod = reportMethod,
		_queueTimeLimit = v.queueTimeLimit or 30,
		_queueErrorLimit = v.queueErrorLimit or 30,
		_queueKeyLimit = v.queueKeyLimit or 10,
		_flushImmediately = v.flushImmediately == true,
		_errors = {},
		_totalErrorCount = 0,
		_totalKeyCount = 0,
		_runningTime = 0,
		_renderSteppedConnection = nil
	}

	setmetatable(v2, ErrorQueue)

	return v2
end

function ErrorQueue:hasError(value: string): boolean
	return type(value) == "string" and value ~= "" and self._errors[value] ~= nil
end

function ErrorQueue:addError(value: string, p)
	if type(value) ~= "string" or value == "" then
		return
	end

	if self._errors[value] then
		self._errors[value].count = self._errors[value].count + 1
	else
		self._errors[value] = { data = p, count = 1 }

		self._totalKeyCount += 1
	end

	self._totalErrorCount += 1

	if self:isReadyToReport() then
		self:reportAllErrors()
	end
end

function ErrorQueue:isReadyToReport(): boolean
	if self._totalKeyCount >= self._queueKeyLimit or self._totalErrorCount >= self._queueErrorLimit then
		return true
	elseif self._totalErrorCount > 0 then
		return self._runningTime >= self._queueTimeLimit
	else
		return false
	end
end

function ErrorQueue:reportAllErrors()
	local joined = Cryo.Dictionary.join(self._errors, {})

	self._errors = {}
	self._totalErrorCount = 0
	self._totalKeyCount = 0
	self._runningTime = 0

	for k, v in pairs(joined) do
		self._reportMethod(k, v.data, v.count)
	end
end

function ErrorQueue:_onRenderStep(p: number)
	self._runningTime += p

	if self:isReadyToReport() then
		self:reportAllErrors()
	end
end

function ErrorQueue:startTimer()
	if self._renderSteppedConnection == nil then
		self._runningTime = not self._flushImmediately and 0 or self._queueTimeLimit

		self._renderSteppedConnection = RunService.renderStepped:Connect(function(p)
			self:_onRenderStep(p)
		end)
	end
end

function ErrorQueue:stopTimer()
	if self._renderSteppedConnection ~= nil then
		self._renderSteppedConnection:Disconnect()
		self._runningTime = 0
		self._renderSteppedConnection = nil
	end
end

return ErrorQueue
