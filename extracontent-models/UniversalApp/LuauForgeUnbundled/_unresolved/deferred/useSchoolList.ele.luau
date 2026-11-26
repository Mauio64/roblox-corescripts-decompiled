local module = require("@luauforge/deferred/eko")

local module2 = require("@luauforge/deferred/elf")
require("@luauforge/deferred/ekr")

local function useSchoolList(p2)
	local schools = p2.schools
	local state, setState = module.useState("")

	return {
		schools = module.useMemo(function()
			if state == "" then
				return schools
			end

			local schools2 = {}

			for k, school in schools do
				if module2(school, state) then
					table.insert(schools2, school)
				end
			end

			return schools2
		end, { schools, state }),
		query = state,
		setQuery = setState
	}
end

return useSchoolList
