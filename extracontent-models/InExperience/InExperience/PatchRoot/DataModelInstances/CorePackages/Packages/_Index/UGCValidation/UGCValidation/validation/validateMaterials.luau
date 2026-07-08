local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

local function validateMaterials(p1, p2) -- line: 9
	-- upvalues: Constants (copy), Analytics (copy)
	local t1 = {}
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	for _, v10 in descendants do
		if v10:IsA("BasePart") and not Constants.MATERIAL_WHITELIST[v10.Material] then
			table.insert(t1, v10:GetFullName())
		end
	end

	if #t1 > 0 then
		local t2 = {}
		local t3 = {}

		for k in pairs(Constants.MATERIAL_WHITELIST) do
			table.insert(t3, k.Name)
		end

		table.insert(t2, "Invalid material setup for")

		for _, v in pairs(t1) do
			table.insert(t2, v)
		end

		table.insert(t2, "Accepted values are: " .. table.concat(t3, ", "))
		Analytics.reportFailure(Analytics.ErrorType.validateMaterials, nil, p2)

		return false, t2
	end

	return true
end

return validateMaterials
