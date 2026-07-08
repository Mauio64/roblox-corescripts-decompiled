local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)

local function useInExperienceCombinedName(n1: number, s1: string) -- line: 9
	-- upvalues: useGetPeopleService (copy), React (copy), SignalsReact (copy)
	local v9 = useGetPeopleService("PeopleListStore")
	local v10 = React.useMemo(function() -- line: 12
		-- upvalues: v9 (copy), n1 (copy)
		return v9.getProfile(n1)
	end, { n1 })

	return SignalsReact.useSignalBinding(v10):map(function(p1) -- line: 18
		-- upvalues: s1 (copy)
		if p1 and string.len(p1) > 0 then
			return p1
		end

		return s1
	end)
end

return useInExperienceCombinedName
