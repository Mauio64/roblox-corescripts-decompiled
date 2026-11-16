local script2 = script

local getEngineFeatureUGCValidationWithContextEntrypoint = require(script2.flags.getEngineFeatureUGCValidationWithContextEntrypoint)

local Analytics = require(script2.Analytics)
local Constants = require(script2.Constants)

local BundlesMetadata = require(script2.util.BundlesMetadata)
local canUploadBundlesAsync = require(script2.util.canUploadBundlesAsync)
local createUGCBodyPartFolders = require(script2.util.createUGCBodyPartFolders)
local isLayeredClothing = require(script2.util.isLayeredClothing)
local RigidOrLayeredAllowed = require(script2.util.RigidOrLayeredAllowed)
require(script2.util.Types)
local createEditableInstancesForContext = require(script2.util.createEditableInstancesForContext)
local destroyEditableInstances = require(script2.util.destroyEditableInstances)
local ValidationHints = require(script2.util.ValidationHints)

local validateInternal = require(script2.validation.validateInternal)

local validateLayeredClothingAccessoryMeshPartAssetFormat = require(script2.validation.validateLayeredClothingAccessoryMeshPartAssetFormat)
local validateLegacyAccessoryMeshPartAssetFormat = require(script2.validation.validateLegacyAccessoryMeshPartAssetFormat)
local validateFullBody = require(script2.validation.validateFullBody)
local validateShoes = require(script2.validation.validateShoes)

local validateBundleReadyForUpload = require(script2.validation.validateBundleReadyForUpload)
local validateShoesBundleReadyForUpload = require(script2.validation.validateShoesBundleReadyForUpload)
local validateAnimationBundleReadyForUpload = require(script2.validation.validateAnimationBundleReadyForUpload)
local validateDynamicHeadMeshPartFormat = require(script2.validation.validateDynamicHeadMeshPartFormat)
local ValidationManager = require(script2.validationSystem.ValidationManager)
local getFFlagDebugUGCDisableAssetQualityChecks = require(script2.flags.getFFlagDebugUGCDisableAssetQualityChecks)

local getFFlagUGCValidateBackendInExperienceViaCanPublish = require(script2.flags.getFFlagUGCValidateBackendInExperienceViaCanPublish)
local getFFlagUGCValidationAllowFullVaas = require(script2.flags.getFFlagUGCValidationAllowFullVaas)
local LegacyValidationAdapter = require(script2.util.LegacyValidationAdapter)
local AssetQualityValidationClient = require(script2.util.AssetQualityValidationClient)
local SplitHumanoidRigDescriptionForUpload = require(script2.util.SplitHumanoidRigDescriptionForUpload)
local UnpublishedDependencies = require(script2.util.UnpublishedDependencies)
local UGCValidation = {}

UGCValidation.ValidateAsset = ValidationManager.ValidateAsset
UGCValidation.ValidateFinalizedBundle = ValidationManager.ValidateFinalizedBundle
UGCValidation.combineResultsIntoLegacy = LegacyValidationAdapter.combineResultsIntoLegacy
UGCValidation.mergeLegacyIntoModern = LegacyValidationAdapter.mergeLegacyIntoModern
UGCValidation.isBackendInExperienceViaCanPublishEnabled = getFFlagUGCValidateBackendInExperienceViaCanPublish
UGCValidation.shouldSkipAssetQualityChecks = getFFlagDebugUGCDisableAssetQualityChecks
UGCValidation.isFullVaasEnabled = getFFlagUGCValidationAllowFullVaas
UGCValidation.SplitHrdInUpload = SplitHumanoidRigDescriptionForUpload.fixUploadInstance
UGCValidation.AssetQualityValidationClient = AssetQualityValidationClient

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function UGCValidation:validateWithContext()
		assert(self.instances ~= nil, "instances required in validationContext for validateWithContext")
		assert(self.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateWithContext")

		local instances = self.instances
		local isServer = self.isServer
		local assetTypeEnum = self.assetTypeEnum
		local allowEditableInstances = self.allowEditableInstances

		local now = tick()

		Analytics.setMetadata({
			entrypoint = "validate",
			assetType = assetTypeEnum.Name,
			isServer = isServer
		})

		local v, v2 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)

		if not v then
			if not isServer then
				return v, v2
			end

			if UnpublishedDependencies.shouldReturnOnLoadFailure(self) then
				return false, {}
			end

			error(v2[1])
		end

		self.editableMeshes = v2.editableMeshes
		self.editableImages = v2.editableImages
		self.lastTickSeconds = tick()

		if self.requireAllFolders == nil then
			self.requireAllFolders = true
		end

		local v3, v4 = validateInternal(self)

		destroyEditableInstances(self.editableMeshes, self.editableImages)

		if v3 then
			Analytics.recordScriptTime(script.Name, now, self)
			Analytics.reportScriptTimes(self)
		end

		Analytics.reportCounter(v3, assetTypeEnum == Enum.AssetType.DynamicHead and "Head" or "BodyPart", self)

		return v3, v4
	end
