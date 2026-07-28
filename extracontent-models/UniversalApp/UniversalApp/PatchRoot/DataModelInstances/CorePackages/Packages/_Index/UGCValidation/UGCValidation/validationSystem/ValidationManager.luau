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
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(ParentParent.flags.getFFlagDebugAllowHRDUploadOnBundleBackend)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagDebugUGCDisableAssetQualityChecks = require(ParentParent.flags.getFFlagDebugUGCDisableAssetQualityChecks)
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
local getFIntUGCValidationFetchQualityMaxRetry = require(ParentParent.flags.getFIntUGCValidationFetchQualityMaxRetry)
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

local function initRunVariables(s1: string, p1) -- line: 77
	-- upvalues: getFFlagUGCValidateMigrateSchemaProperties (copy), ValidationModuleLoader (copy), getFFlagDebugUGCDisableAssetQualityChecks (copy)
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local v43 = if not getFFlagUGCValidateMigrateSchemaProperties() then {} else p1.skipModules

	for v44, v45 in ValidationModuleLoader.allModules do
		if not v43[v44] and (not getFFlagDebugUGCDisableAssetQualityChecks() or not p1.skipAssetQualityChecks or not v45.isAssetQualityModule) then
			local categories = v45.categories

			if table.find(categories, s1) and (v45.fflag() or v45.shadowFlag()) then
				local v47 = v45.shadowFlag() and not v45.fflag()

				for _, v49 in v45.requiredData do
					t8[v49] = true
				end

				for _, v51 in v45.conditionalData do
					t8[v51] = true
				end

				local isAssetQualityModule = v45.isAssetQualityModule

				if isAssetQualityModule then
					table.insert(t6, v44)
				end

				local t9 = {}

				for _, v55 in v45.prereqTests do
					t9[v55] = true
				end

				t7[v44] = {
					name = v44,
					prereqs = t9,
					postreqs = {},
					isQuality = isAssetQualityModule,
					isShadow = v47
				}
			end
		end
	end

	for v56, v57 in t7 do
		for v58, _ in v57.prereqs do
			if t7[v58] == nil then
				error(string.format("%s is needed for %s to run, but is not an included test", v58, v56))
			end

			table.insert(t7[v58].postreqs, v56)
		end
	end

	return t6, t7, t8
end
local function fetchQualityResults(p2, t10: {[any]: any}) -- line: 153
	-- upvalues: AssetQualityService (copy), AssetQualityFetchStatus (copy), RecreateSceneFromEditables (copy), getFIntUGCValidationFetchQualityMaxRetry (copy), HttpService (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy), FetchAllDesiredData (copy)
	if not AssetQualityService then
		p2.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchFailure
		p2.aqsFetchMetrics.fetchFailureReason = "Not enabled"

		return
	end

	local result = nil
	local aqFetchData = nil
	local u64 = nil
	local v65

	if p2.consumerConfig.aqFetchStage ~= "scene" then
		if p2.consumerConfig.aqFetchStage == "gltf" then
			aqFetchData = p2.consumerConfig.aqFetchData
		end

		v65 = true
	else
		u64 = RecreateSceneFromEditables.createModelForGltfExport(p2)
		v65, result = pcall(function() -- line: 168
			-- upvalues: aqFetchData (ref), AssetQualityService (copy), u64 (ref)
			aqFetchData = AssetQualityService:GenerateAssetQualityGltfFromInstanceAsync(u64)
		end)
	end

	if v65 then
		for i = 1, 1 + getFIntUGCValidationFetchQualityMaxRetry() do
			v65, result = pcall(function() -- line: 176
				-- upvalues: p2 (copy), i (copy), AssetQualityService (copy), t10 (copy), aqFetchData (ref), HttpService (copy)
				p2.aqsFetchMetrics.fetchAttemptCount = i

				local elapsed = os.clock()
				local v168 = if p2.consumerConfig.aqFetchStage ~= "jobId" then AssetQualityService:FetchAssetQualitySummaryFromGltfAsync(aqFetchData, t10) else AssetQualityService:FetchAssetQualitySummaryFromJobIdAsync(p2.consumerConfig.aqFetchData, t10)
				local v169 = 1000 * (os.clock() - elapsed)

				p2.aqsFetchMetrics.visualizationUrl = v168.visualizationUrl
				p2.aqsFetchMetrics.fetchTimeMs = v169
				p2.aqsFetchMetrics.aqJobId = v168.aqJobId
				p2.aqsSummaryData = HttpService:JSONDecode(v168.rawJson)
			end)

			if v65 then
				break
			end
		end
	end

	if v65 then
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

	if u64 then
		u64:Destroy()
	end
