local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SignalsReact")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/UserProfiles").Stores.UserProfileStore.get()

return function(p2)
	local v6 = React.useMemo(function()
		if p2 == "" then
			return function(): string
				return ""
			end
		end

		return Signals.createComputed(function(p3)
			local v7 = v5.fetchNamesByUserIds({ p2 })(p3)
			local v8 = v7 and v7.data and v7.data[1]
			local names = v8 and v8.names

			if names then
				return names.getCombinedName(p3) or ""
			end

			return ""
		end)
	end, { p2 })

	return SignalsReact.useSignalState(v6) or ""
end
