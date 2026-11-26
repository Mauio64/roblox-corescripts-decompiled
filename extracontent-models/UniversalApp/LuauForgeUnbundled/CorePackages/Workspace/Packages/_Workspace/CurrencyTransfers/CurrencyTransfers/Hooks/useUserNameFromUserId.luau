local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UserProfiles")

local function useUserNameFromUserId(p2)
	local v5 = p2 and p2 ~= 0
	local v6 = React.useMemo(function()
		if v5 and p2 then
			return UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds({ (tostring(p2)) })
		end

		return nil
	end, { v5, p2 })

	local v7 = React.useMemo(function()
		if v6 then
			return Signals.createComputed(function(p3)
				local v8 = v6(p3)

				if not v8 or v8.status ~= "success" or not v8.data or #v8.data == 0 then
					return nil
				end

				local v9 = v8.data[1]
				local names = v9 and v9.names

				if names then
					return names.getDisplayName(false) or names.getUsername(false) or ""
				end

				return nil
			end)
		end

		return function(p3): nil
			return nil
		end
	end, { v6 })

	return SignalsReact.useSignalState(v7)
end

return useUserNameFromUserId
