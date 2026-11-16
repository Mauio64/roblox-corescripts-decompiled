local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)
local validateWithSchema = require(parent.util.validateWithSchema)
require(parent.util.Types)

local function validateInstanceTree(p, folder, p2)
	local v = validateWithSchema(p, folder, p2)

	if v.success == false then
		Analytics.reportFailure(Analytics.ErrorType.validateInstanceTree, nil, p2)
		return false, { "Detected the following error(s): " .. v.message }
	end

	local result = {}

	if Constants.BANNED_NAMES[folder.Name] then
		table.insert(result, string.format("%s has an invalid name", folder:GetFullName()))
	end

	for _, descendant in pairs(folder:GetDescendants()) do
		for _, className in pairs(Constants.BANNED_CLASS_NAMES) do
			if descendant:IsA(className) then
				table.insert(
					result,
					string.format("%s is of type %s which is not allowed", descendant:GetFullName(), className)
				)
			end
		end

		if Constants.BANNED_NAMES[descendant.Name] then
			table.insert(result, string.format("%s has an invalid name", descendant:GetFullName()))
		end
	end

	if #result > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateInstanceTree_InvalidDescendants, nil, p2)
		return false, result
	end

	return true
end

return validateInstanceTree
