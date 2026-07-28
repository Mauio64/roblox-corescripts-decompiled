local _script = script
local getEngineFeatureUGCValidationWithContextEntrypoint = require(_script.flags.getEngineFeatureUGCValidationWithContextEntrypoint)
local Analytics = require(_script.Analytics)
local Constants = require(_script.Constants)
local BundlesMetadata = require(_script.util.BundlesMetadata)
local canUploadBundlesAsync = require(_script.util.canUploadBundlesAsync)
local createUGCBodyPartFolders = require(_script.util.createUGCBodyPartFolders)
local isLayeredClothing = require(_script.util.isLayeredClothing)
local RigidOrLayeredAllowed = require(_script.util.RigidOrLayeredAllowed)

require(_script.util.Types)

local createEditableInstancesForContext = require(_script.util.createEditableInstancesForContext)
local destroyEditableInstances = require(_script.util.destroyEditableInstances)
local ValidationHints = require(_script.util.ValidationHints)
local validateInternal = require(_script.validation.validateInternal)
local validateLayeredClothingAccessoryMeshPartAssetFormat = require(_script.validation.validateLayeredClothingAccessoryMeshPartAssetFormat)
local validateLegacyAccessoryMeshPartAssetFormat = require(_script.validation.validateLegacyAccessoryMeshPartAssetFormat)
local validateFullBody = require(_script.validation.validateFullBody)
local validateShoes = require(_script.validation.validateShoes)
local validateBundleReadyForUpload = require(_script.validation.validateBundleReadyForUpload)
local validateShoesBundleReadyForUpload = require(_script.validation.validateShoesBundleReadyForUpload)
local validateAnimationBundleReadyForUpload = require(_script.validation.validateAnimationBundleReadyForUpload)
local validateDynamicHeadMeshPartFormat = require(_script.validation.validateDynamicHeadMeshPartFormat)
local ValidationManager = require(_script.validationSystem.ValidationManager)
local getFFlagUGCValidationEnableFolderStructure = require(_script.flags.getFFlagUGCValidationEnableFolderStructure)
local getFFlagUGCValidationCombineEntrypointResults = require(_script.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagDebugUGCDisableAssetQualityChecks = require(_script.flags.getFFlagDebugUGCDisableAssetQualityChecks)
local getFFlagUGCValidateBackendInExperienceViaCanPublish = require(_script.flags.getFFlagUGCValidateBackendInExperienceViaCanPublish)
local LegacyValidationAdapter = require(_script.util.LegacyValidationAdapter)
local SplitHumanoidRigDescriptionForUpload = require(_script.util.SplitHumanoidRigDescriptionForUpload)
local t1 = {
	ValidateAsset = ValidationManager.ValidateAsset,
	ValidateFinalizedBundle = ValidationManager.ValidateFinalizedBundle,
	combineResultsIntoLegacy = LegacyValidationAdapter.combineResultsIntoLegacy,
	mergeLegacyIntoModern = LegacyValidationAdapter.mergeLegacyIntoModern,
	isFolderStructureEnabled = getFFlagUGCValidationEnableFolderStructure,
	isEntrypointMergingEnabled = getFFlagUGCValidationCombineEntrypointResults,
	isBackendInExperienceViaCanPublishEnabled = getFFlagUGCValidateBackendInExperienceViaCanPublish,
	shouldSkipAssetQualityChecks = getFFlagDebugUGCDisableAssetQualityChecks,
	SplitHrdInUpload = SplitHumanoidRigDescriptionForUpload.fixUploadInstance
}

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function t1.validateWithContext(p1) -- line: 54
		-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateInternal (copy), destroyEditableInstances (copy)
		assert(p1.instances ~= nil, "instances required in validationContext for validateWithContext")
		assert(p1.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateWithContext")

		local instances = p1.instances
		local isServer = p1.isServer
		local assetTypeEnum = p1.assetTypeEnum
		local allowEditableInstances = p1.allowEditableInstances
		local timestamp = tick()

		Analytics.setMetadata({
			entrypoint = "validate",
			assetType = assetTypeEnum.Name,
			isServer = isServer
		})

		local v36, v37 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)

		if not v36 then
			if not isServer then
				return v36, v37
			end

			error(v37[1])
		end

		p1.editableMeshes = v37.editableMeshes
		p1.editableImages = v37.editableImages
		p1.lastTickSeconds = tick()

		if p1.requireAllFolders == nil then
			p1.requireAllFolders = true
		end

		local v38, v39 = validateInternal(p1)

		destroyEditableInstances(p1.editableMeshes, p1.editableImages)

		if v38 then
			Analytics.recordScriptTime(script.Name, timestamp, p1)
			Analytics.reportScriptTimes(p1)
		end

		Analytics.reportCounter(v38, assetTypeEnum ~= Enum.AssetType.DynamicHead and "BodyPart" or "Head", p1)

		return v38, v39
	end
end

function t1.validate(t2: {[any]: any}, p2, b1: boolean?, b2: boolean?, p3, s1: string?, n1: number?, b3: boolean?, p4, b4: boolean?, b5: boolean?, b6: boolean?) -- line: 114
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateInternal (copy), destroyEditableInstances (copy)
	local timestamp = tick()

	Analytics.setMetadata({
		entrypoint = "validate",
		assetType = p2.Name,
		isServer = b1
	})

	local v53, v54 = createEditableInstancesForContext.processAll(t2, b3)

	if not v53 then
		if not b1 then
			return v53, v54
		end

		error(v54[1])
	end

	local t3 = {
		isAsync = false,
		instances = t2,
		assetTypeEnum = p2,
		allowUnreviewedAssets = b2,
		restrictedUserIds = p3,
		isServer = b1,
		token = s1,
		universeId = n1,
		allowEditableInstances = b3,
		bypassFlags = p4,
		validateMeshPartAccessories = b5 == nil or b5,
		lastTickSeconds = tick(),
		shouldYield = b4,
		editableMeshes = v54.editableMeshes,
		editableImages = v54.editableImages,
		requireAllFolders = b6 == nil or b6
	}
	local v56, v57 = validateInternal(t3)

	destroyEditableInstances(t3.editableMeshes, t3.editableImages)

	if v56 then
		Analytics.recordScriptTime(script.Name, timestamp, t3)
		Analytics.reportScriptTimes(t3)
	end

	Analytics.reportCounter(v56, p2 ~= Enum.AssetType.DynamicHead and "BodyPart" or "Head", t3)

	return v56, v57
end
function t1.validateAsync(t4: {[any]: any}, p5, p6: ((...any) -> ...any), b7: boolean?, b8: boolean?, p7) -- line: 185
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateInternal (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateAsync",
		assetType = p5.Name,
		isServer = b7
	})

	local v64, v65 = createEditableInstancesForContext.processAll(t4)

	if not v64 then
		if b7 then
			error(v65[1])
		else
			p6(v64, v65)
		end
	end

	local t5 = {
		token = "",
		isAsync = true,
		validateMeshPartAccessories = false,
		instances = t4,
		assetTypeEnum = p5,
		allowUnreviewedAssets = b8,
		restrictedUserIds = p7,
		isServer = b7,
		editableMeshes = v65.editableMeshes,
		editableImages = v65.editableImages
	}

	coroutine.wrap(function() -- line: 221
		-- upvalues: p6 (copy), validateInternal (copy), t5 (copy), destroyEditableInstances (copy)
		p6(validateInternal(t5))
		destroyEditableInstances(t5.editableMeshes, t5.editableImages)
	end)()
