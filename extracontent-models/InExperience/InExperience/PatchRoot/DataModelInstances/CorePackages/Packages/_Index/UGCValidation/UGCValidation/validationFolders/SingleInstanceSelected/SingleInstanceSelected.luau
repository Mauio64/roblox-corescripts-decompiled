local parent = script.Parent.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)

local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getEngineFeatureEngineUGCValidateInstanceTreesEquivalent = require(parent.flags.getEngineFeatureEngineUGCValidateInstanceTreesEquivalent)

local UGCValidationService = game:GetService("UGCValidationService")
local SingleInstanceSelected = {}

SingleInstanceSelected.categories = Constants.AllAssetUploadCategories
SingleInstanceSelected.requiredData = {
	ValidationEnums.SharedDataMember.entrypointInput,
	ValidationEnums.SharedDataMember.consumerConfig,
	ValidationEnums.SharedDataMember.uploadEnum
}

local function deepEquals(r15ArtistIntent, r15Fixed, consumerEnv) -- 1 equivalent call inferred from this helper
	if
		getEngineFeatureEngineUGCValidateInstanceTreesEquivalent()
		and consumerEnv == ValidationEnums.ConsumerEnv.Backend
	then
		return UGCValidationService:AreInstanceTreesEquivalent(r15ArtistIntent, r15Fixed)
	end

	return true
end

local function getFoldersMapping(entrypointInput)
	local v = { R15ArtistIntent = true, R15Fixed = true, R6 = true }

	local foldersByName = {}

	for _, folder in entrypointInput do
		if folder:IsA("Folder") and v[folder.Name] then
			foldersByName[folder.Name] = folder
		end
	end

	return foldersByName
end

function SingleInstanceSelected.run(object, data)
	local entrypointInput = data.entrypointInput
	local consumerConfig = data.consumerConfig
	local assetType = data.uploadEnum.assetType

	if Constants.AssetUploadsWithFolderStructure[assetType] and consumerConfig.enforceR15FolderStructure then
		if #entrypointInput ~= 3 then
			object:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)
			return
		end

		local foldersMapping = getFoldersMapping(entrypointInput)

		if
			foldersMapping.R15ArtistIntent
			and foldersMapping.R15Fixed
			and foldersMapping.R6
			and #foldersMapping.R6:GetChildren() == 0
			and deepEquals(foldersMapping.R15ArtistIntent, foldersMapping.R15Fixed, consumerConfig.consumerEnv) -- inferred equivalent call
		then
			return
		end

		object:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)
	elseif #entrypointInput ~= 1 then
		object:fail(ErrorSourceStrings.Keys.SelectionCountNotOne)
	end
end

return SingleInstanceSelected
