local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local createIndividualBodyPartSchema = require(ParentParent.util.createIndividualBodyPartSchema)
local createLayeredClothingSchema = require(ParentParent.util.createLayeredClothingSchema)
local createEyebrowEyelashSchema = require(ParentParent.util.createEyebrowEyelashSchema)
local createMeshPartAccessorySchema = require(ParentParent.util.createMeshPartAccessorySchema)
local createMakeupSchema = require(ParentParent.util.createMakeupSchema)
local createDynamicHeadMeshPartSchema = require(ParentParent.util.createDynamicHeadMeshPartSchema)
local createAccessorySchema = require(ParentParent.util.createAccessorySchema)
local createEmoteSchema = require(ParentParent.util.createEmoteSchema)
local createAnimationSchema = require(ParentParent.util.createAnimationSchema)
local getUploadCategory = require(ParentParent.util.getUploadCategory)
local getFFlagUGCValidateEyebrowEyelashThumbnailSchema = require(ParentParent.flags.getFFlagUGCValidateEyebrowEyelashThumbnailSchema)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidationAnimationPackFolderStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackFolderStructure)
local t1 = {}

local function getRootInstance(t2: {[any]: any}) -- line: 24
	-- upvalues: Constants (copy)
	for _, v23 in t2 do
		if v23.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return v23
		end
	end

	return t2[1]
end

function t1.generateBundleSchema(p1) -- line: 35
	-- upvalues: Constants (copy), getUploadCategory (copy), t1 (copy)
	local t3 = {
		ClassName = "Folder",
		_children = {}
	}
	local g32 = nil
	local v31 = nil

	for _, v27 in p1 do
		local allSelectedInstances = v27.allSelectedInstances

		for _, v30 in allSelectedInstances do
			if v30.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
				v31 = v30
				g32 = true
			end

			if g32 then
				break
			end
		end

		if not g32 then
			v31 = allSelectedInstances[1]
		end

		g32 = false

		local v33 = getUploadCategory(v31, v27.assetTypeEnum, nil)
		local v34 = t1.generateAssetSchema(v33, v27.assetTypeEnum, v31)

		if v34.ClassName == "Folder" then
			for _, v36 in v34._children do
				table.insert(t3._children, v36)
			end
		else
			table.insert(t3._children, v34)
		end
	end

	return t3
end

local function createBodyPartSchema(p2) -- line: 61
	-- upvalues: Constants (copy), createIndividualBodyPartSchema (copy)
	local v38 = Constants.ASSET_TYPE_INFO[p2]
	local t4 = {
		ClassName = "Folder",
		_children = {}
	}

	for k in pairs(v38.subParts) do
		local v41 = createIndividualBodyPartSchema(p2, k)

		table.insert(t4._children, v41)
	end

	return t4
end

local t5 = {
	EMOTE_ANIMATION = function(_, _) -- line: 77
		-- upvalues: createEmoteSchema (copy)
		return createEmoteSchema()
	end,
	DYNAMIC_HEAD = function(_, _) -- line: 80
		-- upvalues: createDynamicHeadMeshPartSchema (copy)
		return createDynamicHeadMeshPartSchema()
	end,
	TORSO_AND_LIMBS = function(p7, _) -- line: 83
		-- upvalues: createBodyPartSchema (copy)
		return (createBodyPartSchema(p7))
	end,
	LAYERED_CLOTHING = function(p9, _) -- line: 86
		-- upvalues: getFFlagUGCValidateEyebrowEyelashThumbnailSchema (copy), createEyebrowEyelashSchema (copy), Constants (copy), createLayeredClothingSchema (copy)
		if getFFlagUGCValidateEyebrowEyelashThumbnailSchema() then
			if p9 == Enum.AssetType.EyebrowAccessory or p9 == Enum.AssetType.EyelashAccessory then
				return createEyebrowEyelashSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
			end

			return createLayeredClothingSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
		end

		return createLayeredClothingSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
	end,
	RIGID_ACCESSORY = function(p11, p12) -- line: 97
		-- upvalues: Constants (copy), createMeshPartAccessorySchema (copy), createAccessorySchema (copy)
		local v52 = Constants.ASSET_TYPE_INFO[p11]

		if p12:FindFirstChildOfClass("MeshPart") then
			return createMeshPartAccessorySchema(v52.attachmentNames)
		end

		return createAccessorySchema(v52.attachmentNames)
	end,
	MAKEUP = function(_, _) -- line: 106
		-- upvalues: createMakeupSchema (copy)
		return createMakeupSchema()
	end
}

if getFFlagUGCValidationAnimationPackSupport() then
	function t5.ANIMATION(p15, p16) -- line: 112
		-- upvalues: createAnimationSchema (copy)
		return createAnimationSchema(p15, p16)
	end
end

function t1.generateAssetSchema(s1: string, p17, p18) -- line: 117
	-- upvalues: t5 (copy)
	return t5[s1](p17, p18)
end

local function hasTopLevelR15Anim(p19) -- line: 125
	if not p19 then
		return false
	end

	for _, child in p19:GetChildren() do
		if child.Name == "R15Anim" then
			return true
		end
	end

	return false
end

function t1.generateAnimationPackBundleSchema(p20) -- line: 138
	-- upvalues: getFFlagUGCValidationAnimationPackFolderStructure (copy), Constants (copy)
	local t6 = {
		ClassName = "Model",
		_children = {}
	}
	local v65 = getFFlagUGCValidationAnimationPackFolderStructure()
	local g68

	if v65 then
		if not p20 then
			v65 = false
		else
			g68 = nil

			for _, child in p20:GetChildren() do
				if child.Name == "R15Anim" then
					v65 = true
					g68 = true
				end

				if g68 then
					break
				end
			end

			if not g68 then
				v65 = false
			end
		end
	end

	g68 = false

	for _, v70 in Constants.ANIMATION_ASSET_INFO do
		if v65 then
			table.insert(t6._children, {
				ClassName = "Folder",
				Name = "R15Anim",
				_ignoreDescendants = true
			})
		else
			table.insert(t6._children, {
				ClassName = "Model",
				_ignoreDescendants = true,
				Name = v70.modelName
			})
		end
	end

	return t6
end

return t1
