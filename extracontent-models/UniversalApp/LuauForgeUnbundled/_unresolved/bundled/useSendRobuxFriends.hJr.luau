local module = require("@luauforge/bundled/hHY")
local module2 = require("@luauforge/bundled/hJs")
local module3 = require("@luauforge/bundled/hHu")

require("@luauforge/bundled/hJp")
local module4 = require("@luauforge/bundled/hJt")

local dataStatus = module.DataStatus

local function useSendRobuxFriends()
	local v5, v6 = module2.useGetOnlineFriends()
	local v7, v8 = module2.useGetAllFriends()

	local v9 = module3.useMemo(function()
		local result = {}
		local set = {}
		local function add(p2)
			local v10 = tostring(p2)

			if not set[v10] then
				set[v10] = true
				table.insert(result, v10)
			end
		end

		if v5 then
			for k, v10 in v5 do
				local id = tostring(v10.id)

				if set[id] then
					continue
				end

				set[id] = true
				table.insert(result, id)
			end
		end

		if not v7 then
			return result
		end

		for k, friend in v7.friends do
			local id = tostring(friend.id)

			if set[id] then
				continue
			end

			set[id] = true
			table.insert(result, id)
		end

		return result
	end, { v5, v7 })

	local v10 = module4(v9)

	local v11 = module3.useMemo(function()
		local result = {}

		for k, v12 in v9 do
			local profile = v10.profiles[v12]

			if profile then
				table.insert(result, {
					userId = v12,
					displayName = profile.combinedName,
					hasVerifiedBadge = profile.hasVerifiedBadge
				})
			end
		end

		return result
	end, { v9, v10.profiles })

	local v12 = v6 == dataStatus.NotReady or v8 == dataStatus.NotReady or v10.isLoading

	return { friends = v11, profiles = v10.profiles, isLoading = v12 }
end

return useSendRobuxFriends
