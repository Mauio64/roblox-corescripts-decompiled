local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local SchoolMembersMock = require(Schools.Common.SchoolMembersMock)

local function useClassYears() -- line: 13
	-- upvalues: React (copy), SchoolMembersMock (copy)
	return React.useMemo(function() -- line: 14
		-- upvalues: SchoolMembersMock (copy)
		return SchoolMembersMock.getClassYears()
	end, {})
end

return useClassYears
