local Immutable = require(script.Parent.Parent.Immutable)

local ServerJobsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerJobsUpdateSearchFilter)

return function(p, p2)
	local selected = p or { jobsSearchTerm = "" }

	if p2.type == ServerJobsUpdateSearchFilter.name then
		return (Immutable.Set(selected, "jobsSearchTerm", p2.searchTerm))
	end

	return selected
end
