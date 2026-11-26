local module = require("@luauforge/bundled/hHu")
local module2 = require("@luauforge/bundled/hJu")
local module3 = require("@luauforge/bundled/hHO")
local module4 = require("@luauforge/bundled/hJv")

local v5 = { profiles = {}, isLoading = false }

local function readProfiles()
	return module2.createComputed(function()
		return v5
	end)
end

local function useSendRobuxProfiles(list)
	local joined = table.concat(list, ",")

	local v6 = module.useMemo(function()
		if joined == "" then
			return readProfiles()
		end

		local namesByUserIds = module4.Stores.UserProfileStore.get().fetchNamesByUserIds(string.split(joined, ","))
		return module2.createComputed(function(p2)
			local v7 = namesByUserIds(p2)
			local v8 = {}

			for k, v9 in v7.data do
				local combinedName = v9.names.getCombinedName(p2)

				if combinedName == "" then
					continue
				end

				local userId = v9.userId

				local v11 = if v9.getIsVerified then v9.getIsVerified(p2) else false
				local v12 = if v9.getHasRobloxSubscription then v9.getHasRobloxSubscription(p2) else false
				v8[userId] = {
					combinedName = combinedName,
					hasVerifiedBadge = v11,
					isRobloxPlus = v12
				}
			end

			return {
				profiles = v8,
				isLoading = v7.status == "fetching"
			}
		end)
	end, { joined })

	return module3.useSignalState(v6)
end

return useSendRobuxProfiles
