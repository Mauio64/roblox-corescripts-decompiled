local parent = script:FindFirstAncestor("CurrencyTransfers").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local UserProfiles = require(parent.UserProfiles)

local function useUserNameFromUserId(p: number?)
	local v = p and p ~= 0
	local v2 = React.useMemo(function()
		if v and p then
			return UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds({ (tostring(p)) })
		end

		return nil
	end, { v, p })

	local v3 = React.useMemo(function()
		if v2 then
			return (Signals.createComputed(function(p2)
				local v3 = v2(p2)

				if not v3 or v3.status ~= "success" or not v3.data or #v3.data == 0 then
					return nil
				end

				local v4 = v3.data[1]
				local names = v4 and v4.names

				if names then
					return names.getDisplayName(false) or names.getUsername(false) or ""
				end

				return nil
			end))
		end

		return function(_): nil
			return nil
		end
	end, { v2 })

	return SignalsReact.useSignalState(v3)
end

return useUserNameFromUserId