end
function t1.validateMeshPartFormat(t6: {[any]: any}, p8, b9: boolean?, b10: boolean?, p9) -- line: 231
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateDynamicHeadMeshPartFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartFormat",
		assetType = p8.Name,
		isServer = b9
	})
	assert(p8 == Enum.AssetType.DynamicHead)

	local v72, v73 = createEditableInstancesForContext.processAll(t6)

	if not v72 then
		if not b9 then
			return v72, v73
		end

		error(v73[1])
	end

	local t7 = {
		validateMeshPartAccessories = false,
		instances = t6,
		assetTypeEnum = p8,
		allowUnreviewedAssets = b10,
		restrictedUserIds = p9,
		isServer = b9,
		editableMeshes = v73.editableMeshes,
		editableImages = v73.editableImages
	}
	local v75, v76 = validateDynamicHeadMeshPartFormat(t7)

	destroyEditableInstances(t7.editableMeshes, t7.editableImages)

	return v75, v76
end
function t1.validateAsyncMeshPartFormat(t8: {[any]: any}, p10, p11: ((...any) -> ...any), b11: boolean?, b12: boolean?, p12) -- line: 278
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateDynamicHeadMeshPartFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateAsyncMeshPartFormat",
		assetType = p10.Name,
		isServer = b11
	})
	assert(p10 == Enum.AssetType.DynamicHead)

	local v83, v84 = createEditableInstancesForContext.processAll(t8)

	if not v83 then
		if b11 then
			error(v84[1])
		else
			p11(v83, v84)
		end
	end

	local t9 = {
		validateMeshPartAccessories = false,
		instances = t8,
		assetTypeEnum = p10,
		allowUnreviewedAssets = b12,
		restrictedUserIds = p12,
		isServer = b11,
		editableMeshes = v84.editableMeshes,
		editableImages = v84.editableImages
	}

	coroutine.wrap(function() -- line: 316
		-- upvalues: p11 (copy), validateDynamicHeadMeshPartFormat (copy), t9 (copy), destroyEditableInstances (copy)
		p11(validateDynamicHeadMeshPartFormat(t9))
		destroyEditableInstances(t9.editableMeshes, t9.editableImages)
	end)()
