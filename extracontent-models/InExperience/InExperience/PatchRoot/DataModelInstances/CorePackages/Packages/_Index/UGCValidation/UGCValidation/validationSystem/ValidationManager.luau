local parent = script.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ValidationModuleLoader = require(parent.validationSystem.ValidationModuleLoader)
local Constants = require(parent.Constants)
local ValidationTestWrapper = require(parent.validationSystem.ValidationTestWrapper)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)
local FetchContentIds = require(parent.validationSystem.dataFetchModules.FetchContentIds)
local getUploadCategory = require(parent.util.getUploadCategory)
local RecreateSceneFromEditables = require(parent.util.RecreateSceneFromEditables)
local stripMeshFromGltf = require(parent.util.stripMeshFromGltf)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local R15plusUtils = require(parent.util.R15plusUtils)
local resetPhysicsData = require(parent.util.resetPhysicsData)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(parent.flags.getFFlagDebugAllowHRDUploadOnBundleBackend)

local getEngineFeatureEngineUGCValidateInstanceTreesEquivalent = require(parent.flags.getEngineFeatureEngineUGCValidateInstanceTreesEquivalent)
local getFFlagUGCValidationAllowFullVaas = require(parent.flags.getFFlagUGCValidationAllowFullVaas)
local getFFlagUGCValidateAQSRequiresOnlySummary = require(parent.flags.getFFlagUGCValidateAQSRequiresOnlySummary)
local getFFlagDebugUGCDisableAssetQualityChecks = require(parent.flags.getFFlagDebugUGCDisableAssetQualityChecks)

local getEngineFeatureEngineDebugUGCValidationViaLocalRCC = require(parent.flags.getEngineFeatureEngineDebugUGCValidationViaLocalRCC)

local getEngineFeatureEngineUGCValidateEmoteAnimationExport = require(parent.flags.getEngineFeatureEngineUGCValidateEmoteAnimationExport)

local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local RunService = game:GetService("RunService")
local AssetQualityService = game:GetService("AssetQualityService")

game:DefineFastInt("FullValidationTelemetryThrottleHundrethsPercent", 10000)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local v = {
	eventName = "UgcFullValidationFinished",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("FullValidationTelemetryThrottleHundrethsPercent"),
	lastUpdated = { 26, 9, 4 },
	description = "Report result of ugc validation suite",
	links = "https://create.roblox.com/docs/art/validation-errors"
}

local getFFlagDebugUGCValidationPrintNewStructureResults = require(parent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)

local getFIntUGCValidationFetchQualityMaxRetry = require(parent.flags.getFIntUGCValidationFetchQualityMaxRetry)

local getEngineFeatureEngineAssetQualityV2SummaryFromUrl = require(parent.flags.getEngineFeatureEngineAssetQualityV2SummaryFromUrl)
local getFIntUGCValidationFetchQualityRetryDelayMs = require(parent.flags.getFIntUGCValidationFetchQualityRetryDelayMs)

local ValidationManager = {}
local v2 = { Publish = true, Backend = true, Internal = true }

local v3 = { InExpServer = true, InExpClient = true }

local v4 = {
	Toolbox = ValidationEnums.ConsumerEnv.Studio,
	AutoSetup = ValidationEnums.ConsumerEnv.Studio,
	Publish = ValidationEnums.ConsumerEnv.Backend,
	Backend = ValidationEnums.ConsumerEnv.Backend,
	Internal = ValidationEnums.ConsumerEnv.Backend,
	InExpServer = ValidationEnums.ConsumerEnv.IEC,
	InExpClient = ValidationEnums.ConsumerEnv.IEC
}

local AssetQualityFetchStatus = ValidationEnums.AssetQualityFetchStatus
local set

if getEngineFeatureEngineDebugUGCValidationViaLocalRCC() then
	set = {}
	set[ValidationEnums.ValidationModule.DescendantIdsAllowed] = true
	set[ValidationEnums.ValidationModule.DescendantIdsPublished] = true
else
	set = nil
end

