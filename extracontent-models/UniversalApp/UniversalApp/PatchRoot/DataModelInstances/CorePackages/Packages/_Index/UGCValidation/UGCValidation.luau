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
local LegacyValidationAdapter = require(_script.util.LegacyValidationAdapter)
local SplitHumanoidRigDescriptionForUpload = require(_script.util.SplitHumanoidRigDescriptionForUpload)
local t1 = {
	ValidateAsset = ValidationManager.ValidateAsset,
	ValidateFinalizedBundle = ValidationManager.ValidateFinalizedBundle,
	combineResultsIntoLegacy = LegacyValidationAdapter.combineResultsIntoLegacy,
	mergeLegacyIntoModern = LegacyValidationAdapter.mergeLegacyIntoModern,
	isFolderStructureEnabled = getFFlagUGCValidationEnableFolderStructure,
	isEntrypointMergingEnabled = getFFlagUGCValidationCombineEntrypointResults,
	SplitHrdInUpload = SplitHumanoidRigDescriptionForUpload.fixUploadInstance
}

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function t1.validateWithContext(p1) -- line: 49
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

		local v34, v35 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)

		if not v34 then
			if not isServer then
				return v34, v35
			end

			error(v35[1])
		end

		p1.editableMeshes = v35.editableMeshes
		p1.editableImages = v35.editableImages
		p1.lastTickSeconds = tick()

		if p1.requireAllFolders == nil then
			p1.requireAllFolders = true
		end

		local v36, v37 = validateInternal(p1)

		destroyEditableInstances(p1.editableMeshes, p1.editableImages)

		if v36 then
			Analytics.recordScriptTime(script.Name, timestamp, p1)
			Analytics.reportScriptTimes(p1)
		end

		Analytics.reportCounter(v36, assetTypeEnum ~= Enum.AssetType.DynamicHead and "BodyPart" or "Head", p1)

		return v36, v37
	end
end

function t1.validate(t2: {[any]: any}, p2, b1: boolean?, b2: boolean?, p3, s1: string?, n1: number?, b3: boolean?, p4, b4: boolean?, b5: boolean?, b6: boolean?) -- line: 109
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateInternal (copy), destroyEditableInstances (copy)
	local timestamp = tick()

	Analytics.setMetadata({
		entrypoint = "validate",
		assetType = p2.Name,
		isServer = b1
	})

	local v51, v52 = createEditableInstancesForContext.processAll(t2, b3)

	if not v51 then
		if not b1 then
			return v51, v52
		end

		error(v52[1])
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
		editableMeshes = v52.editableMeshes,
		editableImages = v52.editableImages,
		requireAllFolders = b6 == nil or b6
	}
	local v54, v55 = validateInternal(t3)

	destroyEditableInstances(t3.editableMeshes, t3.editableImages)

	if v54 then
		Analytics.recordScriptTime(script.Name, timestamp, t3)
		Analytics.reportScriptTimes(t3)
	end

	Analytics.reportCounter(v54, p2 ~= Enum.AssetType.DynamicHead and "BodyPart" or "Head", t3)

	return v54, v55
end
function t1.validateAsync(t4: {[any]: any}, p5, p6: ((...any) -> ...any), b7: boolean?, b8: boolean?, p7) -- line: 180
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateInternal (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateAsync",
		assetType = p5.Name,
		isServer = b7
	})

	local v62, v63 = createEditableInstancesForContext.processAll(t4)

	if not v62 then
		if b7 then
			error(v63[1])
		else
			p6(v62, v63)
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
		editableMeshes = v63.editableMeshes,
		editableImages = v63.editableImages
	}

	coroutine.wrap(function() -- line: 216
		-- upvalues: p6 (copy), validateInternal (copy), t5 (copy), destroyEditableInstances (copy)
		p6(validateInternal(t5))
		destroyEditableInstances(t5.editableMeshes, t5.editableImages)
	end)()
end
function t1.validateMeshPartFormat(t6: {[any]: any}, p8, b9: boolean?, b10: boolean?, p9) -- line: 226
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateDynamicHeadMeshPartFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartFormat",
		assetType = p8.Name,
		isServer = b9
	})
	assert(p8 == Enum.AssetType.DynamicHead)

	local v70, v71 = createEditableInstancesForContext.processAll(t6)

	if not v70 then
		if not b9 then
			return v70, v71
		end

		error(v71[1])
	end

	local t7 = {
		validateMeshPartAccessories = false,
		instances = t6,
		assetTypeEnum = p8,
		allowUnreviewedAssets = b10,
		restrictedUserIds = p9,
		isServer = b9,
		editableMeshes = v71.editableMeshes,
		editableImages = v71.editableImages
	}
	local v73, v74 = validateDynamicHeadMeshPartFormat(t7)

	destroyEditableInstances(t7.editableMeshes, t7.editableImages)

	return v73, v74
