local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local validateMeshPartBodyPart = require(ParentParent.validation.validateMeshPartBodyPart)
local validateTags = require(ParentParent.validation.validateTags)
local validatePropertyRequirements = require(ParentParent.validation.validatePropertyRequirements)
local validateAttributes = require(ParentParent.validation.validateAttributes)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local createLimbsAndTorsoSchema = require(ParentParent.util.createLimbsAndTorsoSchema)

require(ParentParent.util.Types)

local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)

local function getInstance(t1: {[any]: any}, s1: string) -- line: 18
	for _, v in pairs(t1) do
		if s1 == v.Name then
			return v
		end
	end

	return nil
end
local function areTopLevelFoldersCorrect(t2: {[any]: any}, t3: {[any]: any}) -- line: 27
	if #t2 ~= #t3 then
		return false
	end

	local g30 = nil
	local v29 = nil

	for _, v26 in t3 do
		for _, v in pairs(t2) do
			if v26 == v.Name then
				v29 = v
				g30 = true
			end

			if g30 then
				break
			end
		end

		if not g30 then
			v29 = nil
		end

		g30 = false

		if not v29 or v29.ClassName ~= "Folder" then
			return false
		end
	end

	return true
end
local function getFullNameWithoutRootFolder(p1, s2: string) -- line: 41
	local FullName = p1:GetFullName()
	local start, stop = string.find(FullName, s2 .. "%.")

	assert(start and stop)

	return (string.sub(FullName, stop + 1, #FullName))
end
local function compareFolderInfo(p2, p3, p4) -- line: 48
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy)
	local v39 = FailureReasonsAccumulator.new()

	for v40, v41 in p2 do
		if p3[v40] == nil or v41 ~= p3[v40] then
			Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_FolderInfoMismatch, nil, p4)
			v39:updateReasons(false, { `Attribute { v40 } has different values in different children folders. You need to use the same value in all folders.` })
		end
	end

	return v39:getFinalResults()
end
local function validateFolderAssetIdsMatch(t4: {[any]: any}, t5: {[any]: any}, p5) -- line: 70
	-- upvalues: FailureReasonsAccumulator (copy), Constants (copy), compareFolderInfo (copy)
	if #t5 == 1 then
		return true
	end

	local v45 = nil
	local v46 = FailureReasonsAccumulator.new()
	local g52 = nil
	local v51 = nil

	for _, v48 in t5 do
		if v48 ~= Constants.FOLDER_NAMES.R6 then
			for _, v in pairs(t4) do
				if v48 == v.Name then
					v51 = v
					g52 = true
				end

				if g52 then
					break
				end
			end

			if not g52 then
				v51 = nil
			end

			g52 = false
			assert(v51)

			local t6 = {}

			for _, descendant in v51:GetDescendants() do
				local v56 = Constants.CONTENT_ID_FIELDS[descendant.ClassName]

				if v56 then
					for _, v58 in v56 do
						local FullName = descendant:GetFullName()
						local start, stop = string.find(FullName, v48 .. "%.")

						assert(start and stop)
						t6[string.sub(FullName, stop + 1, #FullName) .. "." .. v58] = descendant[v58]
					end
				end
			end

			if not v45 then
				v45 = t6
			else
				v46:updateReasons(compareFolderInfo(v45, t6, p5))
				v46:updateReasons(compareFolderInfo(t6, v45, p5))
			end
		end
	end

	return v46:getFinalResults()
end
local function validateR6Folder(p6, p7, p8) -- line: 113
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy), validateTags (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validatePropertyRequirements (copy), validateAttributes (copy)
	local v65 = FailureReasonsAccumulator.new()

	if #p6:GetChildren() > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_R6FolderHasChildren, nil, p8)
		v65:updateReasons(false, { string.format("Deprecated R6 folder for '%s' should be empty. You need to clear that folder and try again.", p7.Name) })
	end

	v65:updateReasons(validateTags(p6, p8))

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v65:updateReasons(validatePropertyRequirements(p6, p7, p8))
		v65:updateReasons(validateAttributes(p6, p8))
	end

	return v65:getFinalResults()
end
local function validateLimbsAndTorso(p9) -- line: 141
	-- upvalues: Constants (copy), areTopLevelFoldersCorrect (copy), Analytics (copy), validateR6Folder (copy), validateMeshPartBodyPart (copy), createLimbsAndTorsoSchema (copy), validateFolderAssetIdsMatch (copy)
	assert(p9.instances ~= nil, "instances required in validationContext for validateLimbsAndTorso")

	local instances = p9.instances

	assert(p9.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateLimbsAndTorso")

	local requireAllFolders = p9.requireAllFolders
	local assetTypeEnum = p9.assetTypeEnum
	local t7 = { Constants.FOLDER_NAMES.R15ArtistIntent }
	local g76 = nil
	local v75 = nil

	if requireAllFolders then
		table.insert(t7, Constants.FOLDER_NAMES.R15Fixed)
		table.insert(t7, Constants.FOLDER_NAMES.R6)
	end

	if not areTopLevelFoldersCorrect(instances, t7) then
		Analytics.reportFailure(Analytics.ErrorType.validateLimbsAndTorso_TopLevelFolders, nil, p9)

		return false, { "Incorrect hierarchy for asset with the following missing folders: " .. table.concat(t7, ", ") }
	end

	for _, v72 in t7 do
		for _, v in pairs(instances) do
			if v72 == v.Name then
				v75 = v
				g76 = true
			end

			if g76 then
				break
			end
		end

		if not g76 then
			v75 = nil
		end

		g76 = false

		local v77, v78

		if v72 == Constants.FOLDER_NAMES.R6 then
			v77, v78 = validateR6Folder(v75, assetTypeEnum, p9)
		else
			v77, v78 = validateMeshPartBodyPart(v75, createLimbsAndTorsoSchema(assetTypeEnum, v72, p9), p9)
		end

		if not v77 then
			return v77, v78
		end
	end

	return validateFolderAssetIdsMatch(instances, t7, p9)
end

return validateLimbsAndTorso
