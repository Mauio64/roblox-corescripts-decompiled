local Parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local UserProfiles = require(Parent.UserProfiles)

local function useUserNameFromUserId(n1: number?) -- line: 18
	-- upvalues: React (copy), UserProfiles (copy), Signals (copy), SignalsReact (copy)
	local v8 = n1 and n1 ~= 0
	local v9 = React.useMemo(function() -- line: 21
		-- upvalues: v8 (copy), n1 (copy), UserProfiles (copy)
		if not v8 or not n1 then
			return nil
		end

		return UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds({ (tostring(n1)) })
	end, {
		v8,
		n1
	})
	local v10 = React.useMemo(function() -- line: 30
		-- upvalues: v9 (copy), Signals (copy)
		if not v9 then
			return function(_) -- line: 32
				return nil
			end
		end

		return (Signals.createComputed(function(p2) -- line: 36
			-- upvalues: v9 (copy)
			local v13 = v9(p2)

			if not v13 or (v13.status ~= "success" or not v13.data or #v13.data == 0) then
				return nil
			end

			local v14 = v13.data[1]
			local v15 = v14 and v14.names

			if not v15 then
				return nil
			end

			return v15.getDisplayName(false) or (v15.getUsername(false) or "")
		end))
	end, { v9 })

	return SignalsReact.useSignalState(v10)
end

return useUserNameFromUserId
