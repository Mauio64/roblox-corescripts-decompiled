local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ValidationModuleLoader = require(ParentParent.validationSystem.ValidationModuleLoader)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local ValidationReporter = require(ParentParent.validationSystem.ValidationReporter)
local getFFlagDebugUGCValidationPrintNewStructureResults = require(ParentParent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)
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

local function reportSingleResult(s1: string, p1, s2: string, s3: string, n1: number) -- line: 43
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
local function getMissingData(p2, t3: {[any]: any}) -- line: 62
	-- upvalues: FetchAllDesiredData (copy)
	local t4 = {}

	for _, v27 in t3 do
		if p2[v27] == nil or p2[v27] == FetchAllDesiredData.DATA_FETCH_FAILURE then
			table.insert(t4, v27)
		end
	end

	return t4
end
local function complete(s4: string, p3, p4) -- line: 73
	-- upvalues: reportSingleResult (copy)
	local v31 = p4:complete()

	reportSingleResult(s4, p3, v31.status, v31.telemetryContext, v31.duration)

	return v31
end
local function ValidationTestWrapper(s5: string, p5, t5: {[any]: any}) -- line: 79
	-- upvalues: ValidationModuleLoader (copy), ValidationReporter (copy), ValidationEnums (copy), reportSingleResult (copy), getMissingData (copy), ValidationConstants (copy), ErrorSourceStrings (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationFetchErrorMethod (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy)
	local v35 = ValidationModuleLoader.getValidationModule(s5)
	local v36 = ValidationReporter.new(s5, p5)

	for _, v38 in v35.prereqTests do
		if t5[v38] ~= ValidationEnums.Status.PASS then
			local v39 = v36:complete()

			reportSingleResult(s5, p5, v39.status, v39.telemetryContext, v39.duration)

			return v39
		end
	end

	local v40 = getMissingData(p5, v35.requiredData)

	if #v40 > 0 then
		v36:err(`Missing required data: { table.concat(v40, ", ") }`)

		local v41 = v36:complete()

		reportSingleResult(s5, p5, v41.status, v41.telemetryContext, v41.duration)

		return v41
	end

	if v35.isAssetQualityModule then
		local v42 = p5.aqsSummaryData[s5]

		if v42 and v42.Error then
			local v43 = false

			for _, v45 in v42.Error do
				if v35.knownAqsUserErrors[v45] == nil then
					if table.find(ValidationConstants.AQSInternalErrorEnum, v45) ~= nil and v43 == false then
						v36:fail(ErrorSourceStrings.Keys.AQSInternalError)
						v43 = true

						continue
					end

					v36:err(`Unexpected error enum { v45 }`)

					local v46 = v36:complete()

					reportSingleResult(s5, p5, v46.status, v46.telemetryContext, v46.duration)

					return v46
				end

				v36:fail(v35.knownAqsUserErrors[v45])
			end

			local v47 = v36:complete()

			reportSingleResult(s5, p5, v47.status, v47.telemetryContext, v47.duration)

			return v47
		end
	end

	v36:begin()

	if #getMissingData(p5, v35.conditionalData) > 0 then
		local v48 = v36:complete()

		reportSingleResult(s5, p5, v48.status, v48.telemetryContext, v48.duration)

		return v48
	end

	local ok, result = pcall(function() -- line: 134
		-- upvalues: v35 (copy), v36 (copy), p5 (copy)
		v35.run(v36, p5)
	end)

	if not ok then
		if getFFlagUGCValidateMigrateSchemaProperties() and type(result) == "table" and result.__forceError then
			error(result.message, 0)
		end

		if getFFlagUGCValidationFetchErrorMethod() and type(result) == "table" and result.__fetchError then
			if p5.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend then
				error(result.message, 0)
			end

			v36:err(result.message)

			local v51 = v36:complete()

			reportSingleResult(s5, p5, v51.status, v51.telemetryContext, v51.duration)

			return v51
		end

		if getFFlagDebugUGCValidationPrintNewStructureResults() then
			print("Validation error:", result)
			print("As this is in debug mode, we will re-call the function for a full error trace: ")
			v35.run(v36, p5)
		end

		v36:err(result)
	end

	local v52 = v36:complete()

	reportSingleResult(s5, p5, v52.status, v52.telemetryContext, v52.duration)

	return v52
end

return ValidationTestWrapper
