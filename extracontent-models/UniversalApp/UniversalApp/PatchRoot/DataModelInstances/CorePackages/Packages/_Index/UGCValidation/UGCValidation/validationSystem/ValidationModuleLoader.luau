local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
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

for _, v9 in ValidationEnums.ValidationModule do
	t3[v9] = validationFolders
end

for _, v11 in ValidationEnums.AssetQualityCheck do
	t3[v11] = assetQualityFolders
end

local t4 = {}

for v13, v14 in ValidationEnums do
	t4[v13] = {}

	if typeof(v14) == "table" then
		for v15, _ in v14 do
			t4[v13][v15] = true
		end
	end
end

local function tableOnlyHasExistingEnums(s1: string, t5: {[any]: any}, s2: string) -- line: 50
	-- upvalues: t4 (copy)
	if typeof(t5) ~= "table" then
		error(`Invalid config option { s2 } inside of { s1 } - expected to be table`)
	end

	for _, v34 in t5 do
		if not t4[s2][v34] then
			error(`Invalid config option { v34 } in { s2 } inside of { s1 }`)
		end
	end
end
local function defaultFlagCheck() -- line: 62
	return true
end
local function defaultShadowCheck() -- line: 66
	return false
end

local t6 = {}

for v21, v22 in t3 do
	local v23 = v22:FindFirstChild(v21)

	if v23 == nil then
		error(`{ v21 } validation folder is missing from { v22.Name }`)
	end

	local v24 = v23:FindFirstChild(v21)

	if v24 == nil or not v24:IsA("ModuleScript") then
		error(`{ v21 }.lua validation file is missing from { v22.Name }/{ v21 }`)
	end

	local lib = require(v24)

	for v26, _ in lib do
		if typeof(v26) ~= "string" then
			error(`{ v21 }.lua contains non-string key { tostring(v26) }`)
		elseif not t4.ValidationConfig[v26] then
			error(`{ v21 }.lua contains unexpected member { v26 }. Check for typos or add an extra ValidationEnums.ValidationConfig`)
		end
	end

	lib.fflag = lib.fflag or defaultFlagCheck
	lib.shadowFlag = lib.shadowFlag or defaultShadowCheck
	lib.categories = lib.categories or {}
	lib.requiredData = lib.requiredData or {}
	lib.conditionalData = lib.conditionalData or {}
	lib.prereqTests = lib.prereqTests or {}
	lib.expectedFailures = lib.expectedFailures or {}
	lib.knownAqsUserErrors = lib.knownAqsUserErrors or {}
	lib.isAssetQualityModule = v22 == assetQualityFolders

	if lib.isAssetQualityModule then
		for _, v29 in t2 do
			if not table.find(lib.requiredData, v29) then
				table.insert(lib.requiredData, v29)
			end
		end
	end

	if lib.run == nil or typeof(lib.run) ~= "function" then
		error(`Missing module run function in { v21 }`)
	end

	setmetatable(lib, {
		__index = function(_, p2) -- line: 123
			-- upvalues: v21 (copy)
			error(`Invalid ValidationConfig { p2 } used on the module { v21 }`)
		end
	})

	if typeof(lib.fflag) ~= "function" or typeof(lib.fflag()) ~= "boolean" then
		error(`Invalid FFlag config in { v21 }`)
	end

	if typeof(lib.shadowFlag) ~= "function" or typeof(lib.shadowFlag()) ~= "boolean" then
		error(`Invalid shadowFlag config in { v21 }`)
	end

	tableOnlyHasExistingEnums(v21, lib.categories, "UploadCategory")
	tableOnlyHasExistingEnums(v21, lib.requiredData, "SharedDataMember")
	tableOnlyHasExistingEnums(v21, lib.conditionalData, "SharedDataMember")
	tableOnlyHasExistingEnums(v21, lib.prereqTests, "ValidationModule")
	t6[v21] = lib
end

t1.allModules = t6

function t1.getValidationModule(s3: string) -- line: 146
	-- upvalues: t6 (copy)
	if t6[s3] == nil then
		error(`{ s3 } does not exist in the preload table.`)
	end

	return t6[s3]
end

return t1