end

function UGCValidation.validate(instances, assetTypeEnum, isServer: boolean?, allowUnreviewedAssets: boolean?, restrictedUserIds, token: string?, universeId: number?, allowEditableInstances: boolean?, bypassFlags, shouldYield: boolean?, flag: boolean?, flag2: boolean?)
	local now = tick()

	Analytics.setMetadata({
		entrypoint = "validate",
		assetType = assetTypeEnum.Name,
		isServer = isServer
	})

	local v, v2 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)

	if not v then
		if not isServer then
			return v, v2
		end

		error(v2[1])
	end

	local v3 = {
		instances = instances,
		assetTypeEnum = assetTypeEnum,
		allowUnreviewedAssets = allowUnreviewedAssets,
		restrictedUserIds = restrictedUserIds,
		isServer = isServer,
		token = token,
		universeId = universeId,
		isAsync = false,
		allowEditableInstances = allowEditableInstances,
		bypassFlags = bypassFlags,
		validateMeshPartAccessories = flag == nil or flag,
		lastTickSeconds = tick(),
		shouldYield = shouldYield,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages,
		requireAllFolders = flag2 == nil or flag2
	}

	local v4, v5 = validateInternal(v3)

	destroyEditableInstances(v3.editableMeshes, v3.editableImages)

	if v4 then
		Analytics.recordScriptTime(script.Name, now, v3)
		Analytics.reportScriptTimes(v3)
	end

	Analytics.reportCounter(v4, assetTypeEnum == Enum.AssetType.DynamicHead and "Head" or "BodyPart", v3)

	return v4, v5
end

function UGCValidation.validateAsync(instances, assetTypeEnum, callback, isServer: boolean?, allowUnreviewedAssets: boolean?, restrictedUserIds)
	Analytics.setMetadata({
		entrypoint = "validateAsync",
		assetType = assetTypeEnum.Name,
		isServer = isServer
	})

	local v, v2 = createEditableInstancesForContext.processAll(instances)

	if not v then
		if isServer then
			error(v2[1])
		else
			callback(v, v2)
		end
	end

	local v3 = {
		instances = instances,
		assetTypeEnum = assetTypeEnum,
		allowUnreviewedAssets = allowUnreviewedAssets,
		restrictedUserIds = restrictedUserIds,
		isServer = isServer,
		token = "",
		isAsync = true,
		validateMeshPartAccessories = false,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages
	}

	coroutine.wrap(function()
		callback(validateInternal(v3))
		destroyEditableInstances(v3.editableMeshes, v3.editableImages)
	end)()
end

function UGCValidation.validateMeshPartFormat(instances, assetTypeEnum, isServer: boolean?, allowUnreviewedAssets: boolean?, restrictedUserIds)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartFormat",
		assetType = assetTypeEnum.Name,
		isServer = isServer
	})

	assert(Enum.AssetType.DynamicHead == assetTypeEnum)

	local v, v2 = createEditableInstancesForContext.processAll(instances)

	if not v then
		if not isServer then
			return v, v2
		end

		error(v2[1])
	end

	local v3 = {
		instances = instances,
		assetTypeEnum = assetTypeEnum,
		allowUnreviewedAssets = allowUnreviewedAssets,
		restrictedUserIds = restrictedUserIds,
		isServer = isServer,
		validateMeshPartAccessories = false,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages
	}

	local v4, v5 = validateDynamicHeadMeshPartFormat(v3)

	destroyEditableInstances(v3.editableMeshes, v3.editableImages)

	return v4, v5
