local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/t")

local class = {}
class.__index = class

local tuple = t.tuple(
	t.callback,
	t.optional(t.strictInterface({
		queueTimeLimit = t.optional(t.numberPositive),
		queueErrorLimit = t.optional(t.numberPositive),
		queueKeyLimit = t.optional(t.numberPositive),
		flushImmediately = t.optional(t.boolean)
	}))
)

function class.new(p2, options)
	assert(tuple(p2, options))

	local v5 = options or {}

	local v6 = {
		_reportMethod = p2,
		_queueTimeLimit = v5.queueTimeLimit or 30,
		_queueErrorLimit = v5.queueErrorLimit or 30,
		_queueKeyLimit = v5.queueKeyLimit or 10,
		_flushImmediately = v5.flushImmediately == true,
		_errors = {},
		_totalErrorCount = 0,
		_totalKeyCount = 0,
		_runningTime = 0,
		_renderSteppedConnection = nil
	}

	setmetatable(v6, class)

	return v6
end

function class:hasError(value): boolean
	if type(value) == "string" and value ~= "" then
		return self._errors[value] ~= nil
	end

	return false
end

function class:addError(value, p2)
	if type(value) ~= "string" or value == "" then
		return
	end

	if self._errors[value] then
		self._errors[value].count = self._errors[value].count + 1
	else
		self._errors[value] = { data = p2, count = 1 }

		self._totalKeyCount += 1
	end

	self._totalErrorCount += 1

	if self:isReadyToReport() then
		self:reportAllErrors()
	end
end

function class:isReadyToReport()
	local v5

	if self._totalKeyCount >= self._queueKeyLimit or self._totalErrorCount >= self._queueErrorLimit then
		v5 = true
	else
		v5 = self._totalErrorCount > 0 and self._runningTime >= self._queueTimeLimit
	end

	return v5
end

function class:reportAllErrors()
	local joined = Cryo.Dictionary.join(self._errors, {})

	self._errors = {}
	self._totalErrorCount = 0
	self._totalKeyCount = 0
	self._runningTime = 0

	for k, v5 in pairs(joined) do
		self._reportMethod(k, v5.data, v5.count)
	end
end

function class:_onRenderStep(p2)
	self._runningTime += p2

	if self:isReadyToReport() then
		self:reportAllErrors()
	end
end

function class:startTimer()
	if self._renderSteppedConnection == nil then
		self._runningTime = not self._flushImmediately and 0 or self._queueTimeLimit

		self._renderSteppedConnection = RunService.renderStepped:Connect(function(p2)
			self:_onRenderStep(p2)
		end)
	end
end

function class:stopTimer()
	if self._renderSteppedConnection ~= nil then
		self._renderSteppedConnection:Disconnect()
		self._runningTime = 0
		self._renderSteppedConnection = nil
	end
end

return class
