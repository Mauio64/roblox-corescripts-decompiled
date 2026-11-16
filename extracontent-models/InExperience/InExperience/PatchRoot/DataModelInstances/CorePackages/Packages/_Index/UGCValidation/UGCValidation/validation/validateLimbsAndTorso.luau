local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local validateMeshPartBodyPart = require(parent.validation.validateMeshPartBodyPart)
local validateTags = require(parent.validation.validateTags)

local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local createLimbsAndTorsoSchema = require(parent.util.createLimbsAndTorsoSchema)
require(parent.util.Types)

local function getInstance(items, p: string) -- 3 equivalent calls inferred from this helper
	for _, item in pairs(items) do
		if item.Name == p then
			return item
		end
	end

	return nil
end

local function areTopLevelFoldersCorrect(instances, list): boolean
	if #instances ~= #list then
		return false
	end

	for _, item in list do
		local instance = getInstance(instances, item) -- inferred equivalent call

		if not instance or instance.ClassName ~= "Folder" then
			return false
		end
	end

	return true
end

local function getFullNameWithoutRootFolder(descendant, item: string) -- 1 equivalent call inferred from this helper
	local fullName = descendant:GetFullName()
	local v, v2 = string.find(fullName, item .. "%.")
	assert(v and v2)
	return (string.sub(fullName, v2 + 1, #fullName))
end

local function compareFolderInfo(items, p, p2)
	local v = FailureReasonsAccumulator.new()

	for k, item in items do
		if not (p[k] == nil or p[k] ~= item) then
			continue
		end

		Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_FolderInfoMismatch, nil, p2)

		v:updateReasons(false, {
			`Attribute {k} has different values in different children folders. You need to use the same value in all folders.`
		})
	end

	return v:getFinalResults()
end

local function validateFolderAssetIdsMatch(instances, list, data)
	if #list == 1 then
		return true
	end

	local v = FailureReasonsAccumulator.new()
	local v2 = nil

	for _, item in list do
		if item == Constants.FOLDER_NAMES.R6 then
			continue
		end

		local instance = getInstance(instances, item) -- inferred equivalent call
		assert(instance)

		local v3 = {}

		for _, descendant in instance:GetDescendants() do
			local v4 = Constants.CONTENT_ID_FIELDS[descendant.ClassName]

			if not v4 then
				continue
			end

			for _, v5 in v4 do
				v3[getFullNameWithoutRootFolder(descendant, item) .. "." .. v5] = descendant[v5] -- inferred equivalent call
			end
		end

		if v2 then
			v:updateReasons(compareFolderInfo(v2, v3, data))
			v:updateReasons(compareFolderInfo(v3, v2, data))
		else
			v2 = v3
		end
	end

	return v:getFinalResults()
end

local function validateR6Folder(instance, assetTypeEnum, data)
	local v = FailureReasonsAccumulator.new()

	if #instance:GetChildren() > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_R6FolderHasChildren, nil, data)
		v:updateReasons(false, {
			string.format(
				"Deprecated R6 folder for '%s' should be empty. You need to clear that folder and try again.",
				assetTypeEnum.Name
			)
		})
	end

	v:updateReasons(validateTags(instance, data))

	return v:getFinalResults()
end

local function validateLimbsAndTorso(data)
	assert(data.instances ~= nil, "instances required in validationContext for validateLimbsAndTorso")
	local instances = data.instances

	assert(data.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateLimbsAndTorso")

	local requireAllFolders = data.requireAllFolders
	local assetTypeEnum = data.assetTypeEnum

	local v = { Constants.FOLDER_NAMES.R15ArtistIntent }

	if requireAllFolders then
		table.insert(v, Constants.FOLDER_NAMES.R15Fixed)
		table.insert(v, Constants.FOLDER_NAMES.R6)
	end

	if not areTopLevelFoldersCorrect(instances, v) then
		Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_TopLevelFolders, nil, data)

		return false, { "Incorrect hierarchy for asset with the following missing folders: " .. table.concat(v, ", ") }
	end

	for _, v2 in v do
		local instance = getInstance(instances, v2) -- inferred equivalent call
		local selected, v3

		if v2 == Constants.FOLDER_NAMES.R6 then
			selected, v3 = validateR6Folder(instance, assetTypeEnum, data)
		else
			selected, v3 = validateMeshPartBodyPart(instance, createLimbsAndTorsoSchema(assetTypeEnum, v2, data), data)
		end

		if not selected then
			return selected, v3
		end
	end

	return validateFolderAssetIdsMatch(instances, v, data)
end

return validateLimbsAndTorso
