local CollectionService = game:GetService("CollectionService")
local ParentParent = script.Parent.Parent
local getFFlagUGCValidationEnableFolderStructure = require(ParentParent.flags.getFFlagUGCValidationEnableFolderStructure)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function validateTags(p1, p2) -- line: 10
	-- upvalues: CollectionService (copy), Analytics (copy), getFFlagUGCValidationEnableFolderStructure (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local t1 = {}

	for _, v in ipairs(descendants) do
		if #CollectionService:GetTags(v) > 0 then
			table.insert(t1, v)
		end
	end

	if #t1 > 0 then
		local t2 = { "Found the following instance tags which are not allowed:" }

		for _, v in ipairs(t1) do
			table.insert(t2, v:GetFullName())
		end

		Analytics.reportFailure(Analytics.ErrorType.validateTags, nil, p2)

		if getFFlagUGCValidationEnableFolderStructure() and getFFlagUGCValidationCombineEntrypointResults() then
			return false, {}
		end

		return false, t2
	end

	return true
end

return validateTags
