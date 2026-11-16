local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserProfile = require(parent.DataHydration.UserProfile)

local signal = Signals.createSignal(nil)

return {
	useUserInfo = function(value: string?)
		local v = React.useMemo(function()
			if value == nil then
				return nil
			end

			return UserProfile.getAndFetchUserInfo(value)
		end, { value or "" })

		local useSignalState = SignalsReact.useSignalState
		local v2 = if v == nil then signal else v.info
		local v3 = useSignalState(v2)
		local useSignalState2 = SignalsReact.useSignalState
		local v4 = if v == nil then signal else v.status
		local v5 = useSignalState2(v4)

		if value == nil then
			return nil
		end

		return {
			displayName = v3 == nil and "" or v3.displayName,
			username = v3 == nil and "" or v3.username,
			isLoading = v5 == "NotReady"
		}
	end
}
