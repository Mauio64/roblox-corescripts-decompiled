require("@luauforge/deferred/eaT")

return function(items)
	local experienceIdSet = {}
	local experienceIds = {}

	for k, item in pairs(items) do
		local experienceId = tostring(item.experienceContext.experienceId)

		if experienceIdSet[experienceId] then
			continue
		end

		table.insert(experienceIds, experienceId)
		experienceIdSet[experienceId] = true
	end

	return experienceIds
end
