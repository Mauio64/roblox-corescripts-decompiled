local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ValidationModuleLoader = require(ParentParent.validationSystem.ValidationModuleLoader)
local Constants = require(ParentParent.Constants)
local ValidationTestWrapper = require(ParentParent.validationSystem.ValidationTestWrapper)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local getUploadCategory = require(ParentParent.util.getUploadCategory)
local RecreateSceneFromEditables = require(ParentParent.util.RecreateSceneFromEditables)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineAQSJsonParsingInLua = require(ParentParent.flags.getEngineFeatureEngineAQSJsonParsingInLua)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(ParentParent.flags.getFFlagDebugAllowHRDUploadOnBundleBackend)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local RunService = game:GetService("RunService")
local AssetQualityService = game:GetService("AssetQualityService")

game:DefineFastInt("FullValidationTelemetryThrottleHundrethsPercent", 10000)

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local t1 = {
	eventName = "UgcFullValidationFinished",
	description = "Report result of ugc validation suite",
	links = "https://create.roblox.com/docs/art/validation-errors",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("FullValidationTelemetryThrottleHundrethsPercent"),
	lastUpdated = {
		25,
		11,
		18
	}
}
local getFFlagDebugUGCValidationPrintNewStructureResults = require(ParentParent.flags.getFFlagDebugUGCValidationPrintNewStructureResults)
local getEngineFeatureEngineAssetQualityEngineService = require(ParentParent.flags.getEngineFeatureEngineAssetQualityEngineService)
local getFIntUGCValidationFetchQualityMaxRetry = require(ParentParent.flags.getFIntUGCValidationFetchQualityMaxRetry)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local t2 = {}
local t3 = {
	Publish = true,
	Backend = true,
	Internal = true
}
local t4 = {
	InExpServer = true,
	InExpClient = true
}
local t5 = {
	Toolbox = ValidationEnums.ConsumerEnv.Studio,
	AutoSetup = ValidationEnums.ConsumerEnv.Studio,
	Publish = ValidationEnums.ConsumerEnv.Backend,
	Backend = ValidationEnums.ConsumerEnv.Backend,
	Internal = ValidationEnums.ConsumerEnv.Backend,
	InExpServer = ValidationEnums.ConsumerEnv.IEC,
	InExpClient = ValidationEnums.ConsumerEnv.IEC
}
local AssetQualityFetchStatus = ValidationEnums.AssetQualityFetchStatus