end

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function t1.validateMeshPartAssetFormatWithContext(p13) -- line: 326
		-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), isLayeredClothing (copy), validateLayeredClothingAccessoryMeshPartAssetFormat (copy), validateLegacyAccessoryMeshPartAssetFormat (copy), destroyEditableInstances (copy)
		assert(p13.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateMeshPartAssetFormatWithContext")
		assert(p13.instances ~= nil, "instances required in validationContext for validateMeshPartAssetFormatWithContext")

		local instances = p13.instances
		local assetTypeEnum = p13.assetTypeEnum
		local isServer = p13.isServer
		local specialMeshAccessory = p13.specialMeshAccessory

		Analytics.setMetadata({
			entrypoint = "validateMeshPartAssetFormat2",
			assetType = assetTypeEnum.Name,
			isServer = isServer
		})

		local v91, v92 = createEditableInstancesForContext.processAll(instances)

		if not v91 then
			if not isServer then
				return v91, v92
			end

			error(v92[1])
		end

		p13.editableMeshes = v92.editableMeshes
		p13.editableImages = v92.editableImages
		p13.validateMeshPartAccessories = false

		local v93, v94

		if isLayeredClothing(instances[1]) then
			v93, v94 = validateLayeredClothingAccessoryMeshPartAssetFormat(specialMeshAccessory, p13)
		else
			v93, v94 = validateLegacyAccessoryMeshPartAssetFormat(specialMeshAccessory, p13)
		end

		destroyEditableInstances(p13.editableMeshes, p13.editableImages)

		return v93, v94
	end
end

function t1.validateMeshPartAssetFormat2(t10: {[any]: any}, p14, p15, b13: boolean?, b14: boolean?, _) -- line: 380
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), isLayeredClothing (copy), validateLayeredClothingAccessoryMeshPartAssetFormat (copy), validateLegacyAccessoryMeshPartAssetFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartAssetFormat2",
		assetType = p15.Name,
		isServer = b13
	})

	local v101, v102 = createEditableInstancesForContext.processAll(t10)

	if not v101 then
		if not b13 then
			return v101, v102
		end

		error(v102[1])
	end

	local t11 = {
		validateMeshPartAccessories = false,
		instances = t10,
		assetTypeEnum = p15,
		allowUnreviewedAssets = b14,
		isServer = b13,
		editableMeshes = v102.editableMeshes,
		editableImages = v102.editableImages
	}
	local v104, v105

	if isLayeredClothing(t10[1]) then
		v104, v105 = validateLayeredClothingAccessoryMeshPartAssetFormat(p14, t11)
	else
		v104, v105 = validateLegacyAccessoryMeshPartAssetFormat(p14, t11)
	end

	destroyEditableInstances(t11.editableMeshes, t11.editableImages)

	return v104, v105
