local Parent = script:FindFirstAncestor("UserProfiles").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local createIsRobloxSubscriberGetter = require(script.Parent.createIsRobloxSubscriberGetter)

local function useIsRobloxSubscriberBinding(s1: string?) -- line: 10
	-- upvalues: React (copy), createIsRobloxSubscriberGetter (copy), SignalsReact (copy)
	local v7 = React.useMemo(function() -- line: 11
		-- upvalues: createIsRobloxSubscriberGetter (copy), s1 (copy)
		return createIsRobloxSubscriberGetter(s1)
	end, { s1 })

	return SignalsReact.useSignalBinding(v7)
end

return useIsRobloxSubscriberBinding