local function initRunVariables(s1: string, p1) -- line: 81
	-- upvalues: getFFlagUGCValidateMigrateSchemaProperties (copy), ValidationModuleLoader (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local v46 = if not getFFlagUGCValidateMigrateSchemaProperties() then {} else p1.skipModules

	for v47, v48 in ValidationModuleLoader.allModules do
		if not v46[v47] then
			local categories = v48.categories

			if table.find(categories, s1) and (v48.fflag() or v48.shadowFlag()) then
				local v50 = v48.shadowFlag() and not v48.fflag()

				for _, v52 in v48.requiredData do
					t8[v52] = true
				end

				for _, v54 in v48.conditionalData do
					t8[v54] = true
				end

				local v55 = if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then next(v48.expectedAqsData) ~= nil else v48.isAssetQualityModule

				if v55 then
					table.insert(t6, v47)
				end

				local t9 = {}

				for _, v58 in v48.prereqTests do
					t9[v58] = true
				end

				t7[v47] = {
					name = v47,
					prereqs = t9,
					postreqs = {},
					isQuality = v55,
					isShadow = v50
				}
			end
		end
	end

	for v59, v60 in t7 do
		for v61, _ in v60.prereqs do
			if t7[v61] == nil then
				error(string.format("%s is needed for %s to run, but is not an included test", v61, v59))
			end

			table.insert(t7[v61].postreqs, v59)
		end
	end

	return t6, t7, t8
end
local function fetchQualityResults(p2, t10: {[any]: any}) -- line: 155
	-- upvalues: getEngineFeatureEngineAssetQualityEngineService (copy), AssetQualityService (copy), AssetQualityFetchStatus (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), RecreateSceneFromEditables (copy), getFIntUGCValidationFetchQualityMaxRetry (copy), getEngineFeatureEngineAQSJsonParsingInLua (copy), HttpService (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy), FetchAllDesiredData (copy)
	if not getEngineFeatureEngineAssetQualityEngineService() or not AssetQualityService then
		p2.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchFailure
		p2.aqsFetchMetrics.fetchFailureReason = "Not enabled"

		return
	end

	local result = nil
	local aqFetchData = nil
	local u67 = nil
	local v68

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() and p2.consumerConfig.aqFetchStage ~= "scene" then
		if p2.consumerConfig.aqFetchStage == "gltf" then
			aqFetchData = p2.consumerConfig.aqFetchData
		end

		v68 = true
	else
		u67 = RecreateSceneFromEditables.createModelForGltfExport(p2)
		v68, result = pcall(function() -- line: 173
			-- upvalues: aqFetchData (ref), AssetQualityService (copy), u67 (ref)
			aqFetchData = AssetQualityService:GenerateAssetQualityGltfFromInstanceAsync(u67)
		end)
	end

	if v68 then
		for i = 1, 1 + getFIntUGCValidationFetchQualityMaxRetry() do
			v68, result = pcall(function() -- line: 181
				-- upvalues: p2 (copy), i (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), AssetQualityService (copy), t10 (copy), aqFetchData (ref), getEngineFeatureEngineAQSJsonParsingInLua (copy), HttpService (copy)
				p2.aqsFetchMetrics.fetchAttemptCount = i

				local elapsed = os.clock()
				local v179 = if not getEngineFeatureEngineUGCValidationExpandReturnSchema() or p2.consumerConfig.aqFetchStage ~= "jobId" then AssetQualityService:FetchAssetQualitySummaryFromGltfAsync(aqFetchData, t10) else AssetQualityService:FetchAssetQualitySummaryFromJobIdAsync(p2.consumerConfig.aqFetchData, t10)
				local v180 = 1000 * (os.clock() - elapsed)

				p2.aqsFetchMetrics.visualizationUrl = v179.visualizationUrl
				p2.aqsFetchMetrics.fetchTimeMs = v180

				if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
					p2.aqsFetchMetrics.aqJobId = v179.aqJobId
				end

				if getEngineFeatureEngineAQSJsonParsingInLua() then
					p2.aqsSummaryData = HttpService:JSONDecode(v179.rawJson)

					return
				end

				p2.aqsFetchMetrics.returnVersion = v179.version
				p2.aqsSummaryData = v179
			end)

			if v68 then
				break
			end
		end
	end

	if v68 then
		p2.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchSuccess

		if getFFlagDebugUGCValidationPrintNewStructureResults() then
			print(string.format("AQS fetch success: aqJobId=%s attempts=%d fetchTimeMs=%d", p2.aqsFetchMetrics.aqJobId or "", p2.aqsFetchMetrics.fetchAttemptCount or 0, p2.aqsFetchMetrics.fetchTimeMs or 0))
			print(p2.aqsSummaryData)
		end
	else
		p2.aqsFetchMetrics.fetchFailureReason = result
		p2.aqsSummaryData = FetchAllDesiredData.DATA_FETCH_FAILURE
		p2.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchFailure

		if getFFlagDebugUGCValidationPrintNewStructureResults() then
			print("AQS fetch failure:", result)
		end
	end

	if u67 then
		u67:Destroy()
	end
end
local function getNextLayer(t11: {[any]: any}, b1: boolean) -- line: 243
	local t12 = {}

	for v73, v74 in t11 do
		if next(v74.prereqs) == nil and (b1 or not v74.isQuality) then
			table.insert(t12, v73)
		end
	end

	return t12
end
local function populateRelevantSourceStrings(p3) -- line: 258
	-- upvalues: ErrorSourceStrings (copy)
	local function capture(s2: string) -- line: 259
		-- upvalues: ErrorSourceStrings (copy), p3 (copy)
		local parts = s2:split(".")
		local v183 = parts[#parts]
		local v184 = ErrorSourceStrings.Values[v183]

		if v184 then
			p3.relevantSourceStrings[s2] = v184
		end
	end

	for _, v78 in p3.failureMap do
		for _, v80 in v78 do
			local failureStringKey = v80.failureStringKey
			local parts = failureStringKey:split(".")
			local v83 = parts[#parts]
			local v84 = ErrorSourceStrings.Values[v83]

			if v84 then
				p3.relevantSourceStrings[failureStringKey] = v84
			end
		end
	end

	for _, v86 in p3.warningMap do
		for _, v88 in v86 do
			local failureStringKey = v88.failureStringKey
			local parts = failureStringKey:split(".")
			local v91 = parts[#parts]
			local v92 = ErrorSourceStrings.Values[v91]

			if v92 then
				p3.relevantSourceStrings[failureStringKey] = v92
			end
		end
	end
end
local function getDebugLabel(p4) -- line: 280
	local uploadEnum = p4.uploadEnum

	if uploadEnum.assetType then
		return uploadEnum.assetType.Name
	end

	if uploadEnum.bundleType then
		return uploadEnum.bundleType.Name
	end

	return "?"
end
local function reportFullResult(p5, p6, n1: number) -- line: 290
	-- upvalues: AssetQualityFetchStatus (copy), RbxAnalyticsService (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), TelemetryService (copy), t1 (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy)
	local v98 = p6.aqsFetchMetrics.fetchStatus ~= AssetQualityFetchStatus.assetQualityFetchNA
	local t13 = {
		validationJobId = p6.jobId,
		bundleJobId = p6.consumerConfig.telemetryBundleId,
		rootInstanceId = p6.consumerConfig.telemetryRootId,
		studioSid = RbxAnalyticsService:GetSessionId(),
		clientId = RbxAnalyticsService:GetClientId(),
		placeId = game.PlaceId,
		validationSource = p6.consumerConfig.source,
		assetType = p6.uploadEnum.assetType and p6.uploadEnum.assetType.Value or 0,
		bundleType = p6.uploadEnum.bundleType and p6.uploadEnum.bundleType.Value or 0,
		numFailures = p5.numFailures,
		passed = p5.pass,
		durationMs = n1,
		uploadCategory = p6.uploadCategory,
		aqFetchStatus = p6.aqsFetchMetrics.fetchStatus,
		aqFetchAttemptCount = v98 and p6.aqsFetchMetrics.fetchAttemptCount or 0,
		aqFetchTimeMs = v98 and p6.aqsFetchMetrics.fetchTimeMs or 0,
		aqFetchFailureReason = v98 and p6.aqsFetchMetrics.fetchFailureReason or "",
		aqJobId = if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else p6.aqsFetchMetrics.aqJobId or ""
	}

	TelemetryService:LogEvent(t1, {
		customFields = t13
	})

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
			local _print = print
			local format = string.format
			local uploadEnum = p6.uploadEnum

			_print(format("==== %s Validation end ==== pass=%s numFailures=%d numWarnings=%d durationMs=%d", if not uploadEnum.assetType then not uploadEnum.bundleType and "?" or uploadEnum.bundleType.Name else uploadEnum.assetType.Name, tostring(p5.pass), p5.numFailures, p5.numWarnings, n1))

			for v103, v104 in p5.failureMap do
				for _, v106 in v104 do
					print(string.format("  FAIL %s: %s @ %s", v103, v106.failureStringKey, v106.instancePath == "" and "<root>" or v106.instancePath))
				end
			end
		end

		print(p5)
	end
end
local function updateResultData_deprecated(p7, t14: {[any]: any}, p8, s3: string, b2: boolean) -- line: 346
	-- upvalues: ValidationEnums (copy), ErrorSourceStrings (copy)
	local validationEnum = p8.validationEnum

	if b2 or not t14[validationEnum].isShadow then
		p7.states[validationEnum] = p8.status

		if #p8.errorTranslationContexts > 0 then
			table.move(p8.errorTranslationContexts, 1, #p8.errorTranslationContexts, #p7.errorTranslationContexts + 1, p7.errorTranslationContexts)
		end

		if p8.status ~= ValidationEnums.Status.PASS then
			p7.pass = false
			p7.numFailures = p7.numFailures + 1

			if p8.status == ValidationEnums.Status.ERROR and not p7.ranIntoInternalError then
				p7.ranIntoInternalError = true
				table.insert(p7.errorTranslationContexts, {
					key = ErrorSourceStrings.Keys.InternalError,
					params = {
						ValidationJobId = s3
					}
				})
			end
		end
	end

	for _, v114 in t14[validationEnum].postreqs do
		t14[v114].prereqs[validationEnum] = nil
	end

	t14[validationEnum] = nil
end
local function updateResultData(p9, t15: {[any]: any}, p10, _: string, b3: boolean) -- line: 389
	-- upvalues: ValidationEnums (copy)
	local validationEnum = p10.validationEnum

	if b3 or not t15[validationEnum].isShadow then
		p9.states[validationEnum] = p10.status

		if p10.status ~= ValidationEnums.Status.PASS then
			p9.pass = false
			p9.numFailures = p9.numFailures + math.max(1, #p10.failures)
		end

		if #p10.failures > 0 then
			p9.failureMap[validationEnum] = p10.failures
		end

		if #p10.warnings > 0 then
			p9.warningMap[validationEnum] = p10.warnings
			p9.numWarnings = p9.numWarnings + #p10.warnings
		end

		if p10.status == ValidationEnums.Status.ERROR then
			p9.ranIntoInternalError = true
		end
	end

	for _, v122 in t15[validationEnum].postreqs do
		t15[v122].prereqs[validationEnum] = nil
	end

	t15[validationEnum] = nil
end
local function createConsumerConfigWithDefaults(p11) -- line: 427
	-- upvalues: getFFlagUGCValidateMigrateSchemaProperties (copy), t5 (copy)
	local v124 = table.clone(p11)

	if v124.enforceR15FolderStructure == nil then
		v124.enforceR15FolderStructure = true
	end

	if v124.enforceShadowValidations == nil then
		v124.enforceShadowValidations = false
	end

	v124.telemetryBundleId = v124.telemetryBundleId or ""
	v124.telemetryRootId = v124.telemetryRootId or ""
	v124.preloadedEditableMeshes = v124.preloadedEditableMeshes or {}
	v124.preloadedEditableImages = v124.preloadedEditableImages or {}
	v124.preloadedHsrAssets = v124.preloadedHsrAssets or {}
	v124.skipModules = v124.skipModules or {}

	if getFFlagUGCValidateMigrateSchemaProperties() then
		v124.consumerEnv = t5[v124.source]
		assert(v124.consumerEnv ~= nil, `unknown consumer source: { tostring(v124.source) }`)
		v124.backendConfigs = v124.backendConfigs or {}
		v124.iecConfigs = v124.iecConfigs or {}
	end

	v124.aqFetchStage = v124.aqFetchStage or "scene"
	v124.aqFetchData = v124.aqFetchData or ""
	assert(v124.aqFetchStage == "scene" == (v124.aqFetchData == ""), `aqFetchData must be non-empty iff aqFetchStage is "gltf" or "jobId" (got stage="{ v124.aqFetchStage }")`)

	return v124
end
local function runValidationOnRootInstance(p12) -- line: 465
	-- upvalues: getFFlagDebugUGCValidationPrintNewStructureResults (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), getUploadCategory (copy), initRunVariables (copy), AssetQualityFetchStatus (copy), ValidationTestWrapper (copy), ValidationEnums (copy), updateResultData (copy), updateResultData_deprecated (copy), populateRelevantSourceStrings (copy), reportFullResult (copy), FetchAllDesiredData (copy), t3 (copy), RunService (copy), fetchQualityResults (copy), getNextLayer (copy), t4 (copy)
	local elapsed = os.clock()
	local rootInstance = p12.rootInstance
	local assetType = p12.uploadEnum.assetType
	local bundleType = p12.uploadEnum.bundleType
	local consumerConfig = p12.consumerConfig

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		local _print = print
		local format = string.format
		local uploadEnum = p12.uploadEnum

		_print(format("==== %s Validation begin ==== jobId=%s source=%s", if not uploadEnum.assetType then not uploadEnum.bundleType and "?" or uploadEnum.bundleType.Name else uploadEnum.assetType.Name, p12.jobId, p12.consumerConfig.source))
	end

	local t16 = {
		pass = true,
		numFailures = 0,
		numWarnings = 0,
		ranIntoInternalError = false,
		aqJobId = "",
		validationJobId = p12.jobId,
		states = {},
		failureMap = {},
		warningMap = {},
		relevantSourceStrings = {}
	}

	if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		t16.errorTranslationContexts = {}
	end

	local v135 = getUploadCategory(rootInstance, assetType, bundleType)
	local v136, v137, v138 = initRunVariables(v135, consumerConfig)

	p12.uploadCategory = v135
	p12.aqsFetchMetrics = {
		fetchStatus = AssetQualityFetchStatus.assetQualityFetchNA,
		aqJobId = if not getEngineFeatureEngineUGCValidationExpandReturnSchema() or consumerConfig.aqFetchStage ~= "jobId" then nil else consumerConfig.aqFetchData
	}

	local v139 = ValidationTestWrapper(ValidationEnums.ValidationModule.ExpectedRootSchema, p12, t16.states)

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		updateResultData(t16, v137, v139, p12.jobId, consumerConfig.enforceShadowValidations)
	else
		updateResultData_deprecated(t16, v137, v139, p12.jobId, consumerConfig.enforceShadowValidations)
	end

	if t16.states[ValidationEnums.ValidationModule.ExpectedRootSchema] ~= ValidationEnums.Status.PASS then
		if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
			populateRelevantSourceStrings(t16)
			t16.aqJobId = p12.aqsFetchMetrics.aqJobId or ""
		end

		reportFullResult(t16, p12, -1)

		return t16
	end

	FetchAllDesiredData.storeDesiredData(p12, v138)

	if #v136 > 0 then
		p12.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchInProgress

		if t3[consumerConfig.source] then
			RunService:Run()
			fetchQualityResults(p12, v136)
			RunService:Pause()
		else
			task.spawn(fetchQualityResults, p12, v136)
		end
	end

	while next(v137) ~= nil do
		local v140 = p12.aqsFetchMetrics.fetchStatus == AssetQualityFetchStatus.assetQualityFetchInProgress
		local v141 = getNextLayer(v137, not v140)

		if #v141 == 0 and not v140 then
			error("Impossible to complete all layers")
		end

		for _, v143 in v141 do
			local v144 = ValidationTestWrapper(v143, p12, t16.states)

			if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
				updateResultData(t16, v137, v144, p12.jobId, consumerConfig.enforceShadowValidations)
			else
				updateResultData_deprecated(t16, v137, v144, p12.jobId, consumerConfig.enforceShadowValidations)
			end

			if t4[consumerConfig.source] then
				task.wait()
			end
		end

		if v140 and not t3[consumerConfig.source] then
			task.wait()
		end
	end

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		populateRelevantSourceStrings(t16)
		t16.aqJobId = p12.aqsFetchMetrics.aqJobId or ""
	end

	reportFullResult(t16, p12, 1000 * (os.clock() - elapsed))

	return t16
end
local function getRootInstance(t17: {[any]: any}) -- line: 600
	-- upvalues: Constants (copy)
	if #t17 == 0 then
		return nil
	end

	for _, v147 in t17 do
		if v147.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return v147
		end
	end

	return t17[1]
end

function t2.ValidateAsset(t18: {[any]: any}, p13, p14) -- line: 617
	-- upvalues: HttpService (copy), Constants (copy), createConsumerConfigWithDefaults (copy), runValidationOnRootInstance (copy)
	local t19 = {
		jobId = HttpService:GenerateGUID(),
		entrypointInput = t18
	}
	local v152, g155

	if #t18 == 0 then
		v152 = nil
	else
		g155 = nil
		v152 = nil

		for _, v154 in t18 do
			if v154.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
				v152 = v154
				g155 = true
			end

			if g155 then
				break
			end
		end

		if not g155 then
			v152 = t18[1]
		end
	end

	g155 = false
	t19.rootInstance = v152
	t19.uploadEnum = {
		assetType = p13
	}
	t19.consumerConfig = createConsumerConfigWithDefaults(p14)
	t19.hsrAssets = {}

	return (runValidationOnRootInstance(t19))
end
function t2.ValidateFinalizedBundle(p15, p16, p17) -- line: 636
	-- upvalues: getFFlagDebugAllowHRDUploadOnBundleBackend (copy), R15plusUtils (copy), getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), HttpService (copy), createConsumerConfigWithDefaults (copy), runValidationOnRootInstance (copy)
	local g166 = nil
	local v163 = nil
	local g173 = nil
	local v170 = nil

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(p17.source == "Publish" or p17.source == "Backend")
	end

	local Model

	if getFFlagUGCValidationAnimationPackSupport() and p16 == Enum.BundleType.Animations then
		Model = Instance.new("Model")

		for _, v161 in p15 do
			local allSelectedInstances = v161.allSelectedInstances

			if #allSelectedInstances == 0 then
				v163 = nil
			else
				for _, v165 in allSelectedInstances do
					if v165.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						v163 = v165
						g166 = true
					end

					if g166 then
						break
					end
				end

				if not g166 then
					v163 = allSelectedInstances[1]
				end
			end

			g166 = false

			if v163 ~= nil then
				v163:Clone().Parent = Model
			end
		end
	else
		Model = Instance.new("Folder")

		for _, v168 in p15 do
			local allSelectedInstances = v168.allSelectedInstances

			if #allSelectedInstances == 0 then
				v170 = nil
			else
				for _, v172 in allSelectedInstances do
					if v172.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						v170 = v172
						g173 = true
					end

					if g173 then
						break
					end
				end

				if not g173 then
					v170 = allSelectedInstances[1]
				end
			end

			g173 = false

			if v170 ~= nil then
				if v170:IsA("Folder") or v170:IsA("Model") then
					for _, child in v170:GetChildren() do
						child:Clone().Parent = Model
					end
				else
					v170:Clone().Parent = Model
				end
			end
		end
	end

	local t20 = {
		jobId = HttpService:GenerateGUID(),
		entrypointInput = p15,
		rootInstance = Model,
		uploadEnum = {
			bundleType = p16
		},
		consumerConfig = createConsumerConfigWithDefaults(p17),
		hsrAssets = {}
	}
	local v177 = runValidationOnRootInstance(t20)

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(false)
	end

	return v177
end

return t2
