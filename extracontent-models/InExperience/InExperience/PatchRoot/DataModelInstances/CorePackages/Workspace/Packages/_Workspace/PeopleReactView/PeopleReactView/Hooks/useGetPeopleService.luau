local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)
local PeopleService = require(parent.PeopleService)

local function useGetPeopleService(p: string)
	return (React.useMemo(function()
		return PeopleService.getService(p)
	end, {}))
end

return useGetPeopleService