end

function UGCValidation.validateAsyncMeshPartFormat(instances, assetTypeEnum, callback, isServer: boolean?, allowUnreviewedAssets: boolean?, restrictedUserIds)
	Analytics.setMetadata({
		entrypoint = "validateAsyncMeshPartFormat",
		assetType = assetTypeEnum.Name,
		isServer = isServer
	})

	assert(Enum.AssetType.DynamicHead == assetTypeEnum)

	local v, v2 = createEditableInstancesForContext.processAll(instances)

	if not v then
		if isServer then
			error(v2[1])
		else
			callback(v, v2)
		end
	end

	local v3 = {
		instances = instances,
		assetTypeEnum = assetTypeEnum,
		allowUnreviewedAssets = allowUnreviewedAssets,
		restrictedUserIds = restrictedUserIds,
		isServer = isServer,
		validateMeshPartAccessories = false,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages
	}

	coroutine.wrap(function()
		callback(validateDynamicHeadMeshPartFormat(v3))
		destroyEditableInstances(v3.editableMeshes, v3.editableImages)
	end)()
end

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function UGCValidation:validateMeshPartAssetFormatWithContext()
		assert(
			self.assetTypeEnum ~= nil,
			"assetTypeEnum required in validationContext for validateMeshPartAssetFormatWithContext"
		)

		assert(
			self.instances ~= nil,
			"instances required in validationContext for validateMeshPartAssetFormatWithContext"
		)

		local instances = self.instances
		local assetTypeEnum = self.assetTypeEnum
		local isServer = self.isServer
		local specialMeshAccessory = self.specialMeshAccessory

		Analytics.setMetadata({
			entrypoint = "validateMeshPartAssetFormat2",
			assetType = assetTypeEnum.Name,
			isServer = isServer
		})

		local v, v2 = createEditableInstancesForContext.processAll(instances)

		if not v then
			if not isServer then
				return v, v2
			end

			error(v2[1])
		end

		self.editableMeshes = v2.editableMeshes
		self.editableImages = v2.editableImages
		self.validateMeshPartAccessories = false
		local v3, v4

		if isLayeredClothing(instances[1]) then
			v3, v4 = validateLayeredClothingAccessoryMeshPartAssetFormat(specialMeshAccessory, self)
		else
			v3, v4 = validateLegacyAccessoryMeshPartAssetFormat(specialMeshAccessory, self)
		end

		destroyEditableInstances(self.editableMeshes, self.editableImages)

		return v3, v4
	end
end

function UGCValidation.validateMeshPartAssetFormat2(instances, p, assetTypeEnum, isServer: boolean?, allowUnreviewedAssets: boolean?, _)
	Analytics.setMetadata({
		entrypoint = "validateMeshPartAssetFormat2",
		assetType = assetTypeEnum.Name,
		isServer = isServer
	})

	local v, v2 = createEditableInstancesForContext.processAll(instances)

	if not v then
		if not isServer then
			return v, v2
		end

		error(v2[1])
	end

	local v3 = {
		instances = instances,
		assetTypeEnum = assetTypeEnum,
		allowUnreviewedAssets = allowUnreviewedAssets,
		isServer = isServer,
		validateMeshPartAccessories = false,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages
	}
	local v4, v5

	if isLayeredClothing(instances[1]) then
		v4, v5 = validateLayeredClothingAccessoryMeshPartAssetFormat(p, v3)
	else
		v4, v5 = validateLegacyAccessoryMeshPartAssetFormat(p, v3)
	end

	destroyEditableInstances(v3.editableMeshes, v3.editableImages)

	return v4, v5
end

UGCValidation.validateBundleReadyForUpload = validateBundleReadyForUpload
UGCValidation.validateShoesBundleReadyForUpload = validateShoesBundleReadyForUpload
UGCValidation.validateAnimationBundleReadyForUpload = validateAnimationBundleReadyForUpload

