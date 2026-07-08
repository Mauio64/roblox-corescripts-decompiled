local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local validationFolders = ParentParent.validationFolders
local assetQualityFolders = ParentParent.assetQualityFolders
local t1 = {}
local t2 = {
	ValidationEnums.SharedDataMember.aqsSummaryData,
	ValidationEnums.SharedDataMember.renderMeshesData,
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.outerCagesData,
	ValidationEnums.SharedDataMember.meshTextures
}
local t3 = {}

for _, v10 in ValidationEnums.ValidationModule do
	t3[v10] = validationFolders
end

if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
	for _, v12 in ValidationEnums.AssetQualityCheck do
		t3[v12] = assetQualityFolders
	end
end

local t4 = {}

for v14, v15 in ValidationEnums do
	t4[v14] = {}

	if typeof(v15) == "table" then
		for v16, _ in v15 do
			t4[v14][v16] = true
		end
	end
end

local function tableOnlyHasExistingEnums(s1: string, t5: {[any]: any}, s2: string) -- line: 54
	-- upvalues: t4 (copy)
	if typeof(t5) ~= "table" then
		error(`Invalid config option { s2 } inside of { s1 } - expected to be table`)
	end

	for _, v37 in t5 do
		if not t4[s2][v37] then
			error(`Invalid config option { v37 } in { s2 } inside of { s1 }`)
		end
	end
end
local function defaultFlagCheck() -- line: 66
	return true
end
local function defaultShadowCheck() -- line: 70
	return false
end

local t6 = {}

for v22, v23 in t3 do
	local v24 = v23:FindFirstChild(v22)

	if v24 == nil then
		error(`{ v22 } validation folder is missing from { v23.Name }`)
	end

	local v25 = v24:FindFirstChild(v22)

	if v25 == nil or not v25:IsA("ModuleScript") then
		error(`{ v22 }.lua validation file is missing from { v23.Name }/{ v22 }`)
	end

	local lib = require(v25)

	for v27, _ in lib do
		if typeof(v27) ~= "string" then
			error(`{ v22 }.lua contains non-string key { tostring(v27) }`)
		elseif not t4.ValidationConfig[v27] then
			error(`{ v22 }.lua contains unexpected member { v27 }. Check for typos or add an extra ValidationEnums.ValidationConfig`)
		end
	end

	lib.fflag = lib.fflag or defaultFlagCheck
	lib.shadowFlag = lib.shadowFlag or defaultShadowCheck
	lib.categories = lib.categories or {}
	lib.requiredData = lib.requiredData or {}
	lib.conditionalData = lib.conditionalData or {}
	lib.prereqTests = lib.prereqTests or {}
	lib.expectedFailures = lib.expectedFailures or {}
	lib.expectedAqsData = lib.expectedAqsData or {}
	lib.knownAqsUserErrors = lib.knownAqsUserErrors or {}
	lib.isAssetQualityModule = v23 == assetQualityFolders

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		if lib.isAssetQualityModule then
			for _, v30 in t2 do
				if not table.find(lib.requiredData, v30) then
					table.insert(lib.requiredData, v30)
				end
			end
		end
	elseif next(lib.expectedAqsData) ~= nil then
		for _, v32 in t2 do
			if not table.find(lib.requiredData, v32) then
				table.insert(lib.requiredData, v32)
			end
		end
	end

	if lib.run == nil or typeof(lib.run) ~= "function" then
		error(`Missing module run function in { v22 }`)
	end

	setmetatable(lib, {
		__index = function(_, p2) -- line: 136
			-- upvalues: v22 (copy)
			error(`Invalid ValidationConfig { p2 } used on the module { v22 }`)
		end
	})

	if typeof(lib.fflag) ~= "function" or typeof(lib.fflag()) ~= "boolean" then
		error(`Invalid FFlag config in { v22 }`)
	end

	if typeof(lib.shadowFlag) ~= "function" or typeof(lib.shadowFlag()) ~= "boolean" then
		error(`Invalid shadowFlag config in { v22 }`)
	end

	tableOnlyHasExistingEnums(v22, lib.categories, "UploadCategory")
	tableOnlyHasExistingEnums(v22, lib.requiredData, "SharedDataMember")
	tableOnlyHasExistingEnums(v22, lib.conditionalData, "SharedDataMember")
	tableOnlyHasExistingEnums(v22, lib.prereqTests, "ValidationModule")
	t6[v22] = lib
end

t1.allModules = t6

function t1.getValidationModule(s3: string) -- line: 159
	-- upvalues: t6 (copy)
	if t6[s3] == nil then
		error(`{ s3 } does not exist in the preload table.`)
	end

	return t6[s3]
end

return t1
