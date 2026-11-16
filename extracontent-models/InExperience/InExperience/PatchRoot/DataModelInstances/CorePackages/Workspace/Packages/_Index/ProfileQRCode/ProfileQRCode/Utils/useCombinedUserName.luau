local parent = script:FindFirstAncestor("ProfileQRCode").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserProfiles = require(parent.UserProfiles)

local v = UserProfiles.Stores.UserProfileStore.get()

return function(p: string)
	local v2 = React.useMemo(function()
		if p == "" then
			return function(): string
				return ""
			end
		end

		return Signals.createComputed(function(p2)
			local v2 = v.fetchNamesByUserIds({ p })(p2)
			local v3 = v2 and v2.data and v2.data[1]
			local names = v3 and v3.names

			if names then
				return names.getCombinedName(p2) or ""
			end

			return ""
		end)
	end, { p })

	return SignalsReact.useSignalState(v2) or ""
end