end
function t1.validateAsyncMeshPartFormat(t8: {[any]: any}, p10, p11: ((...any) -> ...any), b11: boolean?, b12: boolean?, p12) -- line: 273
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateDynamicHeadMeshPartFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateAsyncMeshPartFormat",
		assetType = p10.Name,
		isServer = b11
	})
	assert(p10 == Enum.AssetType.DynamicHead)

	local v81, v82 = createEditableInstancesForContext.processAll(t8)

	if not v81 then
		if b11 then
			error(v82[1])
		else
			p11(v81, v82)
		end
	end

	local t9 = {
		validateMeshPartAccessories = false,
		instances = t8,
		assetTypeEnum = p10,
		allowUnreviewedAssets = b12,
		restrictedUserIds = p12,
		isServer = b11,
		editableMeshes = v82.editableMeshes,
		editableImages = v82.editableImages
	}

	coroutine.wrap(function() -- line: 311
		-- upvalues: p11 (copy), validateDynamicHeadMeshPartFormat (copy), t9 (copy), destroyEditableInstances (copy)
		p11(validateDynamicHeadMeshPartFormat(t9))
		destroyEditableInstances(t9.editableMeshes, t9.editableImages)
	end)()
end

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function t1.validateMeshPartAssetFormatWithContext(p13) -- line: 321
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

		local v89, v90 = createEditableInstancesForContext.processAll(instances)

		if not v89 then
			if not isServer then
				return v89, v90
			end

			error(v90[1])
		end

		p13.editableMeshes = v90.editableMeshes
		p13.editableImages = v90.editableImages
		p13.validateMeshPartAccessories = false

		local v91, v92

		if isLayeredClothing(instances[1]) then
			v91, v92 = validateLayeredClothingAccessoryMeshPartAssetFormat(specialMeshAccessory, p13)
		else
			v91, v92 = validateLegacyAccessoryMeshPartAssetFormat(specialMeshAccessory, p13)
		end

		destroyEditableInstances(p13.editableMeshes, p13.editableImages)

		return v91, v92
	end
end

function t1.validateMeshPartAssetFormat2(t10: {[any]: any}, p14, p15, b13: boolean?, b14: boolean?, _) -- line: 375
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), isLayeredClothing (copy), validateLayeredClothingAccessoryMeshPartAssetFormat (copy), validateLegacyAccessoryMeshPartAssetFormat (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartAssetFormat2",
		assetType = p15.Name,
		isServer = b13
	})

	local v99, v100 = createEditableInstancesForContext.processAll(t10)

	if not v99 then
		if not b13 then
			return v99, v100
		end

		error(v100[1])
	end

	local t11 = {
		validateMeshPartAccessories = false,
		instances = t10,
		assetTypeEnum = p15,
		allowUnreviewedAssets = b14,
		isServer = b13,
		editableMeshes = v100.editableMeshes,
		editableImages = v100.editableImages
	}
	local v102, v103

	if isLayeredClothing(t10[1]) then
		v102, v103 = validateLayeredClothingAccessoryMeshPartAssetFormat(p14, t11)
	else
		v102, v103 = validateLegacyAccessoryMeshPartAssetFormat(p14, t11)
	end

	destroyEditableInstances(t11.editableMeshes, t11.editableImages)

	return v102, v103
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
	function t1.validateFullBodyWithContext(p17) -- line: 480
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

		for _, v111 in fullBodyData do
			for _, v113 in v111.allSelectedInstances do
				table.insert(t12, v113)
			end
		end

		local v114, v115 = createEditableInstancesForContext.processAll(t12, allowEditableInstances)

		if not v114 then
			if not isServer then
				return v114, v115
			end

			error(v115[1])
		end

		p17.editableMeshes = v115.editableMeshes
		p17.editableImages = v115.editableImages
		p17.lastTickSeconds = tick()

		if p17.requireAllFolders == nil then
			p17.requireAllFolders = true
		end

		local v116, v117 = validateFullBody(p17)

		destroyEditableInstances(p17.editableMeshes, p17.editableImages)

		if v116 then
			Analytics.recordScriptTime(script.Name, timestamp, p17)
			Analytics.reportScriptTimes(p17)
		end

		Analytics.reportCounter(v116, "FullBody", p17)

		return v116, v117
	end
end

