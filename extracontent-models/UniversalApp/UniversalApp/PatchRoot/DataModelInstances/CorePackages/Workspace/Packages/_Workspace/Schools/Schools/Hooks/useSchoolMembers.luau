local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)

require(SchoolsParent.UserList)

local SchoolMembersMock = require(Schools.Common.SchoolMembersMock)

local function useSchoolMembers(s1: string?) -- line: 17
	-- upvalues: React (copy), SchoolMembersMock (copy)
	return React.useMemo(function() -- line: 18
		-- upvalues: s1 (copy), SchoolMembersMock (copy)
		local v7 = if s1 ~= SchoolMembersMock.ALL_YEARS then tonumber(s1) else nil
		local t1 = {}

		for _, v10 in if v7 == nil then SchoolMembersMock.listGroupMemberships() else SchoolMembersMock.listMembershipsByClassYear(v7) do
			table.insert(t1, {
				type = "User",
				id = v10.userId
			})
		end

		return t1
	end, { s1 })
end

return useSchoolMembers