end

t1.validateBundleReadyForUpload = validateBundleReadyForUpload
t1.validateShoesBundleReadyForUpload = validateShoesBundleReadyForUpload
t1.validateAnimationBundleReadyForUpload = validateAnimationBundleReadyForUpload
t1.util = {
	BundlesMetadata = BundlesMetadata,
	createUGCBodyPartFolders = createUGCBodyPartFolders,
	canUploadBundlesAsync = canUploadBundlesAsync
}
t1.util.isLayeredClothingAllowed = RigidOrLayeredAllowed.isLayeredClothingAllowed
t1.util.isRigidAccessoryAllowed = RigidOrLayeredAllowed.isRigidAccessoryAllowed

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function t1.validateFullBodyWithContext(p17) -- line: 485
		-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateFullBody (copy), destroyEditableInstances (copy)
		assert(p17.fullBodyData ~= nil, "fullBodyData required in validationContext for validateFullBodyWithContext")

		local isServer = p17.isServer
		local fullBodyData = p17.fullBodyData
		local allowEditableInstances = p17.allowEditableInstances

		Analytics.setMetadata({
			entrypoint = "validateFullBody",
			assetType = "",
			isServer = isServer
		})

		local timestamp = tick()
		local t12 = {}

		for _, v113 in fullBodyData do
			for _, v115 in v113.allSelectedInstances do
				table.insert(t12, v115)
			end
		end

		local v116, v117 = createEditableInstancesForContext.processAll(t12, allowEditableInstances)

		if not v116 then
			if not isServer then
				return v116, v117
			end

			error(v117[1])
		end

		p17.editableMeshes = v117.editableMeshes
		p17.editableImages = v117.editableImages
		p17.lastTickSeconds = tick()

		if p17.requireAllFolders == nil then
			p17.requireAllFolders = true
		end

		local v118, v119 = validateFullBody(p17)

		destroyEditableInstances(p17.editableMeshes, p17.editableImages)

		if v118 then
			Analytics.recordScriptTime(script.Name, timestamp, p17)
			Analytics.reportScriptTimes(p17)
		end

		Analytics.reportCounter(v118, "FullBody", p17)

		return v118, v119
	end
end

function t1.validateFullBody(p18, b15: boolean?, b16: boolean?, p19, b17: boolean?, b18: boolean?) -- line: 548
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateFullBody (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateFullBody",
		assetType = "",
		isServer = b15
	})

	local timestamp = tick()
	local t13 = {}

	for _, v129 in p18 do
		for _, v131 in v129.allSelectedInstances do
			table.insert(t13, v131)
		end
	end

	local v132, v133 = createEditableInstancesForContext.processAll(t13, b16)

	if not v132 then
		if not b15 then
			return v132, v133
		end

		error(v133[1])
	end

	local t14 = {
		validateMeshPartAccessories = false,
		fullBodyData = p18,
		isServer = b15,
		allowEditableInstances = b16,
		bypassFlags = p19,
		lastTickSeconds = tick(),
		shouldYield = b17,
		editableMeshes = v133.editableMeshes,
		editableImages = v133.editableImages,
		requireAllFolders = b18 == nil or b18
	}
	local v135, v136 = validateFullBody(t14)

	destroyEditableInstances(t14.editableMeshes, t14.editableImages)

	if v135 then
		Analytics.recordScriptTime(script.Name, timestamp, t14)
		Analytics.reportScriptTimes(t14)
	end

	Analytics.reportCounter(v135, "FullBody", t14)

	return v135, v136