local function initRunVariables(uploadCategory: string, consumerConfig)
	local skipModules = consumerConfig.skipModules
	local result = {}
	local result2 = {}
	local result3 = {}

	for k, allModule in ValidationModuleLoader.allModules do
		if
			skipModules[k]
			or getFFlagDebugUGCDisableAssetQualityChecks()
			and consumerConfig.skipAssetQualityChecks
			and allModule.isAssetQualityModule
		then
			continue
		end

		local categories = allModule.categories

		if not (table.find(categories, uploadCategory) and (allModule.fflag() or allModule.shadowFlag())) then
			continue
		end

		local isShadow = allModule.shadowFlag() and not allModule.fflag()

		for _, v5 in allModule.requiredData do
			result[v5] = true
		end

		for _, v5 in allModule.conditionalData do
			result[v5] = true
		end

		local isAssetQualityModule = allModule.isAssetQualityModule

		if isAssetQualityModule then
			table.insert(result2, k)
		end

		local prereqTestSet = {}

		for _, prereqTest in allModule.prereqTests do
			prereqTestSet[prereqTest] = true
		end

		result3[k] = {
			name = k,
			prereqs = prereqTestSet,
			postreqs = {},
			isQuality = isAssetQualityModule,
			isShadow = isShadow
		}
	end

	if getFFlagUGCValidateAQSRequiresOnlySummary() and #result2 > 0 and consumerConfig.aqFetchStage == "scene" then
		for _, v5 in RecreateSceneFromEditables.requiredData do
			result[v5] = true
		end
	end

	for k, v5 in result3 do
		for k2, _ in v5.prereqs do
			if result3[k2] == nil then
				error(string.format("%s is needed for %s to run, but is not an included test", k2, k))
			end

			table.insert(result3[k2].postreqs, k)
		end
	end

	return result2, result3, result
end

local function fetchQualityResults(state, p)
	if AssetQualityService then
		local result = nil
		local v5 = nil
		local v6 = nil
		local success

		if state.consumerConfig.aqFetchStage == "scene" then
			success, result = pcall(function()
				if getFFlagUGCValidateAQSRequiresOnlySummary() then
					for _, v7 in RecreateSceneFromEditables.requiredData do
						if state[v7] == FetchAllDesiredData.DATA_FETCH_FAILURE then
							error(`Missing scene data: {v7}`)
						end
					end
				end

				v6 = RecreateSceneFromEditables.createModelForGltfExport(state)
				v5 = AssetQualityService:GenerateAssetQualityGltfFromInstanceAsync(v6)
			end)

			if
				getEngineFeatureEngineUGCValidateEmoteAnimationExport()
				and success
				and v5
				and state.uploadCategory == ValidationEnums.UploadCategory.EMOTE_ANIMATION
			then
				local success2, result2 = pcall(stripMeshFromGltf, v5)

				if success2 then
					v5 = result2
				end
			end
		else
			if state.consumerConfig.aqFetchStage == "gltf" then
				v5 = state.consumerConfig.aqFetchData
			end

			success = true
		end

		if success then
			local fIntUGCValidationFetchQualityRetryDelayMs = getFIntUGCValidationFetchQualityRetryDelayMs()

			for i = 1, 1 + getFIntUGCValidationFetchQualityMaxRetry() do
				if i > 1 and fIntUGCValidationFetchQualityRetryDelayMs > 0 then
					task.wait(fIntUGCValidationFetchQualityRetryDelayMs / 1000)
				end

				success, result = pcall(function()
					state.aqsFetchMetrics.fetchAttemptCount = i
					local lastTime = os.clock()
					local v7

					if state.consumerConfig.aqFetchStage == "jobId" then
						local v8

						if getEngineFeatureEngineAssetQualityV2SummaryFromUrl() then
							v8 = state.consumerConfig.aqJobId
						else
							v8 = state.consumerConfig.aqFetchData
						end

						if getFFlagUGCValidationAllowFullVaas() and v8 ~= nil and v8 ~= "" then
							v7 = AssetQualityService:FetchAssetQualitySummaryFromJobIdV2Async(v8, p)
						else
							v7 = AssetQualityService:FetchAssetQualitySummaryFromJobIdAsync(v8, p)
						end
					elseif state.consumerConfig.aqFetchStage == "summaryUrl" then
						v7 = AssetQualityService:FetchAssetQualitySummaryFromUrlAsync(
							state.consumerConfig.aqSummaryUrl,
							state.consumerConfig.aqJobId,
							p
						)
					else
						v7 = AssetQualityService:FetchAssetQualitySummaryFromGltfAsync(v5, p)
					end

					local fetchTimeMs = 1000 * (os.clock() - lastTime)
					state.aqsFetchMetrics.visualizationUrl = v7.visualizationUrl
					state.aqsFetchMetrics.fetchTimeMs = fetchTimeMs
					state.aqsFetchMetrics.aqJobId = v7.aqJobId
					state.aqsSummaryData = HttpService:JSONDecode(v7.rawJson)
				end)

				if success then
					break
				end
			end
		end

		if success then
			state.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchSuccess

			if getFFlagDebugUGCValidationPrintNewStructureResults() then
				print(string.format(
					"AQS fetch success: aqJobId=%s attempts=%d fetchTimeMs=%d",
					state.aqsFetchMetrics.aqJobId or "",
					state.aqsFetchMetrics.fetchAttemptCount or 0,
					state.aqsFetchMetrics.fetchTimeMs or 0
				))

				print(state.aqsSummaryData)
			end
		else
			state.aqsFetchMetrics.fetchFailureReason = result
			state.aqsSummaryData = FetchAllDesiredData.DATA_FETCH_FAILURE
			state.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchFailure

			if getFFlagDebugUGCValidationPrintNewStructureResults() then
				print("AQS fetch failure:", result)
			end
		end

		if v6 then
			v6:Destroy()
		end
	else
		state.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchFailure
		state.aqsFetchMetrics.fetchFailureReason = "Not enabled"
	end
