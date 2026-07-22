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
local getFFlagUGCValidationAnimationPackDisableModelStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackDisableModelStructure)
local t1 = {}

local function getRootInstance(t2: {[any]: any}) -- line: 26
	-- upvalues: Constants (copy)
	for _, v24 in t2 do
		if v24.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
			return v24
		end
	end

	return t2[1]
end

function t1.generateBundleSchema(p1) -- line: 37
	-- upvalues: Constants (copy), getUploadCategory (copy), t1 (copy)
	local t3 = {
		ClassName = "Folder",
		_children = {}
	}
	local g33 = nil
	local v32 = nil

	for _, v28 in p1 do
		local allSelectedInstances = v28.allSelectedInstances

		for _, v31 in allSelectedInstances do
			if v31.Name == Constants.FOLDER_NAMES.R15ArtistIntent then
				v32 = v31
				g33 = true
			end

			if g33 then
				break
			end
		end

		if not g33 then
			v32 = allSelectedInstances[1]
		end

		g33 = false

		local v34 = getUploadCategory(v32, v28.assetTypeEnum, nil)
		local v35 = t1.generateAssetSchema(v34, v28.assetTypeEnum, v32)

		if v35.ClassName == "Folder" then
			for _, v37 in v35._children do
				table.insert(t3._children, v37)
			end
		else
			table.insert(t3._children, v35)
		end
	end

	return t3
end

local function createBodyPartSchema(p2) -- line: 63
	-- upvalues: Constants (copy), createIndividualBodyPartSchema (copy)
	local v39 = Constants.ASSET_TYPE_INFO[p2]
	local t4 = {
		ClassName = "Folder",
		_children = {}
	}

	for k in pairs(v39.subParts) do
		local v42 = createIndividualBodyPartSchema(p2, k)

		table.insert(t4._children, v42)
	end

	return t4
end

local t5 = {
	EMOTE_ANIMATION = function(_, _) -- line: 79
		-- upvalues: createEmoteSchema (copy)
		return createEmoteSchema()
	end,
	DYNAMIC_HEAD = function(_, _) -- line: 82
		-- upvalues: createDynamicHeadMeshPartSchema (copy)
		return createDynamicHeadMeshPartSchema()
	end,
	TORSO_AND_LIMBS = function(p7, _) -- line: 85
		-- upvalues: createBodyPartSchema (copy)
		return (createBodyPartSchema(p7))
	end,
	LAYERED_CLOTHING = function(p9, _) -- line: 88
		-- upvalues: getFFlagUGCValidateEyebrowEyelashThumbnailSchema (copy), createEyebrowEyelashSchema (copy), Constants (copy), createLayeredClothingSchema (copy)
		if getFFlagUGCValidateEyebrowEyelashThumbnailSchema() then
			if p9 == Enum.AssetType.EyebrowAccessory or p9 == Enum.AssetType.EyelashAccessory then
				return createEyebrowEyelashSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
			end

			return createLayeredClothingSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
		end

		return createLayeredClothingSchema(Constants.ASSET_TYPE_INFO[p9].attachmentNames)
	end,
	RIGID_ACCESSORY = function(p11, p12) -- line: 99
		-- upvalues: Constants (copy), createMeshPartAccessorySchema (copy), createAccessorySchema (copy)
		local v53 = Constants.ASSET_TYPE_INFO[p11]

		if p12:FindFirstChildOfClass("MeshPart") then
			return createMeshPartAccessorySchema(v53.attachmentNames)
		end

		return createAccessorySchema(v53.attachmentNames)
	end,
	MAKEUP = function(_, _) -- line: 108
		-- upvalues: createMakeupSchema (copy)
		return createMakeupSchema()
	end
}

if getFFlagUGCValidationAnimationPackSupport() then
	function t5.ANIMATION(p15, p16) -- line: 114
		-- upvalues: createAnimationSchema (copy)
		return createAnimationSchema(p15, p16)
	end
end

function t1.generateAssetSchema(s1: string, p17, p18) -- line: 119
	-- upvalues: t5 (copy)
	return t5[s1](p17, p18)
end

local function hasTopLevelR15Anim(p19) -- line: 127
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

function t1.generateAnimationPackBundleSchema(p20) -- line: 140
	-- upvalues: getFFlagUGCValidationAnimationPackDisableModelStructure (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy), Constants (copy)
	local t6 = {
		ClassName = "Model",
		_children = {}
	}
	local v66 = getFFlagUGCValidationAnimationPackDisableModelStructure()
	local g69

	if not v66 then
		v66 = getFFlagUGCValidationAnimationPackFolderStructure()

		if v66 then
			if not p20 then
				v66 = false
			else
				g69 = nil

				for _, child in p20:GetChildren() do
					if child.Name == "R15Anim" then
						v66 = true
						g69 = true
					end

					if g69 then
						break
					end
				end

				if not g69 then
					v66 = false
				end
			end
		end
	end

	g69 = false

	for _, v71 in Constants.ANIMATION_ASSET_INFO do
		if v66 then
			table.insert(t6._children, {
				ClassName = "Folder",
				Name = "R15Anim",
				_ignoreDescendants = true
			})
		else
			table.insert(t6._children, {
				ClassName = "Model",
				_ignoreDescendants = true,
				Name = v71.modelName
			})
		end
	end

	return t6
end

return t1
