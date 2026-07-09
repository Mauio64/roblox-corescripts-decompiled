local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local SchoolMock = require(Schools.Common.SchoolMock)

local function useSchool() -- line: 13
	-- upvalues: React (copy), SchoolMock (copy)
	return React.useMemo(function() -- line: 14
		-- upvalues: SchoolMock (copy)
		return SchoolMock.getSchool()
	end, {})
end

return useSchool
