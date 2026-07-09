local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local v5 = require(Parent.UserProfiles).Stores.UserProfileStore.get()

return function(s1: string) -- line: 11
	-- upvalues: React (copy), Signals (copy), v5 (copy), SignalsReact (copy)
	local v7 = React.useMemo(function() -- line: 12
		-- upvalues: s1 (copy), Signals (copy), v5 (copy)
		if s1 == "" then
			return function() -- line: 14
				return ""
			end
		end

		return Signals.createComputed(function(p1) -- line: 19
			-- upvalues: v5 (copy), s1 (copy)
			local v9 = v5.fetchNamesByUserIds({ s1 })(p1)
			local v10 = v9 and (v9.data and v9.data[1])
			local v11 = v10 and v10.names

			if v11 then
				return v11.getCombinedName(p1) or ""
			end

			return ""
		end)
	end, { s1 })

	return SignalsReact.useSignalState(v7) or ""
end