end
function t1.validateShoesWithContext(p20) -- line: 610
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateShoes (copy), destroyEditableInstances (copy)
	assert(p20.fullBodyData ~= nil, "fullBodyData required in validationContext for validateShoes")

	local isServer = p20.isServer
	local fullBodyData = p20.fullBodyData
	local allowEditableInstances = p20.allowEditableInstances

	Analytics.setMetadata({
		entrypoint = "validateShoes",
		assetType = "",
		isServer = isServer
	})

	local timestamp = tick()
	local t15 = {}

	for _, v144 in fullBodyData do
		for _, v146 in v144.allSelectedInstances do
			table.insert(t15, v146)
		end
	end

	local v147, v148 = createEditableInstancesForContext.processAll(t15, allowEditableInstances)

	if not v147 then
		if not isServer then
			return v147, v148
		end

		error(v148[1])
	end

	p20.editableMeshes = v148.editableMeshes
	p20.editableImages = v148.editableImages
	p20.lastTickSeconds = tick()

	local v149, v150 = validateShoes(p20)

	destroyEditableInstances(p20.editableMeshes, p20.editableImages)

	if v149 then
		Analytics.recordScriptTime(script.Name, timestamp, p20)
		Analytics.reportScriptTimes(p20)
	end

	Analytics.reportCounter(v149, "Shoes", p20)

	return v149, v150
end
function t1.preprocessDataAsync(p21, b19: boolean?, b20: boolean?, p22, b21: boolean?) -- line: 662
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), ValidationHints (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "preprocessDataAsync",
		assetType = "",
		isServer = b19
	})

	local timestamp = tick()
	local t16 = {}

	for _, v159 in p21 do
		table.insert(t16, v159)
	end

	local v160, v161 = createEditableInstancesForContext.processAll(t16, b20)

	if not v160 then
		if not b19 then
			return {
				ok = false,
				errors = v161
			}
		end

		error(v161[1])
	end

	local t17 = {
		validateMeshPartAccessories = false,
		isServer = b19,
		allowEditableInstances = b20,
		bypassFlags = p22,
		lastTickSeconds = tick(),
		shouldYield = b21,
		editableMeshes = v161.editableMeshes,
		editableImages = v161.editableImages
	}
	local v163 = ValidationHints.preprocessDataAsync(p21, t17)

	destroyEditableInstances(t17.editableMeshes, t17.editableImages)

	if v163.ok then
		Analytics.recordScriptTime("preprocessDataAsync", timestamp, t17)
		Analytics.reportScriptTimes(t17)
	end

	return v163
end
function t1.isPreprocessDataCached(p23, p24, b22: boolean?) -- line: 721
	-- upvalues: Analytics (copy), ValidationHints (copy)
	Analytics.setMetadata({
		entrypoint = "isPreprocessDataCached",
		assetType = "",
		isServer = b22
	})

	local timestamp = tick()
	local v168 = ValidationHints.isPreprocessDataCached(p23, p24)
	local t18 = {
		isServer = b22
	}

	Analytics.recordScriptTime("isPreprocessDataCached", timestamp, t18)
	Analytics.reportScriptTimes(t18)

	return v168
end
function t1.calculateScaleToValidateBoundsAsync(p25, b23: boolean?, b24: boolean?, p26, b25: boolean?, p27) -- line: 746
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), ValidationHints (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "calculateScaleToValidateBoundsAsync",
		assetType = "",
		isServer = b23
	})

	local timestamp = tick()
	local v177 = nil

	if not p27 then
		local t19 = {}

		for _, v180 in p25 do
			table.insert(t19, v180)
		end

		local v181

		v181, v177 = createEditableInstancesForContext.processAll(t19, b24)

		if not v181 then
			if not b23 then
				return {
					ok = false,
					errors = v177
				}
			end

			error(v177[1])
		end
	end

	local t20 = {
		validateMeshPartAccessories = false,
		isServer = b23,
		allowEditableInstances = b24,
		bypassFlags = p26,
		lastTickSeconds = tick(),
		shouldYield = b25
	}

	if not p27 then
		t20.editableMeshes = v177.editableMeshes
		t20.editableImages = v177.editableImages
	end

	local v183 = ValidationHints.calculateScaleToValidateBoundsAsync(p25, t20, p27)

	if not p27 then
		destroyEditableInstances(t20.editableMeshes, t20.editableImages)
	end

	if v183.ok then
		Analytics.recordScriptTime("calculateScaleToValidateBoundsAsync", timestamp, t20)
		Analytics.reportScriptTimes(t20)
	end

	return v183
end

t1.GUIDAttributeName = Constants.GUIDAttributeName

return t1
