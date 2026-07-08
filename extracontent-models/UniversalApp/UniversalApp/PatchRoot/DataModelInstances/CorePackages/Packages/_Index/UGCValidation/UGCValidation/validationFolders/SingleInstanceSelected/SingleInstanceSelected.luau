local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local t1 = {}
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

t1.categories = Constants.AllAssetUploadCategories
t1.requiredData = {
	ValidationEnums.SharedDataMember.entrypointInput,
	ValidationEnums.SharedDataMember.consumerConfig,
	ValidationEnums.SharedDataMember.uploadEnum
}

local function deepEquals(_, _) -- line: 16
	return true
end
local function getFoldersMapping(t2: {[any]: any}) -- line: 21
	local t3 = {
		R15ArtistIntent = true,
		R15Fixed = true,
		R6 = true
	}
	local t4 = {}

	for _, v14 in t2 do
		if v14:IsA("Folder") and t3[v14.Name] then
			t4[v14.Name] = v14
		end
	end

	return t4
end

function t1.run(p3, p4) -- line: 38
	-- upvalues: Constants (copy), ErrorSourceStrings (copy), getFoldersMapping (copy)
	local entrypointInput = p4.entrypointInput
	local consumerConfig = p4.consumerConfig
	local assetType = p4.uploadEnum.assetType

	if Constants.AssetUploadsWithFolderStructure[assetType] and consumerConfig.enforceR15FolderStructure then
		if #entrypointInput ~= 3 then
			p3:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)

			return
		end

		local v20 = getFoldersMapping(entrypointInput)
		local g21 = nil

		repeat
			if g21 or (not v20.R15ArtistIntent or not v20.R15Fixed or not v20.R6 or #v20.R6:GetChildren() ~= 0) then
				g21 = false
				p3:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)

				return
			end

			local _ = v20.R15ArtistIntent
			local _ = v20.R15Fixed

			if not true then
				g21 = true
			end
		until not g21
	elseif #entrypointInput ~= 1 then
		p3:fail(ErrorSourceStrings.Keys.SelectionCountNotOne)
	end
end

return t1
