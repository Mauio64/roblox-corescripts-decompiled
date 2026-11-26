local module = require("@luauforge/deferred/eko")
require("@luauforge/deferred/ekW")
require("@luauforge/deferred/ekt")

local module2 = require("@luauforge/deferred/eku")
local module3 = require("@luauforge/deferred/ekX")
require("@luauforge/deferred/ekr")

local function useSchoolMembers(p2, p3, p4)
	local v5 = module3(p2, p4)

	local v6 = module.useMemo(function()
		if v5.data == nil then
			return {}
		end

		local v7 = if not (p3 == nil or p3 == module2.MemberList.ALL_YEARS) then tonumber(p3) else nil

		local result = {}

		for k, member in v5.data.members do
			if v7 == nil or member.graduationYear == v7 then
				table.insert(result, { id = member.userId, type = "User" })
			end
		end

		return result
	end, { v5.data, p3 })

	local v7 = module.useMemo(function()
		if p3 == nil or p3 == module2.MemberList.ALL_YEARS then
			return nil
		end

		local v8 = tonumber(p3)

		if v8 and v5.data and v5.data.yearToRoleId then
			return v5.data.yearToRoleId[v8]
		end

		return nil
	end, { p3, v5.data, v5.data and v5.data.yearToRoleId })

	local v8 = v7 == nil or v5.roleHasMore[v7] ~= nil

	module.useEffect(function()
		if v7 ~= nil and not (v8 or v5.isLoadingMore) then
			v5.loadMore(v7)
		end
	end, { v7, v8, v5.isLoadingMore, v5.loadMore })

	local v9 = if v7 == nil then v5.hasMore else v5.roleHasMore[v7] == true and not v5.isLoadingMore
	local v10 = not (v7 == nil) and not v8

	local v11 = module.useCallback(function()
		v5.loadMore(v7)
	end, { v5.loadMore, v7 })

	return {
		status = v5.status,
		entities = v6,
		hasMore = v9,
		isLoadingMore = v5.isLoadingMore or v10,
		loadMore = v11
	}
end

return useSchoolMembers
