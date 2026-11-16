local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

local ConstantsInterface = require(parent.ConstantsInterface)

require(parent.util.BundlesMetadata)
require(parent.util.Types)
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)
local destroyEditableInstances = require(parent.util.destroyEditableInstances)
local createUGCBodyPartFolders = require(parent.util.createUGCBodyPartFolders)
local fixUpPreValidation = require(parent.util.fixUpPreValidation)
local validateInternal = require(parent.validation.validateInternal)
local validateFullBody = require(parent.validation.validateFullBody)

local LegacyValidationAdapter = require(parent.util.LegacyValidationAdapter)
local HttpService = game:GetService("HttpService")

local v = {
	Enum.AssetType.DynamicHead,
	Enum.AssetType.Torso,
	Enum.AssetType.LeftArm,
	Enum.AssetType.RightArm,
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.HairAccessory,
	Enum.AssetType.EyebrowAccessory,
	Enum.AssetType.EyelashAccessory
}

local function validateBundleReadyForUpload(model, p, p2, callback, allowEditableInstances: boolean?, bypassFlags)
	local v2 = callback or function() end
	assert(v2 ~= nil, "Luau")

	if not model:IsA("Model") then
		return Promise.resolve({
			errors = {
				{
					assetType = nil,
					error = { type = "message", message = "Invalid root instance, must be a model" }
				}
			},
			pieces = {}
		})
	end

	local ugcBodyPartFolders = createUGCBodyPartFolders(fixUpPreValidation(model), p, p2, false)

	local pieces2 = {}
	local errors = {}

	for k, allowedAssetTypeSetting in p[p2].allowedAssetTypeSettings do
		local assetType = assert(Enum.AssetType[k], "Asset type name doesn't map to an enum item")

		if not allowedAssetTypeSetting.isEligibleForUpload then
			continue
		end

		assert(
			allowedAssetTypeSetting.minimumQuantity == 0 or allowedAssetTypeSetting.minimumQuantity == 1,
			"Invalid minimum quantity, createUGCBodyParts folder is a dictionary and will only ever give one."
		)

		assert(
			allowedAssetTypeSetting.maximumQuantity == 0 or allowedAssetTypeSetting.maximumQuantity == 1,
			"Invalid maximum quantity, createUGCBodyParts folder is a dictionary and will only ever give one."
		)

		local ugcBodyPartFolder = ugcBodyPartFolders[assetType]
		local instance = ugcBodyPartFolder and ugcBodyPartFolder[1]

		if not (allowedAssetTypeSetting.minimumQuantity ~= 0 or instance ~= nil) then
			continue
		end

		table.insert(pieces2, {
			assetType = assetType,
			instance = instance,
			settings = allowedAssetTypeSetting,
			status = instance == nil and "finished" or "pending"
		})

		if instance == nil then
			table.insert(errors, {
				assetType = assetType,
				error = { type = "notFound" }
			})
		end
	end

	table.sort(pieces2, function(a, b): boolean
		return (table.find(v, a.assetType) or 1e999) < (table.find(v, b.assetType) or 1e999)
	end)

	local clone = { errors = 0, pieces = 0 }
	clone.errors = errors
	clone.pieces = pieces2

	v2(clone)
	local guid = HttpService:GenerateGUID()

	return Promise.each(pieces2, function(data, p3: number)
		if data.status == "finished" then
			return
		end

		assert(data.instance ~= nil, "Unfinished piece doesn't have an instnace")

		local instances = { data.instance }
		local v3 = {
			instances = instances,
			assetTypeEnum = data.assetType,
			allowUnreviewedAssets = false,
			isServer = false,
			isAsync = false,
			allowEditableInstances = allowEditableInstances,
			bypassFlags = bypassFlags,
			validateMeshPartAccessories = true,
			requireAllFolders = false
		}

		local v4, v5 = createEditableInstancesForContext.processAll(instances, allowEditableInstances)
		local v6

		if v4 then
			v3.editableMeshes = v5.editableMeshes
			v3.editableImages = v5.editableImages

			local v7, v8 = validateInternal(v3)
			v6, v5 = LegacyValidationAdapter.studioRFUAssetValidation(v3, guid, v7, v8)

			destroyEditableInstances(v3.editableMeshes, v3.editableImages)
		else
			v6 = false
		end

		clone = table.clone(clone)
		clone.errors = table.clone(clone.errors)

		if not v6 then
			assert(v5 ~= nil, "Failure without errors")

			for _, message in v5 do
				table.insert(clone.errors, {
					assetType = data.assetType,
					error = { type = "message", message = message }
				})
			end
		end

		clone.pieces = table.clone(clone.pieces)
		clone.pieces[p3].status = "finished"

		v2(clone)
	end):andThen(function()
		if p2 == "Body" then
			local function createFullBodyData(pieces)
				local fullBodyData = {}

				for _, item in pieces do
					if ConstantsInterface.isBodyPart(item.assetType) then
						table.insert(fullBodyData, {
							assetTypeEnum = item.assetType,
							allSelectedInstances = item.instance and { item.instance } or {}
						})
					end
				end

				return fullBodyData
			end

			local fullBodyData = createFullBodyData(clone.pieces)

			local v3 = {
				fullBodyData = fullBodyData,
				isServer = false,
				allowEditableInstances = allowEditableInstances,
				bypassFlags = bypassFlags,
				validateMeshPartAccessories = false,
				requireAllFolders = false
			}

			local allSelectedInstances = {}

			for _, v4 in fullBodyData do
				for _, allSelectedInstance in v4.allSelectedInstances do
					table.insert(allSelectedInstances, allSelectedInstance)
				end
			end

			local v4, v5 = createEditableInstancesForContext.processAll(allSelectedInstances, allowEditableInstances)
			local v6

			if v4 then
				v3.editableMeshes = v5.editableMeshes
				v3.editableImages = v5.editableImages

				local v7, v8 = validateFullBody(v3)
				v6, v5 = LegacyValidationAdapter.studioRFUBundleValidation(
					fullBodyData,
					Enum.BundleType.BodyParts,
					v3,
					guid,
					v7,
					v8
				)

				destroyEditableInstances(v3.editableMeshes, v3.editableImages)
			else
				v6 = false
			end

			if not v6 then
				clone = table.clone(clone)
				clone.errors = table.clone(clone.errors)

				assert(v5 and #v5 > 0, "There should always be a reason for failure")

				for _, message in v5 do
					table.insert(clone.errors, {
						assetType = nil,
						error = { type = "message", message = message }
					})
				end
			end

			v2(clone)
		end
	end):andThen(function()
		return clone
	end)
end

return validateBundleReadyForUpload
