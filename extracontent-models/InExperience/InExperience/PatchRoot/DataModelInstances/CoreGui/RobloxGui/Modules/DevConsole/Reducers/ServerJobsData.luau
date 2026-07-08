local Immutable = require(script.Parent.Parent.Immutable)
local ServerJobsUpdateSearchFilter = require(script.Parent.Parent.Actions.ServerJobsUpdateSearchFilter)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 9
	-- upvalues: ServerJobsUpdateSearchFilter (copy), Immutable (copy)
	local v5 = t1 or {
		jobsSearchTerm = ""
	}

	if t2.type == ServerJobsUpdateSearchFilter.name then
		return (Immutable.Set(v5, "jobsSearchTerm", t2.searchTerm))
	end

	return v5
end
