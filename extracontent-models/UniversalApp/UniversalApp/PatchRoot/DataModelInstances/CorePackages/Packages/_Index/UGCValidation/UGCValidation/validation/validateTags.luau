local CollectionService = game:GetService("CollectionService")

local parent = script.Parent.Parent
local Analytics = require(parent.Analytics)

require(parent.util.Types)

local function validateTags(folder, p)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	local descendants2 = {}

	for _, descendant in ipairs(descendants) do
		if #CollectionService:GetTags(descendant) > 0 then
			table.insert(descendants2, descendant)
		end
	end

	if #descendants2 > 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateTags, nil, p)

		return false, {}
	end

	return true
end

return validateTags
