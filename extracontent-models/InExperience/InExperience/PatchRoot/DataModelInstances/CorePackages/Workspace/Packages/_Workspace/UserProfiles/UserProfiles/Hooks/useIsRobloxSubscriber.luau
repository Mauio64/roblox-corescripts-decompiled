local parent = script:FindFirstAncestor("UserProfiles").Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local createIsRobloxSubscriberGetter = require(script.Parent.createIsRobloxSubscriberGetter)

local function useIsRobloxSubscriber(p: string?)
	return (useSignalState((React.useMemo(function()
		return createIsRobloxSubscriberGetter(p)
	end, { p }))))
end

return useIsRobloxSubscriber