end
local function getNextLayer(t11: {[any]: any}, b1: boolean) -- line: 228
	local t12 = {}

	for v70, v71 in t11 do
		if next(v71.prereqs) == nil and (b1 or not v71.isQuality) then
			table.insert(t12, v70)
		end
	end

	return t12
end
local function populateRelevantSourceStrings(p3) -- line: 243
	-- upvalues: ErrorSourceStrings (copy)
	local function capture(s2: string) -- line: 244
		-- upvalues: ErrorSourceStrings (copy), p3 (copy)
		local parts = s2:split(".")
		local v172 = parts[#parts]
		local v173 = ErrorSourceStrings.Values[v172]

		if v173 then
			p3.relevantSourceStrings[s2] = v173
		end
	end

	for _, v75 in p3.failureMap do
		for _, v77 in v75 do
			local failureStringKey = v77.failureStringKey
			local parts = failureStringKey:split(".")
			local v80 = parts[#parts]
			local v81 = ErrorSourceStrings.Values[v80]

			if v81 then
				p3.relevantSourceStrings[failureStringKey] = v81
			end
		end
	end

	for _, v83 in p3.warningMap do
		for _, v85 in v83 do
			local failureStringKey = v85.failureStringKey
			local parts = failureStringKey:split(".")
			local v88 = parts[#parts]
			local v89 = ErrorSourceStrings.Values[v88]

			if v89 then
				p3.relevantSourceStrings[failureStringKey] = v89
			end
		end
	end
end
local function getDebugLabel(p4) -- line: 265
	local uploadEnum = p4.uploadEnum

	if uploadEnum.assetType then
		return uploadEnum.assetType.Name
	end

	if uploadEnum.bundleType then
		return uploadEnum.bundleType.Name
	end

	return "?"
end
local function reportFullResult(p5, p6, n1: number) -- line: 275
	-- upvalues: AssetQualityFetchStatus (copy), RbxAnalyticsService (copy), TelemetryService (copy), t1 (copy), getFFlagDebugUGCValidationPrintNewStructureResults (copy)
	local v95 = p6.aqsFetchMetrics.fetchStatus ~= AssetQualityFetchStatus.assetQualityFetchNA
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
		aqFetchAttemptCount = v95 and p6.aqsFetchMetrics.fetchAttemptCount or 0,
		aqFetchTimeMs = v95 and p6.aqsFetchMetrics.fetchTimeMs or 0,
		aqFetchFailureReason = v95 and p6.aqsFetchMetrics.fetchFailureReason or "",
		aqJobId = p6.aqsFetchMetrics.aqJobId or ""
	}

	TelemetryService:LogEvent(t1, {
		customFields = t13
	})

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		local _print = print
		local format = string.format
		local uploadEnum = p6.uploadEnum

		_print(format("==== %s Validation end ==== pass=%s numFailures=%d numWarnings=%d durationMs=%d", if not uploadEnum.assetType then not uploadEnum.bundleType and "?" or uploadEnum.bundleType.Name else uploadEnum.assetType.Name, tostring(p5.pass), p5.numFailures, p5.numWarnings, n1))

		for v100, v101 in p5.failureMap do
			for _, v103 in v101 do
				print(string.format("  FAIL %s: %s @ %s", v100, v103.failureStringKey, v103.instancePath == "" and "<root>" or v103.instancePath))
			end
		end

		print(p5)
	end
end
local function updateResultData(p7, t14: {[any]: any}, p8, _: string, b2: boolean) -- line: 327
	-- upvalues: ValidationEnums (copy)
	local validationEnum = p8.validationEnum

	if b2 or not t14[validationEnum].isShadow then
		p7.states[validationEnum] = p8.status

		if p8.status ~= ValidationEnums.Status.PASS then
			p7.pass = false
			p7.numFailures = p7.numFailures + math.max(1, #p8.failures)
		end

		if #p8.failures > 0 then
			p7.failureMap[validationEnum] = p8.failures
		end

		if #p8.warnings > 0 then
			p7.warningMap[validationEnum] = p8.warnings
			p7.numWarnings = p7.numWarnings + #p8.warnings
		end

		if p8.status == ValidationEnums.Status.ERROR then
			p7.ranIntoInternalError = true
		end
	end

	for _, v111 in t14[validationEnum].postreqs do
		t14[v111].prereqs[validationEnum] = nil
	end

	t14[validationEnum] = nil
end
local function createConsumerConfigWithDefaults(p9) -- line: 365
	-- upvalues: getFFlagUGCValidateMigrateSchemaProperties (copy), t5 (copy)
	local v113 = table.clone(p9)

	if v113.enforceR15FolderStructure == nil then
		v113.enforceR15FolderStructure = true
	end

	if v113.enforceShadowValidations == nil then
		v113.enforceShadowValidations = false
	end

	v113.telemetryBundleId = v113.telemetryBundleId or ""
	v113.telemetryRootId = v113.telemetryRootId or ""
	v113.preloadedEditableMeshes = v113.preloadedEditableMeshes or {}
	v113.preloadedEditableImages = v113.preloadedEditableImages or {}
	v113.preloadedHsrAssets = v113.preloadedHsrAssets or {}
	v113.skipModules = v113.skipModules or {}
	v113.skipAssetQualityChecks = v113.skipAssetQualityChecks or false

	if getFFlagUGCValidateMigrateSchemaProperties() then
		v113.consumerEnv = t5[v113.source]
		assert(v113.consumerEnv ~= nil, `unknown consumer source: { tostring(v113.source) }`)
		v113.backendConfigs = v113.backendConfigs or {}
		v113.iecConfigs = v113.iecConfigs or {}
	end

	v113.aqFetchStage = v113.aqFetchStage or "scene"
	v113.aqFetchData = v113.aqFetchData or ""
	assert(v113.aqFetchStage == "scene" == (v113.aqFetchData == ""), `aqFetchData must be non-empty iff aqFetchStage is "gltf" or "jobId" (got stage="{ v113.aqFetchStage }")`)

	return v113
end
local function runValidationOnRootInstance(p10) -- line: 404
	-- upvalues: getFFlagDebugUGCValidationPrintNewStructureResults (copy), getUploadCategory (copy), initRunVariables (copy), AssetQualityFetchStatus (copy), ValidationTestWrapper (copy), ValidationEnums (copy), updateResultData (copy), populateRelevantSourceStrings (copy), reportFullResult (copy), FetchAllDesiredData (copy), t3 (copy), RunService (copy), fetchQualityResults (copy), getNextLayer (copy), t4 (copy)
	local elapsed = os.clock()
	local rootInstance = p10.rootInstance
	local assetType = p10.uploadEnum.assetType
	local bundleType = p10.uploadEnum.bundleType
	local consumerConfig = p10.consumerConfig

	if getFFlagDebugUGCValidationPrintNewStructureResults() then
		local _print = print
		local format = string.format
		local uploadEnum = p10.uploadEnum

		_print(format("==== %s Validation begin ==== jobId=%s source=%s", if not uploadEnum.assetType then not uploadEnum.bundleType and "?" or uploadEnum.bundleType.Name else uploadEnum.assetType.Name, p10.jobId, p10.consumerConfig.source))
	end

	local t15 = {
		pass = true,
		numFailures = 0,
		numWarnings = 0,
		ranIntoInternalError = false,
		aqJobId = "",
		validationJobId = p10.jobId,
		states = {},
		failureMap = {},
		warningMap = {},
		relevantSourceStrings = {}
	}
	local v124 = getUploadCategory(rootInstance, assetType, bundleType)
	local v125, v126, v127 = initRunVariables(v124, consumerConfig)

	p10.uploadCategory = v124
	p10.aqsFetchMetrics = {
		fetchStatus = AssetQualityFetchStatus.assetQualityFetchNA,
		aqJobId = if consumerConfig.aqFetchStage ~= "jobId" then nil else consumerConfig.aqFetchData
	}

	local v128 = ValidationTestWrapper(ValidationEnums.ValidationModule.ExpectedRootSchema, p10, t15.states)

	updateResultData(t15, v126, v128, p10.jobId, consumerConfig.enforceShadowValidations)

	if t15.states[ValidationEnums.ValidationModule.ExpectedRootSchema] ~= ValidationEnums.Status.PASS then
		populateRelevantSourceStrings(t15)
		t15.aqJobId = p10.aqsFetchMetrics.aqJobId or ""
		reportFullResult(t15, p10, -1)

		return t15
	end

	FetchAllDesiredData.storeDesiredData(p10, v127)

	if #v125 > 0 then
		p10.aqsFetchMetrics.fetchStatus = AssetQualityFetchStatus.assetQualityFetchInProgress

		if t3[consumerConfig.source] then
			RunService:Run()
			fetchQualityResults(p10, v125)
			RunService:Pause()
		else
			task.spawn(fetchQualityResults, p10, v125)
		end
	end

	while next(v126) ~= nil do
		local v129 = p10.aqsFetchMetrics.fetchStatus == AssetQualityFetchStatus.assetQualityFetchInProgress
		local v130 = getNextLayer(v126, not v129)

		if #v130 == 0 and not v129 then
			error("Impossible to complete all layers")
		end

		for _, v132 in v130 do
			local v133 = ValidationTestWrapper(v132, p10, t15.states)

			updateResultData(t15, v126, v133, p10.jobId, consumerConfig.enforceShadowValidations)

			if t4[consumerConfig.source] then
				task.wait()
			end
		end

		if v129 and not t3[consumerConfig.source] then
			task.wait()
		end
	end

	populateRelevantSourceStrings(t15)
	t15.aqJobId = p10.aqsFetchMetrics.aqJobId or ""
	reportFullResult(t15, p10, 1000 * (os.clock() - elapsed))

	return t15
end
local function getRootInstance(t16: {[any]: any}) -- line: 509
	-- upvalues: Constants (copy)
	if #t16 == 0 then
		return nil
	end

	for _, v136 in t16 do
		if v136.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return v136
		end
	end

	return t16[1]
end

function t2.ValidateAsset(t17: {[any]: any}, p11, p12) -- line: 526
	-- upvalues: HttpService (copy), Constants (copy), createConsumerConfigWithDefaults (copy), runValidationOnRootInstance (copy)
	local t18 = {
		jobId = HttpService:GenerateGUID(),
		entrypointInput = t17
	}
	local v141, g144

	if #t17 == 0 then
		v141 = nil
	else
		g144 = nil
		v141 = nil

		for _, v143 in t17 do
			if v143.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
				v141 = v143
				g144 = true
			end

			if g144 then
				break
			end
		end

		if not g144 then
			v141 = t17[1]
		end
	end

	g144 = false
	t18.rootInstance = v141
	t18.uploadEnum = {
		assetType = p11
	}
	t18.consumerConfig = createConsumerConfigWithDefaults(p12)
	t18.hsrAssets = {}

	return (runValidationOnRootInstance(t18))
end
function t2.ValidateFinalizedBundle(p13, p14, p15) -- line: 545
	-- upvalues: getFFlagDebugAllowHRDUploadOnBundleBackend (copy), R15plusUtils (copy), getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), HttpService (copy), createConsumerConfigWithDefaults (copy), runValidationOnRootInstance (copy)
	local g155 = nil
	local v152 = nil
	local g162 = nil
	local v159 = nil

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(p15.source == "Publish" or p15.source == "Backend")
	end

	local Model

	if getFFlagUGCValidationAnimationPackSupport() and p14 == Enum.BundleType.Animations then
		Model = Instance.new("Model")

		for _, v150 in p13 do
			local allSelectedInstances = v150.allSelectedInstances

			if #allSelectedInstances == 0 then
				v152 = nil
			else
				for _, v154 in allSelectedInstances do
					if v154.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						v152 = v154
						g155 = true
					end

					if g155 then
						break
					end
				end

				if not g155 then
					v152 = allSelectedInstances[1]
				end
			end

			g155 = false

			if v152 ~= nil then
				v152:Clone().Parent = Model
			end
		end
	else
		Model = Instance.new("Folder")

		for _, v157 in p13 do
			local allSelectedInstances = v157.allSelectedInstances

			if #allSelectedInstances == 0 then
				v159 = nil
			else
				for _, v161 in allSelectedInstances do
					if v161.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
						v159 = v161
						g162 = true
					end

					if g162 then
						break
					end
				end

				if not g162 then
					v159 = allSelectedInstances[1]
				end
			end

			g162 = false

			if v159 ~= nil then
				if v159:IsA("Folder") or v159:IsA("Model") then
					for _, child in v159:GetChildren() do
						child:Clone().Parent = Model
					end
				else
					v159:Clone().Parent = Model
				end
			end
		end
	end

	local t19 = {
		jobId = HttpService:GenerateGUID(),
		entrypointInput = p13,
		rootInstance = Model,
		uploadEnum = {
			bundleType = p14
		},
		consumerConfig = createConsumerConfigWithDefaults(p15),
		hsrAssets = {}
	}
	local v166 = runValidationOnRootInstance(t19)

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(false)
	end

	return v166
end

return t2
