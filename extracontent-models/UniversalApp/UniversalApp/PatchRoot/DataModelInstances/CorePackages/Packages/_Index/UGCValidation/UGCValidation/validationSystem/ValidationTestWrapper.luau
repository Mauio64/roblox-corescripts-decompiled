local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ValidationModuleLoader = require(ParentParent.validationSystem.ValidationModuleLoader)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local ValidationReporter = require(ParentParent.validationSystem.ValidationReporter)
local getFFlagDebugUGCValidationPrintNewStructureResults = require(ParentParent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationFetchErrorMethod = require(ParentParent.flags.getFFlagUGCValidationFetchErrorMethod)
local ValidationConstants = require(ParentParent.validationSystem.ValidationConstants)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local TelemetryService = game:GetService("TelemetryService")

game:DefineFastInt("SingleValidationTelemetryThrottleHundrethsPercent", 10000)

local t1 = {
	eventName = "UgcSingleValidationFinished",
	description = "Report single ugc validation result to EventIngest backend.",
	links = "https://create.roblox.com/docs/art/validation-errors",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("SingleValidationTelemetryThrottleHundrethsPercent"),
	lastUpdated = {
		25,
		9,
		24
	}
}

local function reportSingleResult(s1: string, p1, s2: string, s3: string, n1: number) -- line: 45
	-- upvalues: TelemetryService (copy), t1 (copy)
	local t2 = {
		validationJobId = p1.jobId,
		validationSource = p1.consumerConfig.source,
		validationEnum = s1,
		status = s2,
		durationMs = n1,
		additional_info = s3
	}

	TelemetryService:LogEvent(t1, {
		customFields = t2
	})
end
local function getMissingData(p2, t3: {[any]: any}) -- line: 64
	-- upvalues: FetchAllDesiredData (copy)
	local t4 = {}

	for _, v29 in t3 do
		if p2[v29] == nil or p2[v29] == FetchAllDesiredData.DATA_FETCH_FAILURE then
			table.insert(t4, v29)
		end
	end

	return t4
end
local function checkAqsReturnSchema(p3, p4) -- line: 75
	-- upvalues: checkAqsReturnSchema (copy)
	if typeof(p3) ~= "table" then
		return false
	end

	for v32, v33 in p4 do
		if type(v33) == "table" and not checkAqsReturnSchema(p3[v32], v33) then
			return false
		end

		if type(v33) == "string" and not tonumber(p3[v33]) then
			return false
		end
	end

	return true
end
local function complete(s4: string, p5, p6) -- line: 91
	-- upvalues: reportSingleResult (copy)
	local v37 = p6:complete()

	reportSingleResult(s4, p5, v37.status, v37.telemetryContext, v37.duration)

	return v37
end
local function ValidationTestWrapper(s5: string, p7, t5: {[any]: any}) -- line: 97
	-- upvalues: ValidationModuleLoader (copy), ValidationReporter (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), ValidationEnums (copy), reportSingleResult (copy), getMissingData (copy), ValidationConstants (copy), ErrorSourceStrings (copy), checkAqsReturnSchema (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationFetchErrorMethod (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy)
	local v41 = ValidationModuleLoader.getValidationModule(s5)
	local v42 = ValidationReporter.new(s5, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else p7)

	for _, v44 in v41.prereqTests do
		if t5[v44] ~= ValidationEnums.Status.PASS then
			local v45 = v42:complete()

			reportSingleResult(s5, p7, v45.status, v45.telemetryContext, v45.duration)

			return v45
		end
	end

	local v46 = getMissingData(p7, v41.requiredData)

	if #v46 > 0 then
		v42:err(`Missing required data: { table.concat(v46, ", ") }`)

		local v47 = v42:complete()

		reportSingleResult(s5, p7, v47.status, v47.telemetryContext, v47.duration)

		return v47
	end

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		if v41.isAssetQualityModule then
			local v48 = p7.aqsSummaryData[s5]

			if v48 and v48.Error then
				local v49 = false

				for _, v51 in v48.Error do
					if v41.knownAqsUserErrors[v51] == nil then
						if table.find(ValidationConstants.AQSInternalErrorEnum, v51) ~= nil and v49 == false then
							v42:fail(ErrorSourceStrings.Keys.AQSInternalError)
							v49 = true

							continue
						end

						v42:err(`Unexpected error enum { v51 }`)

						local v52 = v42:complete()

						reportSingleResult(s5, p7, v52.status, v52.telemetryContext, v52.duration)

						return v52
					end

					v42:fail(v41.knownAqsUserErrors[v51])
				end

				local v53 = v42:complete()

				reportSingleResult(s5, p7, v53.status, v53.telemetryContext, v53.duration)

				return v53
			end
		end
	elseif not getEngineFeatureEngineUGCValidationExpandReturnSchema() and next(v41.expectedAqsData) ~= nil then
		for v54, _ in v41.expectedAqsData do
			local v56 = p7.aqsSummaryData[v54]
			local v57 = false

			if v56 and v56.Error then
				for _, v59 in v56.Error do
					if v41.knownAqsUserErrors[v59] == nil then
						if table.find(ValidationConstants.AQSInternalErrorEnum, v59) ~= nil and v57 == false then
							v42:fail(ErrorSourceStrings.Keys.AQSInternalError)
							v57 = true

							continue
						end

						v42:err(`Unexpected error enum { v59 }`)

						local v60 = v42:complete()

						reportSingleResult(s5, p7, v60.status, v60.telemetryContext, v60.duration)

						return v60
					end

					v42:fail(v41.knownAqsUserErrors[v59])
				end

				local v61 = v42:complete()

				reportSingleResult(s5, p7, v61.status, v61.telemetryContext, v61.duration)

				return v61
			end
		end

		if false then
			local v62 = v42:complete()

			reportSingleResult(s5, p7, v62.status, v62.telemetryContext, v62.duration)

			return v62
		end

		if not checkAqsReturnSchema(p7.aqsSummaryData, v41.expectedAqsData) then
			v42:err("Missing expected AQS schema")

			local v63 = v42:complete()

			reportSingleResult(s5, p7, v63.status, v63.telemetryContext, v63.duration)

			return v63
		end
	end

	v42:begin()

	if #getMissingData(p7, v41.conditionalData) > 0 then
		local v64 = v42:complete()

		reportSingleResult(s5, p7, v64.status, v64.telemetryContext, v64.duration)

		return v64
	end

	local ok, result = pcall(function() -- line: 196
		-- upvalues: v41 (copy), v42 (copy), p7 (copy)
		v41.run(v42, p7)
	end)

	if not ok then
		if getFFlagUGCValidateMigrateSchemaProperties() and type(result) == "table" and result.__forceError then
			error(result.message, 0)
		end

		if getFFlagUGCValidationFetchErrorMethod() and type(result) == "table" and result.__fetchError then
			if p7.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend then
				error(result.message, 0)
			end

			v42:err(result.message)

			local v67 = v42:complete()

			reportSingleResult(s5, p7, v67.status, v67.telemetryContext, v67.duration)

			return v67
		end

		if getFFlagDebugUGCValidationPrintNewStructureResults() then
			print("Validation error:", result)
			print("As this is in debug mode, we will re-call the function for a full error trace: ")
			v41.run(v42, p7)
		end

		v42:err(result)
	end

	local v68 = v42:complete()

	reportSingleResult(s5, p7, v68.status, v68.telemetryContext, v68.duration)

	return v68
end

return ValidationTestWrapper
