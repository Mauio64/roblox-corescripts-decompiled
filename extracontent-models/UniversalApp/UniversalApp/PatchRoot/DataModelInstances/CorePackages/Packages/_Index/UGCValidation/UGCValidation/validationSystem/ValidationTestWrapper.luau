local parent = script.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ValidationModuleLoader = require(parent.validationSystem.ValidationModuleLoader)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)
local ValidationReporter = require(parent.validationSystem.ValidationReporter)

local getFFlagDebugUGCValidationPrintNewStructureResults = require(parent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)
local getFFlagUGCValidationFetchErrorMethod = require(parent.flags.getFFlagUGCValidationFetchErrorMethod)
local ValidationConstants = require(parent.validationSystem.ValidationConstants)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local TelemetryService = game:GetService("TelemetryService")
game:DefineFastInt("SingleValidationTelemetryThrottleHundrethsPercent", 10000)

local v = {
	eventName = "UgcSingleValidationFinished",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("SingleValidationTelemetryThrottleHundrethsPercent"),
	lastUpdated = { 25, 9, 24 },
	description = "Report single ugc validation result to EventIngest backend.",
	links = "https://create.roblox.com/docs/art/validation-errors"
}

local function reportSingleResult(validationEnum: string, p, status: string, telemetryContext: string, duration: number)
	TelemetryService:LogEvent(v, {
		customFields = {
			validationJobId = p.jobId,
			validationSource = p.consumerConfig.source,
			validationEnum = validationEnum,
			status = status,
			durationMs = duration,
			additional_info = telemetryContext
		}
	})
end

local function getMissingData(p, items)
	local missingData = {}

	for _, item in items do
		if p[item] == nil or p[item] == FetchAllDesiredData.DATA_FETCH_FAILURE then
			table.insert(missingData, item)
		end
	end

	return missingData
end

local function complete(validationEnum: string, p, object) -- 7 equivalent calls inferred from this helper
	local v2 = object:complete()
	reportSingleResult(validationEnum, p, v2.status, v2.telemetryContext, v2.duration)
	return v2
end

local function ValidationTestWrapper(validationEnum: string, p, p2)
	local validationModule = ValidationModuleLoader.getValidationModule(validationEnum)
	local v2 = ValidationReporter.new(validationEnum, p)

	for _, prereqTest in validationModule.prereqTests do
		if p2[prereqTest] ~= ValidationEnums.Status.PASS then
			return complete(validationEnum, p, v2) -- inferred equivalent call
		end
	end

	local missingData = getMissingData(p, validationModule.requiredData)

	if #missingData > 0 then
		v2:err(`Missing required data: {table.concat(missingData, ", ")}`)
		return complete(validationEnum, p, v2) -- inferred equivalent call
	end

	if validationModule.isAssetQualityModule then
		local v3 = p.aqsSummaryData[validationEnum]

		if v3 and v3.Error then
			local v4 = false

			for _, v5 in v3.Error do
				if validationModule.knownAqsUserErrors[v5] == nil then
					if table.find(ValidationConstants.AQSInternalErrorEnum, v5) == nil or v4 ~= false then
						v2:err(`Unexpected error enum {v5}`)
						return complete(validationEnum, p, v2) -- inferred equivalent call
					end

					v2:fail(ErrorSourceStrings.Keys.AQSInternalError)
					v4 = true
				else
					v2:fail(validationModule.knownAqsUserErrors[v5])
				end
			end

			return complete(validationEnum, p, v2) -- inferred equivalent call
		end
	end

	v2:begin()

	if #getMissingData(p, validationModule.conditionalData) > 0 then
		return complete(validationEnum, p, v2) -- inferred equivalent call
	else
		local success, result = pcall(function()
			validationModule.run(v2, p)
		end)

		if not success then
			if type(result) == "table" and result.__forceError then
				error(result.message, 0)
			end

			if getFFlagUGCValidationFetchErrorMethod() and type(result) == "table" and result.__fetchError then
				local v3 = validationModule.shadowFlag() and not validationModule.fflag()

				if p.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend and not v3 then
					error(result.message, 0)
				end

				v2:err(result.message)
				return complete(validationEnum, p, v2) -- inferred equivalent call
			end

			if getFFlagDebugUGCValidationPrintNewStructureResults() then
				print("Validation error:", result)
				print("As this is in debug mode, we will re-call the function for a full error trace: ")
				validationModule.run(v2, p)
			end

			v2:err(result)
		end

		return complete(validationEnum, p, v2) -- inferred equivalent call
	end
end

return ValidationTestWrapper
