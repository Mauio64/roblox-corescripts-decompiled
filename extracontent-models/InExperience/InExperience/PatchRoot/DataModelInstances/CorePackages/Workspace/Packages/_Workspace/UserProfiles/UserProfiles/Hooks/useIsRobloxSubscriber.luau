local UserProfiles = script:FindFirstAncestor("UserProfiles")
local UserProfilesParent = UserProfiles.Parent
local React = require(UserProfilesParent.React)
local Signals = require(UserProfilesParent.Signals)
local SignalsReact = require(UserProfilesParent.SignalsReact)
local createComputed = Signals.createComputed
local useSignalState = SignalsReact.useSignalState
local FFlagEnableBlackbirdCheck = require(UserProfilesParent.SharedFlags).FFlagEnableBlackbirdCheck
local v9 = game:DefineFastFlag("UserProfilesUseIsRobloxSubscriberGetter", false)
local UserProfileStore = require(UserProfiles.Stores.UserProfileStore)
local createIsRobloxSubscriberGetter = require(script.Parent.createIsRobloxSubscriberGetter)

local function useIsRobloxSubscriber(s1: string?) -- line: 20
	-- upvalues: React (copy), v9 (copy), createIsRobloxSubscriberGetter (copy), FFlagEnableBlackbirdCheck (copy), createComputed (copy), UserProfileStore (copy), useSignalState (copy)
	local v14 = React.useMemo(function() -- line: 21
		-- upvalues: v9 (copy), createIsRobloxSubscriberGetter (copy), s1 (copy), FFlagEnableBlackbirdCheck (copy), createComputed (copy), UserProfileStore (copy)
		if v9 then
			return createIsRobloxSubscriberGetter(s1)
		end

		if not FFlagEnableBlackbirdCheck or (s1 == nil or s1 == "") then
			return createComputed(function() -- line: 28
				return false
			end)
		end

		local v15 = UserProfileStore.get().fetchNamesByUserIds({ s1 })

		return createComputed(function(p1) -- line: 36
			-- upvalues: v15 (copy)
			local ok, result = pcall(v15, p1)

			if ok and (result.status == "success" and #result.data > 0) then
				local v19 = result.data[1]

				if v19.getHasRobloxSubscription ~= nil then
					return (v19.getHasRobloxSubscription(p1))
				end
			end

			return false
		end)
	end, { s1 })

	return (useSignalState(v14))
end

return useIsRobloxSubscriber
