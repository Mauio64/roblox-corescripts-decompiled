local parent = script.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local getFFlagUGCValidateAQSRequiresOnlySummary = require(parent.flags.getFFlagUGCValidateAQSRequiresOnlySummary)

local validationFolders = parent.validationFolders
local assetQualityFolders = parent.assetQualityFolders

local v = {
	ValidationEnums.SharedDataMember.aqsSummaryData,
	ValidationEnums.SharedDataMember.renderMeshesData,
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.outerCagesData,
	ValidationEnums.SharedDataMember.meshTextures
}

local v2 = {}
local ValidationModuleLoader = {}

for _, v3 in ValidationEnums.ValidationModule do
	v2[v3] = validationFolders
end

for _, v3 in ValidationEnums.AssetQualityCheck do
	v2[v3] = assetQualityFolders
end

local v3 = {}

for k, validationEnum in ValidationEnums do
	v3[k] = {}

	if typeof(validationEnum) ~= "table" then
		continue
	end

	for k2, _ in validationEnum do
		v3[k][k2] = true
	end
end

local function tableOnlyHasExistingEnums(childName: string, items, p: string)
	if typeof(items) ~= "table" then
		error(`Invalid config option {p} inside of {childName} - expected to be table`)
	end

	for _, item in items do
		if not v3[p][item] then
			error(`Invalid config option {item} in {p} inside of {childName}`)
		end
	end
end

local function defaultFlagCheck(): boolean
	return true
end

local function defaultShadowCheck(): boolean
	return false
end

local modulesByChildName = {}

for childName, v4 in v2 do
	local child = v4:FindFirstChild(childName)

	if child == nil then
		error(`{childName} validation folder is missing from {v4.Name}`)
	end

	local moduleScript = child:FindFirstChild(childName)

	if moduleScript == nil or not moduleScript:IsA("ModuleScript") then
		error(`{childName}.lua validation file is missing from {v4.Name}/{childName}`)
	end

	local module = require(moduleScript)

	for k, _ in module do
		if typeof(k) == "string" then
			if not v3.ValidationConfig[k] then
				error(`{childName}.lua contains unexpected member {k}. Check for typos or add an extra ValidationEnums.ValidationConfig`)
			end
		else
			error(`{childName}.lua contains non-string key {tostring(k)}`)
		end
	end

	module.fflag = module.fflag or defaultFlagCheck
	module.shadowFlag = module.shadowFlag or defaultShadowCheck
	module.categories = module.categories or {}
	module.requiredData = module.requiredData or {}
	module.conditionalData = module.conditionalData or {}
	module.prereqTests = module.prereqTests or {}
	module.expectedFailures = module.expectedFailures or {}
	module.knownAqsUserErrors = module.knownAqsUserErrors or {}

	module.isAssetQualityModule = v4 == assetQualityFolders

	if module.isAssetQualityModule then
		for _, v5 in getFFlagUGCValidateAQSRequiresOnlySummary() and { ValidationEnums.SharedDataMember.aqsSummaryData } or v do
			if not table.find(module.requiredData, v5) then
				table.insert(module.requiredData, v5)
			end
		end
	end

	if module.run == nil or typeof(module.run) ~= "function" then
		error(`Missing module run function in {childName}`)
	end

	setmetatable(module, {
		__index = function(_, p)
			error(`Invalid ValidationConfig {p} used on the module {childName}`)
		end
	})

	if typeof(module.fflag) ~= "function" or typeof(module.fflag()) ~= "boolean" then
		error(`Invalid FFlag config in {childName}`)
	end

	if typeof(module.shadowFlag) ~= "function" or typeof(module.shadowFlag()) ~= "boolean" then
		error(`Invalid shadowFlag config in {childName}`)
	end

	tableOnlyHasExistingEnums(childName, module.categories, "UploadCategory")
	tableOnlyHasExistingEnums(childName, module.requiredData, "SharedDataMember")
	tableOnlyHasExistingEnums(childName, module.conditionalData, "SharedDataMember")
	tableOnlyHasExistingEnums(childName, module.prereqTests, "ValidationModule")

	modulesByChildName[childName] = module
end

ValidationModuleLoader.allModules = modulesByChildName

function ValidationModuleLoader.getValidationModule(p: string)
	if modulesByChildName[p] == nil then
		error(`{p} does not exist in the preload table.`)
	end

	return modulesByChildName[p]
end

return ValidationModuleLoader