UGCValidation.util = {
	BundlesMetadata = BundlesMetadata,
	createUGCBodyPartFolders = createUGCBodyPartFolders,
	canUploadBundlesAsync = canUploadBundlesAsync
}

UGCValidation.util.isLayeredClothingAllowed = RigidOrLayeredAllowed.isLayeredClothingAllowed
UGCValidation.util.isRigidAccessoryAllowed = RigidOrLayeredAllowed.isRigidAccessoryAllowed

if getEngineFeatureUGCValidationWithContextEntrypoint() then
	function UGCValidation:validateFullBodyWithContext()
		assert(self.fullBodyData ~= nil, "fullBodyData required in validationContext for validateFullBodyWithContext")

		local isServer = self.isServer
		local fullBodyData = self.fullBodyData
		local allowEditableInstances = self.allowEditableInstances

		Analytics.setMetadata({
			entrypoint = "validateFullBody",
			assetType = "",
			isServer = isServer
		})

		local now = tick()

		local allSelectedInstances = {}

		for _, v in fullBodyData do
			for _, allSelectedInstance in v.allSelectedInstances do
				table.insert(allSelectedInstances, allSelectedInstance)
			end
		end

		local v, v2 = createEditableInstancesForContext.processAll(allSelectedInstances, allowEditableInstances)

		if not v then
			if not isServer then
				return v, v2
			end

			if UnpublishedDependencies.shouldReturnOnLoadFailure(self) then
				return false, {}
			end

			error(v2[1])
		end

		self.editableMeshes = v2.editableMeshes
		self.editableImages = v2.editableImages
		self.lastTickSeconds = tick()

		if self.requireAllFolders == nil then
			self.requireAllFolders = true
		end

		local v3, v4 = validateFullBody(self)

		destroyEditableInstances(self.editableMeshes, self.editableImages)

		if v3 then
			Analytics.recordScriptTime(script.Name, now, self)
			Analytics.reportScriptTimes(self)
		end

		Analytics.reportCounter(v3, "FullBody", self)

		return v3, v4
	end
end

function UGCValidation.validateFullBody(fullBodyData, isServer: boolean?, allowEditableInstances: boolean?, bypassFlags, shouldYield: boolean?, flag: boolean?)
	Analytics.setMetadata({ entrypoint = "validateFullBody", assetType = "", isServer = isServer })

	local now = tick()

	local allSelectedInstances = {}

	for _, item in fullBodyData do
		for _, allSelectedInstance in item.allSelectedInstances do
			table.insert(allSelectedInstances, allSelectedInstance)
		end
	end

	local v, v2 = createEditableInstancesForContext.processAll(allSelectedInstances, allowEditableInstances)

	if not v then
		if not isServer then
			return v, v2
		end

		error(v2[1])
	end

	local v3 = {
		fullBodyData = fullBodyData,
		isServer = isServer,
		allowEditableInstances = allowEditableInstances,
		bypassFlags = bypassFlags,
		validateMeshPartAccessories = false,
		lastTickSeconds = tick(),
		shouldYield = shouldYield,
		editableMeshes = v2.editableMeshes,
		editableImages = v2.editableImages,
		requireAllFolders = flag == nil or flag
	}

	local v4, v5 = validateFullBody(v3)

	destroyEditableInstances(v3.editableMeshes, v3.editableImages)

	if v4 then
		Analytics.recordScriptTime(script.Name, now, v3)
		Analytics.reportScriptTimes(v3)
	end

	Analytics.reportCounter(v4, "FullBody", v3)

	return v4, v5
end

