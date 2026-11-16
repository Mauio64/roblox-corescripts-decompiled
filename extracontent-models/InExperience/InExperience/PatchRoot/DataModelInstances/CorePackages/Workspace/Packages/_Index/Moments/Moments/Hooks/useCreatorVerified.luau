local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserProfile = require(parent.DataHydration.UserProfile)

local useSignalState = SignalsReact.useSignalState

return function(p: number)
	local v = useSignalState((React.useMemo(function()
		return UserProfile.getAndFetchUserInfo(p).info
	end, { p })))

	return v ~= nil and v.hasVerifiedBadge
end
