local parent = script:FindFirstAncestor("UserProfiles").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local createIsRobloxSubscriberGetter = require(script.Parent.createIsRobloxSubscriberGetter)

local function useIsRobloxSubscriberBinding(p: string?)
	local v = React.useMemo(function()
		return createIsRobloxSubscriberGetter(p)
	end, { p })

	return SignalsReact.useSignalBinding(v)
end

return useIsRobloxSubscriberBinding