end

local function getNextLayer(items, flag: boolean)
	local nextLayer = {}

	for k, item in items do
		if next(item.prereqs) == nil and (flag or not item.isQuality) then
			table.insert(nextLayer, k)
		end
	end

	return nextLayer
end

local function populateRelevantSourceStrings(data)
	local function capture(failureStringKey: string) -- 2 equivalent calls inferred from this helper
		local parts = failureStringKey:split(".")
		local part = parts[#parts]
		local value = ErrorSourceStrings.Values[part]

		if value then
			data.relevantSourceStrings[failureStringKey] = value
		end
	end

	for _, failure in data.failureMap do
		for _, v5 in failure do
			capture(v5.failureStringKey) -- inferred equivalent call
		end
	end

	for _, warning in data.warningMap do
		for _, v5 in warning do
			capture(v5.failureStringKey) -- inferred equivalent call
		end
	end
end

local function getDebugLabel(p) -- 2 equivalent calls inferred from this helper
	local uploadEnum = p.uploadEnum

	if uploadEnum.assetType then
		return uploadEnum.assetType.Name
	end

	if uploadEnum.bundleType then
		return uploadEnum.bundleType.Name
	end

	return "?"
end

local function reportFullResult(data, data2, durationMs: number)
	local v5 = data2.aqsFetchMetrics.fetchStatus ~= AssetQualityFetchStatus.assetQualityFetchNA
	local customFields = {
		validationJobId = data2.jobId,
		bundleJobId = data2.consumerConfig.telemetryBundleId,
		rootInstanceId = data2.consumerConfig.telemetryRootId,
		studioSid = RbxAnalyticsService:GetSessionId(),
		clientId = RbxAnalyticsService:GetClientId(),
		placeId = game.PlaceId,
		validationSource = data2.consumerConfig.source,
		assetType = data2.uploadEnum.assetType and data2.uploadEnum.assetType.Value or 0,
		bundleType = data2.uploadEnum.bundleType and data2.uploadEnum.bundleType.Value or 0,
		numFailures = data.numFailures,
		passed = data.pass,
		durationMs = durationMs,
		uploadCategory = data2.uploadCategory,
		aqFetchStatus = data2.aqsFetchMetrics.fetchStatus,
		aqFetchAttemptCount = v5 and data2.aqsFetchMetrics.fetchAttemptCount or 0,
		aqFetchTimeMs = v5 and data2.aqsFetchMetrics.fetchTimeMs or 0,
		aqFetchFailureReason = v5 and data2.aqsFetchMetrics.fetchFailureReason or "",
		aqJobId = data2.aqsFetchMetrics.aqJobId or ""
	}

	if getFFlagUGCValidationAllowFullVaas() then
		customFields.isVaas = data2.consumerConfig.isVaaS or false
		customFields.aqFetchStage = data2.consumerConfig.aqFetchStage
	end

	TelemetryService:LogEvent(v, { customFields = customFields })

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		print(string.format(
			"==== %s Validation end ==== pass=%s numFailures=%d numWarnings=%d durationMs=%d",
			getDebugLabel(data2), -- inferred equivalent call
			tostring(data.pass),
			data.numFailures,
			data.numWarnings,
			durationMs
		))

		for k, failure in data.failureMap do
			for _, v6 in failure do
				print(string.format(
					"  FAIL %s: %s @ %s",
					k,
					v6.failureStringKey,
					v6.instancePath == "" and "<root>" or v6.instancePath
				))
			end
		end

		print(data)
	end
end

local function updateResultData(state, p, data, _: string, enforceShadowValidations: boolean)
	local validationEnum = data.validationEnum

	if enforceShadowValidations or not p[validationEnum].isShadow then
		state.states[validationEnum] = data.status

		if data.status ~= ValidationEnums.Status.PASS then
			state.pass = false
			state.numFailures += math.max(1, #data.failures)
		end

		if #data.failures > 0 then
			state.failureMap[validationEnum] = data.failures
		end

		if #data.warnings > 0 then
			state.warningMap[validationEnum] = data.warnings
			state.numWarnings += #data.warnings
		end

		if data.status == ValidationEnums.Status.ERROR then
			state.ranIntoInternalError = true
		end
	end

	for _, postreq in p[validationEnum].postreqs do
		p[postreq].prereqs[validationEnum] = nil
	end

	p[validationEnum] = nil
end

local function createConsumerConfigWithDefaults(p)
	local clone = table.clone(p)

	if clone.enforceR15FolderStructure == nil then
		clone.enforceR15FolderStructure = true
	end

	if clone.enforceShadowValidations == nil then
		clone.enforceShadowValidations = false
	end

	clone.telemetryBundleId = clone.telemetryBundleId or ""
	clone.telemetryRootId = clone.telemetryRootId or ""
	clone.preloadedEditableMeshes = clone.preloadedEditableMeshes or {}
	clone.preloadedEditableImages = clone.preloadedEditableImages or {}
	clone.preloadedHsrAssets = clone.preloadedHsrAssets or {}
	clone.preloadedCurveAnimations = clone.preloadedCurveAnimations or {}
	clone.skipModules = clone.skipModules or {}

	if set then
		clone.skipModules = table.clone(clone.skipModules)

		for k in set do
			clone.skipModules[k] = true
		end
	end

	clone.skipAssetQualityChecks = clone.skipAssetQualityChecks or false
	clone.skipPhysicsDataReset = clone.skipPhysicsDataReset or false
	clone.isVaaS = clone.isVaaS or false

	clone.consumerEnv = v4[clone.source]
	assert(clone.consumerEnv ~= nil, `unknown consumer source: {tostring(clone.source)}`)

	if getFFlagUGCValidationAllowFullVaas() and clone.isVaaS then
		clone.validationEnv = ValidationEnums.ValidationEnv.Backend
	else
		clone.validationEnv = clone.consumerEnv
	end

	clone.backendConfigs = clone.backendConfigs or {}
	clone.iecConfigs = clone.iecConfigs or {}

	clone.aqFetchStage = clone.aqFetchStage or "scene"
	clone.aqFetchData = clone.aqFetchData or ""
	local v5 = clone.aqFetchData

	if getEngineFeatureEngineAssetQualityV2SummaryFromUrl() then
		clone.aqJobId = clone.aqJobId or ""
		clone.aqSummaryUrl = clone.aqSummaryUrl or ""

		if clone.aqFetchStage == "jobId" then
			v5 = clone.aqJobId
		elseif clone.aqFetchStage == "summaryUrl" then
			v5 = clone.aqSummaryUrl
		end
	else
		assert(
			clone.aqFetchStage ~= "summaryUrl",
			"aqFetchStage \"summaryUrl\" requires EngineAssetQualityV2SummaryFromUrl"
		)
	end

	assert(
		(clone.aqFetchStage == "scene") == (v5 == ""),
		`aqFetchData/aqJobId/aqSummaryUrl (per stage) must be non-empty iff aqFetchStage is not "scene" (got stage="{clone.aqFetchStage}")`
	)

	return clone
end

local function runValidationOnRootInstance(state)
	local lastTime = os.clock()

	local rootInstance = state.rootInstance
	local assetType = state.uploadEnum.assetType
	local bundleType = state.uploadEnum.bundleType
	local consumerConfig = state.consumerConfig

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		print(string.format(
			"==== %s Validation begin ==== jobId=%s source=%s",
			getDebugLabel(state), -- inferred equivalent call
			state.jobId,
			state.consumerConfig.source
		))
	end

	local v5 = {
		validationJobId = state.jobId,
		telemetryBundleId = 0,
		pass = true,
		numFailures = 0,
		numWarnings = 0,
		states = 0,
		ranIntoInternalError = false,
		failureMap = 0,
		warningMap = 0,
		relevantSourceStrings = 0,
		aqJobId = ""
	}
	local telemetryBundleId

	if getFFlagUGCValidationAllowFullVaas() then
		telemetryBundleId = consumerConfig.telemetryBundleId
	end

	v5.telemetryBundleId = telemetryBundleId

	v5.states = {}

	v5.failureMap = {}
	v5.warningMap = {}
	v5.relevantSourceStrings = {}

	local uploadCategory = getUploadCategory(rootInstance, assetType, bundleType)

	local v6, v7, v8 = initRunVariables(uploadCategory, consumerConfig)
	state.uploadCategory = uploadCategory
	local aqsFetchMetrics = {
		fetchStatus = AssetQualityFetchStatus.assetQualityFetchNA,
		aqJobId = 0
	}
	local aqJobId

	if getEngineFeatureEngineAssetQualityV2SummaryFromUrl() then
		aqJobId = consumerConfig.aqJobId
	elseif consumerConfig.aqFetchStage == "jobId" then
		aqJobId = consumerConfig.aqFetchData
	end

	aqsFetchMetrics.aqJobId = aqJobId
	state.aqsFetchMetrics = aqsFetchMetrics

	updateResultData(
		v5,
		v7,
		ValidationTestWrapper(ValidationEnums.ValidationModule.ExpectedRootSchema, state, v5.states),
		state.jobId,
		consumerConfig.enforceShadowValidations
	)

	if v5.states[ValidationEnums.ValidationModule.ExpectedRootSchema] == ValidationEnums.Status.PASS then
		local descendantIdsPublished = ValidationEnums.ValidationModule.DescendantIdsPublished

		if v7[descendantIdsPublished] then
			state.contentIds = FetchContentIds.getData(state)
			updateResultData(
				v5,
				v7,
				ValidationTestWrapper(descendantIdsPublished, state, v5.states),
				state.jobId,
				consumerConfig.enforceShadowValidations
			)
			local state2 = v5.states[descendantIdsPublished]

			if state2 ~= nil and state2 ~= ValidationEnums.Status.PASS then
				populateRelevantSourceStrings(v5)
				v5.aqJobId = state.aqsFetchMetrics.aqJobId or ""
				reportFullResult(v5, state, 1000 * (os.clock() - lastTime))
				return v5
			end
		end

		if
			getFFlagUGCValidationAllowFullVaas()
			and state.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
		then
			local bypassFlags = { skipPhysicsDataReset = state.consumerConfig.skipPhysicsDataReset }
			resetPhysicsData({ state.rootInstance }, { isServer = true, bypassFlags = bypassFlags })
		end

		local v9 = v2[consumerConfig.source] or consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

		FetchAllDesiredData.storeDesiredData(state, v8)

		if #v6 > 0 then
			state.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchInProgress

			if v9 then
				RunService:Run()
				fetchQualityResults(state, v6)
				RunService:Pause()
			else
				task.spawn(fetchQualityResults, state, v6)
			end
		end

		while next(v7) ~= nil do
			local v10 = state.aqsFetchMetrics.fetchStatus == AssetQualityFetchStatus.assetQualityFetchInProgress
			local nextLayer = getNextLayer(v7, not v10)

			if #nextLayer == 0 and not v10 then
				error("Impossible to complete all layers")
			end

			for _, v11 in nextLayer do
				updateResultData(
					v5,
					v7,
					ValidationTestWrapper(v11, state, v5.states),
					state.jobId,
					consumerConfig.enforceShadowValidations
				)

				if not v3[consumerConfig.source] or v9 then
					continue
				end

				task.wait()
			end

			if not v10 or v9 then
				continue
			end

			task.wait()
		end

		populateRelevantSourceStrings(v5)
		v5.aqJobId = state.aqsFetchMetrics.aqJobId or ""
		reportFullResult(v5, state, 1000 * (os.clock() - lastTime))
		return v5
	end

	populateRelevantSourceStrings(v5)
	v5.aqJobId = state.aqsFetchMetrics.aqJobId or ""
	reportFullResult(v5, state, -1)
	return v5
end

local function getRootInstance(list) -- 1 equivalent call inferred from this helper
	if #list == 0 then
		return nil
	end

	for _, item in list do
		if item.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return item
		end
	end

	return list[1]
end

local function findFolderByName(allSelectedInstances, p: string, flag: boolean) -- 1 equivalent call inferred from this helper
	for _, item in allSelectedInstances do
		if item.Name == p then
			return item
		end
	end

	return if flag then allSelectedInstances[1] else nil
end

local function synthesizeRootFromFolders(items, p: string, flag: boolean)
	local folder = Instance.new("Folder")

	for _, item in items do
		local folderByName = findFolderByName(item.allSelectedInstances, p, flag) -- inferred equivalent call

		if folderByName == nil then
			continue
		end

		if folderByName:IsA("Folder") or folderByName:IsA("Model") then
			for _, child in folderByName:GetChildren() do
				local clone = child:Clone()
				clone.Parent = folder
			end
		else
			local clone = folderByName:Clone()
			clone.Parent = folder
		end
	end

	return folder
end

function ValidationManager.ValidateAsset(entrypointInput, assetType, p)
	local v5 = {
		jobId = HttpService:GenerateGUID(),
		entrypointInput = entrypointInput,
		rootInstance = getRootInstance(entrypointInput), -- inferred equivalent call
		r15LegacyDuplicateRoot = 0,
		uploadEnum = 0,
		consumerConfig = 0,
		hsrAssets = 0
	}
	local r15LegacyDuplicateRoot

	if getEngineFeatureEngineUGCValidateInstanceTreesEquivalent() then
		local r15Fixed = Constants.FOLDER_NAMES.R15Fixed

		for _, item in entrypointInput do
			if item.Name == r15Fixed then
				r15LegacyDuplicateRoot = item
				break
			end
		end
	end

	v5.r15LegacyDuplicateRoot = r15LegacyDuplicateRoot

	v5.uploadEnum = { assetType = assetType }

	v5.consumerConfig = createConsumerConfigWithDefaults(p)
	v5.hsrAssets = {}

	return runValidationOnRootInstance(v5)
end

function ValidationManager.ValidateFinalizedBundle(entrypointInput, bundleType, p)
	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(p.source == "Publish" or p.source == "Backend")
	end

	local r15LegacyDuplicateRoot = nil
	local v5

	if bundleType == Enum.BundleType.Animations then
		v5 = Instance.new("Model")

		for _, item in entrypointInput do
			local allSelectedInstances = item.allSelectedInstances
			local v6

			if #allSelectedInstances == 0 then
				local allSelectedInstance = nil
				v6 = allSelectedInstance
			else
				local flag = true

				for _, allSelectedInstance in allSelectedInstances do
					if allSelectedInstance.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						v6 = allSelectedInstance
						flag = false
						break
					end
				end

				if flag then
					v6 = allSelectedInstances[1]
				end
			end

			if v6 == nil then
				continue
			end

			local clone = v6:Clone()
			clone.Parent = v5
		end
	elseif getEngineFeatureEngineUGCValidateInstanceTreesEquivalent() then
		v5 = synthesizeRootFromFolders(entrypointInput, Constants.FOLDER_NAMES.R15ArtistIntent, true)
		r15LegacyDuplicateRoot = synthesizeRootFromFolders(entrypointInput, Constants.FOLDER_NAMES.R15Fixed, true)
	else
		v5 = Instance.new("Folder")

		for _, item in entrypointInput do
			local allSelectedInstances = item.allSelectedInstances
			local instance

			if #allSelectedInstances == 0 then
				local allSelectedInstance = nil
				instance = allSelectedInstance
			else
				local flag = true

				for _, allSelectedInstance in allSelectedInstances do
					if allSelectedInstance.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						instance = allSelectedInstance
						flag = false
						break
					end
				end

				if flag then
					instance = allSelectedInstances[1]
				end
			end

			if instance == nil then
				continue
			end

			if instance:IsA("Folder") or instance:IsA("Model") then
				for _, child in instance:GetChildren() do
					local clone = child:Clone()
					clone.Parent = v5
				end
			else
				local clone = instance:Clone()
				clone.Parent = v5
			end
		end
	end

	local v6 = runValidationOnRootInstance({
		jobId = HttpService:GenerateGUID(),
		entrypointInput = entrypointInput,
		rootInstance = v5,
		r15LegacyDuplicateRoot = r15LegacyDuplicateRoot,
		uploadEnum = { bundleType = bundleType },
		consumerConfig = createConsumerConfigWithDefaults(p),
		hsrAssets = {}
	})

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(false)
	end

	return v6
end

return ValidationManager
