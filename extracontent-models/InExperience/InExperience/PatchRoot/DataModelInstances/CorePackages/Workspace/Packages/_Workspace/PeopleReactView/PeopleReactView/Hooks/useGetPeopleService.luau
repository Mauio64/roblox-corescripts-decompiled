local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local React = require(Parent.React)
local PeopleService = require(Parent.PeopleService)

local function useGetPeopleService(s1: string) -- line: 7
	-- upvalues: React (copy), PeopleService (copy)
	return (React.useMemo(function() -- line: 8
		-- upvalues: PeopleService (copy), s1 (copy)
		return PeopleService.getService(s1)
	end, {}))
end

return useGetPeopleService
