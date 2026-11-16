local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function getEventCategory(p)
	local eventCategories = p.eventCategories

	if eventCategories == nil or #eventCategories == 0 then
		return nil
	end

	for _, eventCategory in ipairs(eventCategories) do
		if eventCategory ~= nil and eventCategory.rank == 0 then
			return eventCategory.category
		end
	end

	return nil
end

return getEventCategory