function UGCValidation:validateShoesWithContext()
	assert(self.fullBodyData ~= nil, "fullBodyData required in validationContext for validateShoes")

	local isServer = self.isServer
	local fullBodyData = self.fullBodyData
	local allowEditableInstances = self.allowEditableInstances

	Analytics.setMetadata({ entrypoint = "validateShoes", assetType = "", isServer = isServer })

	local now = tick()

	local allSelectedInstances = {}

	for _, v in fullBodyData do
		for _, allSelectedInstance in v.allSelectedInstances do
			table.insert(allSelectedInstances, allSelectedInstance)
		end
	end

	local v, v2 = createEditableInstancesForContext.processAll(allSelectedInstances, allowEditableInstances)

	if not v then
		if not isServer then
			return v, v2
		end

		if UnpublishedDependencies.shouldReturnOnLoadFailure(self) then
			return false, {}
		end

		error(v2[1])
	end

	self.editableMeshes = v2.editableMeshes
	self.editableImages = v2.editableImages
	self.lastTickSeconds = tick()

	local v3, v4 = validateShoes(self)

	destroyEditableInstances(self.editableMeshes, self.editableImages)

	if v3 then
		Analytics.recordScriptTime(script.Name, now, self)
		Analytics.reportScriptTimes(self)
	end

	Analytics.reportCounter(v3, "Shoes", self)

	return v3, v4
end

function UGCValidation.preprocessDataAsync(items, isServer: boolean?, allowEditableInstances: boolean?, bypassFlags, shouldYield: boolean?)
	Analytics.setMetadata({
		entrypoint = "preprocessDataAsync",
		assetType = "",
		isServer = isServer
	})

	local now = tick()

	local v = {}

	for _, item in items do
		table.insert(v, item)
	end

	local v2, errors = createEditableInstancesForContext.processAll(v, allowEditableInstances)

	if not v2 then
		if not isServer then
			return { ok = false, errors = errors }
		end

		error(errors[1])
	end

	local v3 = {
		isServer = isServer,
		allowEditableInstances = allowEditableInstances,
		bypassFlags = bypassFlags,
		validateMeshPartAccessories = false,
		lastTickSeconds = tick(),
		shouldYield = shouldYield,
		editableMeshes = errors.editableMeshes,
		editableImages = errors.editableImages
	}

	local preprocessDataAsync = ValidationHints.preprocessDataAsync(items, v3)

	destroyEditableInstances(v3.editableMeshes, v3.editableImages)

	if preprocessDataAsync.ok then
		Analytics.recordScriptTime("preprocessDataAsync", now, v3)
		Analytics.reportScriptTimes(v3)
	end

	return preprocessDataAsync
end

function UGCValidation.isPreprocessDataCached(p, p2, isServer: boolean?)
	Analytics.setMetadata({
		entrypoint = "isPreprocessDataCached",
		assetType = "",
		isServer = isServer
	})

	local now = tick()

	local preprocessDataCached = ValidationHints.isPreprocessDataCached(p, p2)

	local v = { isServer = isServer }

	Analytics.recordScriptTime("isPreprocessDataCached", now, v)
	Analytics.reportScriptTimes(v)

	return preprocessDataCached
end

function UGCValidation.calculateScaleToValidateBoundsAsync(items, isServer: boolean?, allowEditableInstances: boolean?, bypassFlags, shouldYield: boolean?, p)
	Analytics.setMetadata({
		entrypoint = "calculateScaleToValidateBoundsAsync",
		assetType = "",
		isServer = isServer
	})

	local now = tick()
	local errors

	if not p then
		local v = {}

		for _, item in items do
			table.insert(v, item)
		end

		local v2
		v2, errors = createEditableInstancesForContext.processAll(v, allowEditableInstances)

		if not v2 then
			if not isServer then
				return { ok = false, errors = errors }
			end

			error(errors[1])
		end
	end

	local v = {
		isServer = isServer,
		allowEditableInstances = allowEditableInstances,
		bypassFlags = bypassFlags,
		validateMeshPartAccessories = false,
		lastTickSeconds = tick(),
		shouldYield = shouldYield
	}

	if not p then
		v.editableMeshes = errors.editableMeshes
		v.editableImages = errors.editableImages
	end

	local scaleToValidateBoundsAsync = ValidationHints.calculateScaleToValidateBoundsAsync(items, v, p)

	if not p then
		destroyEditableInstances(v.editableMeshes, v.editableImages)
	end

	if scaleToValidateBoundsAsync.ok then
		Analytics.recordScriptTime("calculateScaleToValidateBoundsAsync", now, v)
		Analytics.reportScriptTimes(v)
	end

	return scaleToValidateBoundsAsync
end

UGCValidation.GUIDAttributeName = Constants.GUIDAttributeName

return UGCValidation
