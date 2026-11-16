local parent = script.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)

local getFFlagDebugUGCValidationPrintNewStructureResults = require(parent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)

local getFFlagUGCValidationLogFailureInfo = require(parent.flags.getFFlagUGCValidationLogFailureInfo)

local defineFastInt = game:DefineFastInt("UGCValidationLogFailureLength", 100)

local function getRelativePath(rootInstance, instance)
	if instance == nil or instance == rootInstance then
		return ""
	end

	local v = rootInstance:GetFullName() .. "."
	local fullName = instance:GetFullName()
	assert(
		string.sub(fullName, 1, #v) == v,
		`instance {fullName} is not a descendant of root {rootInstance:GetFullName()}`
	)

	return (string.sub(fullName, #v + 1))
end

local ValidationReporter = {}
ValidationReporter.__index = ValidationReporter

function ValidationReporter.new(testEnum: string, p)
	local self = setmetatable({}, ValidationReporter)
	self._testEnum = testEnum
	self._status = ValidationEnums.Status.CANNOT_START
	self._telemetryContext = ""
	self._currentInstance = nil

	assert(p, "ValidationReporter.new requires sharedData")
	self._rootInstance = p.rootInstance
	self._failures = {}
	self._warnings = {}

	return self
end

function ValidationReporter:begin()
	self._startTime = os.clock()
	self._status = ValidationEnums.Status.IN_PROGRESS
end

function ValidationReporter:setReportingInstance(currentInstance)
	self._currentInstance = currentInstance
end

function ValidationReporter:setReportingRoot(rootInstance)
	self._rootInstance = rootInstance
end

function ValidationReporter:setTelemetryContext(telemetryContext: string)
	self._telemetryContext = telemetryContext
end

function ValidationReporter:fail(failureStringKey: string, options, p)
	self._status = ValidationEnums.Status.FAIL
	table.insert(self._failures, {
		failureStringKey = failureStringKey,
		failureStringParams = options or {},
		instancePath = getRelativePath(self._rootInstance, p or self._currentInstance)
	})
end

function ValidationReporter:warn(failureStringKey: string, options, p)
	table.insert(self._warnings, {
		failureStringKey = failureStringKey,
		failureStringParams = options or {},
		instancePath = getRelativePath(self._rootInstance, p or self._currentInstance)
	})
end

function ValidationReporter.forceError(_, message: string)
	error({ __forceError = true, message = message })
end

function ValidationReporter.fetchError(_, message: string)
	error({ __fetchError = true, message = message })
end

function ValidationReporter:err(telemetryContext: string)
	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		print("Reporting:", self._testEnum, "has error:", telemetryContext)
	end

	self._status = ValidationEnums.Status.ERROR
	self._telemetryContext = telemetryContext

	self._failures = {}
	self._warnings = {}
end

function ValidationReporter:complete()
	local duration = not self._startTime and 0 or 1000 * (os.clock() - self._startTime)

	if self._status == ValidationEnums.Status.IN_PROGRESS then
		self._status = ValidationEnums.Status.PASS
	end

	if getFFlagDebugUGCValidationPrintNewStructureResults() and self._status ~= ValidationEnums.Status.PASS then
		print("Reporting:", self._testEnum, "has status", self._status, "in", duration)
	end

	if getFFlagUGCValidationLogFailureInfo() and self._status == ValidationEnums.Status.FAIL then
		for _, failure in self._failures do
			self._telemetryContext ..= failure.failureStringKey .. ";"

			if not failure.failureStringParams then
				continue
			end

			for _, failureStringParam in failure.failureStringParams do
				self._telemetryContext ..= tostring(failureStringParam) .. ";"
			end
		end

		self._telemetryContext = string.sub(self._telemetryContext, 1, defineFastInt)
	end

	return {
		validationEnum = self._testEnum,
		status = self._status,
		failures = self._failures,
		warnings = self._warnings,
		duration = duration,
		telemetryContext = self._telemetryContext
	}
end

return ValidationReporter
