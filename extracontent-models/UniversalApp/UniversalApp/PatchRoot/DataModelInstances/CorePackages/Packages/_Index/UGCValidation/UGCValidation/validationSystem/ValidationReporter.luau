local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local getFFlagDebugUGCValidationPrintNewStructureResults = require(ParentParent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)

local function getRelativePath(p1, p2) -- line: 12
	if p2 == nil or p2 == p1 then
		return ""
	end

	local v9 = p1:GetFullName() .. "."
	local FullName = p2:GetFullName()

	assert(v9 == string.sub(FullName, 1, #v9), `instance { FullName } is not a descendant of root { p1:GetFullName() }`)

	return (string.sub(FullName, #v9 + 1))
end

local t1 = {}

t1.__index = t1

function t1.new(s1: string, p3) -- line: 28
	-- upvalues: t1 (copy), ValidationEnums (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	local self = setmetatable({}, t1)

	self._testEnum = s1
	self._status = ValidationEnums.Status.CANNOT_START
	self._telemetryContext = ""
	self._currentInstance = nil

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		assert(p3, "ValidationReporter.new requires sharedData")
		self._rootInstance = p3.rootInstance
		self._failures = {}
		self._warnings = {}

		return self
	end

	self._failureMessages = {}

	return self
end
function t1.begin(p4) -- line: 47
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), ValidationEnums (copy)
	p4._startTime = os.clock()
	p4._status = if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then ValidationEnums.Status.PASS else ValidationEnums.Status.IN_PROGRESS
end
function t1.setReportingInstance(t2: {[any]: any}, p5) -- line: 56
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		return
	end

	t2._currentInstance = p5
end
function t1.fail(t3: {[any]: any}, s2: string, t4: {[any]: any}?, p6) -- line: 63
	-- upvalues: ValidationEnums (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), getRelativePath (copy)
	t3._status = ValidationEnums.Status.FAIL

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		table.insert(t3._failures, {
			failureStringKey = s2,
			failureStringParams = t4 or {},
			instancePath = getRelativePath(t3._rootInstance, p6 or t3._currentInstance)
		})

		return
	end

	table.insert(t3._failureMessages, {
		key = s2,
		params = t4 or {}
	})
end
function t1.warn(t5: {[any]: any}, s3: string, t6: {[any]: any}?, p7) -- line: 79
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), getRelativePath (copy)
	if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		return
	end

	table.insert(t5._warnings, {
		failureStringKey = s3,
		failureStringParams = t6 or {},
		instancePath = getRelativePath(t5._rootInstance, p7 or t5._currentInstance)
	})
end
function t1.forceError(_: {[any]: any}, s4: string) -- line: 91
	error({
		__forceError = true,
		message = s4
	})
end
function t1.fetchError(_: {[any]: any}, s5: string) -- line: 98
	error({
		__fetchError = true,
		message = s5
	})
end
function t1.err(t9: {[any]: any}, s6: string) -- line: 102
	-- upvalues: getFFlagDebugUGCValidationPrintNewStructureResults (copy), ValidationEnums (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		print("Reporting:", t9._testEnum, "has error:", s6)
	end

	t9._status = ValidationEnums.Status.ERROR
	t9._telemetryContext = s6

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		t9._failures = {}
		t9._warnings = {}

		return
	end

	t9._failureMessages = {}
end
function t1.complete(p8) -- line: 117
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), ValidationEnums (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy)
	local n1 = 0

	if p8._startTime then
		n1 = 1000 * (os.clock() - p8._startTime)
	end

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		if p8._status == ValidationEnums.Status.IN_PROGRESS then
			p8._status = ValidationEnums.Status.PASS
		end

		if getFFlagDebugUGCValidationPrintNewStructureResults() and p8._status ~= ValidationEnums.Status.PASS then
			print("Reporting:", p8._testEnum, "has status", p8._status, "in", n1)
		end

		return {
			validationEnum = p8._testEnum,
			status = p8._status,
			failures = p8._failures,
			warnings = p8._warnings,
			duration = n1,
			telemetryContext = p8._telemetryContext
		}
	end

	if getFFlagDebugUGCValidationPrintNewStructureResults() and p8._status ~= ValidationEnums.Status.PASS then
		print("Reporting:", p8._testEnum, "has status", p8._status, "in", n1)
	end

	return {
		validationEnum = p8._testEnum,
		status = p8._status,
		errorTranslationContexts = p8._failureMessages,
		duration = n1,
		telemetryContext = p8._telemetryContext
	}
end

return t1
