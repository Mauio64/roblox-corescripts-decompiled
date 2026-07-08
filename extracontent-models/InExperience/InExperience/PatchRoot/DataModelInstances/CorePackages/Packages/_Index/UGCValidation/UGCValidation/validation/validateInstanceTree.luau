local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local validateWithSchema = require(ParentParent.util.validateWithSchema)

require(ParentParent.util.Types)

local function validateInstanceTree(p1, p2, p3) -- line: 9
	-- upvalues: validateWithSchema (copy), Analytics (copy), Constants (copy)
	local v9 = validateWithSchema(p1, p2, p3)

	if v9.success == false then
		Analytics.reportFailure(Analytics.ErrorType.validateInstanceTree, nil, p3)

		return false, { "Detected the following error(s): " .. v9.message }
	end

	local t1 = {}

	if Constants.BANNED_NAMES[p2.Name] then
		table.insert(t1, string.format("%s has an invalid name", p2:GetFullName()))
	end

	for _, descendant in pairs(p2:GetDescendants()) do
		for _, v in pairs(Constants.BANNED_CLASS_NAMES) do
			if descendant:IsA(v) then
				table.insert(t1, string.format("%s is of type %s which is not allowed", descendant:GetFullName(), v))
			end
		end

		if Constants.BANNED_NAMES[descendant.Name] then
			table.insert(t1, string.format("%s has an invalid name", descendant:GetFullName()))
		end
	end

	if #t1 > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateInstanceTree_InvalidDescendants, nil, p3)

		return false, t1
	end

	return true
end

return validateInstanceTree
