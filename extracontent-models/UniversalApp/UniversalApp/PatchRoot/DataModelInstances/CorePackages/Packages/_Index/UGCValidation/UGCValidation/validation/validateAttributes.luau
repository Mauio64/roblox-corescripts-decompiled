local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local function hasOnlyAllowedAttribute(p1, p2) -- line: 13
	-- upvalues: Constants (copy)
	for v8, v9 in p1 do
		if p2 and v8 == Constants.AlternateMeshIdAttributeName then
			continue
		end

		if v8 ~= Constants.GUIDAttributeName then
			return false
		end

		if typeof(v9) ~= "string" then
			return false
		end

		if string.len(v9) > Constants.GUIDAttributeMaxLength then
			return false
		end
	end

	return true
end
local function validateAttributes(p3, p4) -- line: 35
	-- upvalues: hasOnlyAllowedAttribute (copy), Constants (copy), Analytics (copy)
	local allowEditableInstances = p4.allowEditableInstances
	local t1 = {}

	if not hasOnlyAllowedAttribute(p3:GetAttributes(), allowEditableInstances) then
		table.insert(t1, p3:GetFullName())
	end

	for _, descendant in ipairs(p3:GetDescendants()) do
		if (not allowEditableInstances or not descendant:GetAttribute(Constants.AlternateMeshIdAttributeName)) and next(descendant:GetAttributes()) ~= nil then
			table.insert(t1, descendant:GetFullName())
		end
	end

	if #t1 > 0 then
		local t2 = {}

		table.insert(t2, string.format("'%s' (or its descendants) contain Attributes. You need to remove Attributes from the following: ", p3.Name))

		for _, v in pairs(t1) do
			table.insert(t2, v)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateAttributes, nil, p4)

		return false, t2
	end

	return true
end

return validateAttributes
