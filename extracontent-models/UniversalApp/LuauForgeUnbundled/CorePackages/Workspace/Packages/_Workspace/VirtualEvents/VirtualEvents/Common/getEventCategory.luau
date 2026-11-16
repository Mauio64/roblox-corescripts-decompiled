require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")

local function getEventCategory(p2)
	local eventCategories = p2.eventCategories

	if eventCategories == nil or #eventCategories == 0 then
		return nil
	end

	for i, eventCategory in ipairs(eventCategories) do
		if eventCategory ~= nil and eventCategory.rank == 0 then
			return eventCategory.category
		end
	end

	return nil
end

return getEventCategory
