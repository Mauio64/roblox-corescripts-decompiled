local parent = script.Parent.Parent
require(parent.util.Types)
local Constants = require(parent.Constants)
local createIndividualBodyPartSchema = require(parent.util.createIndividualBodyPartSchema)
local createLayeredClothingSchema = require(parent.util.createLayeredClothingSchema)
local createEyebrowEyelashSchema = require(parent.util.createEyebrowEyelashSchema)
local createMeshPartAccessorySchema = require(parent.util.createMeshPartAccessorySchema)
local createMakeupSchema = require(parent.util.createMakeupSchema)
local createDynamicHeadMeshPartSchema = require(parent.util.createDynamicHeadMeshPartSchema)
local createAccessorySchema = require(parent.util.createAccessorySchema)
local createEmoteSchema = require(parent.util.createEmoteSchema)
local createAnimationSchema = require(parent.util.createAnimationSchema)
local getUploadCategory = require(parent.util.getUploadCategory)
local getFFlagUGCValidationEyebrowEyelashCategory = require(parent.flags.getFFlagUGCValidationEyebrowEyelashCategory)

local CreateExpectedSchema = {}

local function getRootInstance(allSelectedInstances) -- 1 equivalent call inferred from this helper
	for _, item in allSelectedInstances do
		if item.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return item
		end
	end

	return allSelectedInstances[1]
end

function CreateExpectedSchema.generateBundleSchema(items)
	local bundleSchema = { ClassName = "Folder", _children = {} }

	for _, item in items do
		local rootInstance = getRootInstance(item.allSelectedInstances) -- inferred equivalent call
		local uploadCategory = getUploadCategory(rootInstance, item.assetTypeEnum, nil)

		local assetSchema = CreateExpectedSchema.generateAssetSchema(uploadCategory, item.assetTypeEnum, rootInstance)

		if assetSchema.ClassName == "Folder" then
			for _, v in assetSchema._children do
				table.insert(bundleSchema._children, v)
			end
		else
			table.insert(bundleSchema._children, assetSchema)
		end
	end

	return bundleSchema
end

local function createBodyPartSchema(p)
	local v = Constants.ASSET_TYPE_INFO[p]

	local bodyPartSchema = { ClassName = "Folder", _children = {} }

	for k in pairs(v.subParts) do
		local individualBodyPartSchema = createIndividualBodyPartSchema(p, k)
		table.insert(bodyPartSchema._children, individualBodyPartSchema)
	end

	return bodyPartSchema
end

local v = {
	EMOTE_ANIMATION = function(_, _)
		return createEmoteSchema()
	end,
	DYNAMIC_HEAD = function(_, _)
		return createDynamicHeadMeshPartSchema()
	end,
	TORSO_AND_LIMBS = function(p, _)
		return createBodyPartSchema(p)
	end,
	LAYERED_CLOTHING = function(p, _)
		if
			getFFlagUGCValidationEyebrowEyelashCategory()
			or p ~= Enum.AssetType.EyebrowAccessory and p ~= Enum.AssetType.EyelashAccessory
		then
			return createLayeredClothingSchema(Constants.ASSET_TYPE_INFO[p].attachmentNames)
		end

		return createEyebrowEyelashSchema(Constants.ASSET_TYPE_INFO[p].attachmentNames)
	end,
	EYEBROW_EYELASH = function(p, _)
		return createEyebrowEyelashSchema(Constants.ASSET_TYPE_INFO[p].attachmentNames)
	end,
	RIGID_ACCESSORY = function(p, instance)
		local v = Constants.ASSET_TYPE_INFO[p]

		if instance:FindFirstChildOfClass("MeshPart") then
			return createMeshPartAccessorySchema(v.attachmentNames)
		end

		return createAccessorySchema(v.attachmentNames)
	end,
	MAKEUP = function(_, _)
		return createMakeupSchema()
	end,
	ANIMATION = function(p, _)
		return createAnimationSchema(p)
	end
}

function CreateExpectedSchema.generateAssetSchema(p: string, p2, p3)
	return v[p](p2, p3)
end

function CreateExpectedSchema.generateAnimationPackBundleSchema()
	local animationPackBundleSchema = { ClassName = "Model", _children = {} }

	for _ in Constants.ANIMATION_ASSET_INFO do
		table.insert(animationPackBundleSchema._children, {
			ClassName = "Folder",
			Name = "R15Anim",
			_ignoreDescendants = true
		})
	end

	return animationPackBundleSchema
end

return CreateExpectedSchema