function t1.validateFullBody(p18, b15: boolean?, b16: boolean?, p19, b17: boolean?, b18: boolean?) -- line: 543
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), validateFullBody (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "validateFullBody",
		assetType = "",
		isServer = b15
	})

	local timestamp = tick()
	local t13 = {}

	for _, v127 in p18 do
		for _, v129 in v127.allSelectedInstances do
			table.insert(t13, v129)
		end
	end

	local v130, v131 = createEditableInstancesForContext.processAll(t13, b16)

	if not v130 then
		if not b15 then
			return v130, v131
		end

		error(v131[1])
	end

	local t14 = {
		validateMeshPartAccessories = false,
		fullBodyData = p18,
		isServer = b15,
		allowEditableInstances = b16,
		bypassFlags = p19,
		lastTickSeconds = tick(),
		shouldYield = b17,
		editableMeshes = v131.editableMeshes,
		editableImages = v131.editableImages,
		requireAllFolders = b18 == nil or b18
	}
	local v133, v134 = validateFullBody(t14)

	destroyEditableInstances(t14.editableMeshes, t14.editableImages)

	if v133 then
		Analytics.recordScriptTime(script.Name, timestamp, t14)
		Analytics.reportScriptTimes(t14)
	end

	Analytics.reportCounter(v133, "FullBody", t14)

	return v133, v134
end
function t1.validateShoesWithContext(p20) -- line: 605
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

	for _, v142 in fullBodyData do
		for _, v144 in v142.allSelectedInstances do
			table.insert(t15, v144)
		end
	end

	local v145, v146 = createEditableInstancesForContext.processAll(t15, allowEditableInstances)

	if not v145 then
		if not isServer then
			return v145, v146
		end

		error(v146[1])
	end

	p20.editableMeshes = v146.editableMeshes
	p20.editableImages = v146.editableImages
	p20.lastTickSeconds = tick()

	local v147, v148 = validateShoes(p20)

	destroyEditableInstances(p20.editableMeshes, p20.editableImages)

	if v147 then
		Analytics.recordScriptTime(script.Name, timestamp, p20)
		Analytics.reportScriptTimes(p20)
	end

	Analytics.reportCounter(v147, "Shoes", p20)

	return v147, v148
end
function t1.preprocessDataAsync(p21, b19: boolean?, b20: boolean?, p22, b21: boolean?) -- line: 657
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), ValidationHints (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "preprocessDataAsync",
		assetType = "",
		isServer = b19
	})

	local timestamp = tick()
	local t16 = {}

	for _, v157 in p21 do
		table.insert(t16, v157)
	end

	local v158, v159 = createEditableInstancesForContext.processAll(t16, b20)

	if not v158 then
		if not b19 then
			return {
				ok = false,
				errors = v159
			}
		end

		error(v159[1])
	end

	local t17 = {
		validateMeshPartAccessories = false,
		isServer = b19,
		allowEditableInstances = b20,
		bypassFlags = p22,
		lastTickSeconds = tick(),
		shouldYield = b21,
		editableMeshes = v159.editableMeshes,
		editableImages = v159.editableImages
	}
	local v161 = ValidationHints.preprocessDataAsync(p21, t17)

	destroyEditableInstances(t17.editableMeshes, t17.editableImages)

	if v161.ok then
		Analytics.recordScriptTime("preprocessDataAsync", timestamp, t17)
		Analytics.reportScriptTimes(t17)
	end

	return v161
end
function t1.isPreprocessDataCached(p23, p24, b22: boolean?) -- line: 716
	-- upvalues: Analytics (copy), ValidationHints (copy)
	Analytics.setMetadata({
		entrypoint = "isPreprocessDataCached",
		assetType = "",
		isServer = b22
	})

	local timestamp = tick()
	local v166 = ValidationHints.isPreprocessDataCached(p23, p24)
	local t18 = {
		isServer = b22
	}

	Analytics.recordScriptTime("isPreprocessDataCached", timestamp, t18)
	Analytics.reportScriptTimes(t18)

	return v166
end
function t1.calculateScaleToValidateBoundsAsync(p25, b23: boolean?, b24: boolean?, p26, b25: boolean?, p27) -- line: 741
	-- upvalues: Analytics (copy), createEditableInstancesForContext (copy), ValidationHints (copy), destroyEditableInstances (copy)
	Analytics.setMetadata({
		entrypoint = "calculateScaleToValidateBoundsAsync",
		assetType = "",
		isServer = b23
	})

	local timestamp = tick()
	local v175 = nil

	if not p27 then
		local t19 = {}

		for _, v178 in p25 do
			table.insert(t19, v178)
		end

		local v179

		v179, v175 = createEditableInstancesForContext.processAll(t19, b24)

		if not v179 then
			if not b23 then
				return {
					ok = false,
					errors = v175
				}
			end

			error(v175[1])
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
		t20.editableMeshes = v175.editableMeshes
		t20.editableImages = v175.editableImages
	end

	local v181 = ValidationHints.calculateScaleToValidateBoundsAsync(p25, t20, p27)

	if not p27 then
		destroyEditableInstances(t20.editableMeshes, t20.editableImages)
	end

	if v181.ok then
		Analytics.recordScriptTime("calculateScaleToValidateBoundsAsync", timestamp, t20)
		Analytics.reportScriptTimes(t20)
	end

	return v181
end

t1.GUIDAttributeName = Constants.GUIDAttributeName

return t1
