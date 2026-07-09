local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function getEventCategory(p1) -- line: 7
	local eventCategories = p1.eventCategories

	if eventCategories == nil or #eventCategories == 0 then
		return nil
	end

	for _, v in ipairs(eventCategories) do
		if v ~= nil and v.rank == 0 then
			return v.category
		end
	end

	return nil
end

return getEventCategory
