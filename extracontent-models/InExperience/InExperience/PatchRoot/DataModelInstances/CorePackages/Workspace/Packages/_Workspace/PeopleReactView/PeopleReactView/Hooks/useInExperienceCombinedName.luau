local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)

local function useInExperienceCombinedName(p: number, p2: string)
	local v = useGetPeopleService("PeopleListStore")

	local v2 = React.useMemo(function()
		return v.getProfile(p)
	end, { p })

	return SignalsReact.useSignalBinding(v2):map(function(value)
		return if value and string.len(value) > 0 then value else p2
	end)
end

return useInExperienceCombinedName
