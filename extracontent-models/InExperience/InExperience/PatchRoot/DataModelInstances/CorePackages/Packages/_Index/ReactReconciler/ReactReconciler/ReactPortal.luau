local ParentParent = script.Parent.Parent
local REACT_PORTAL_TYPE = require(ParentParent.Shared).ReactSymbols.REACT_PORTAL_TYPE

require(ParentParent.Shared)

return {
	createPortal = function(p1, p2, p3, s1: string?) -- line: 19
		-- upvalues: REACT_PORTAL_TYPE (copy)
		if s1 ~= nil then
			s1 = tostring(s1)
		end

		return {
			["$$typeof"] = REACT_PORTAL_TYPE,
			key = s1,
			children = p1,
			containerInfo = p2,
			implementation = p3
		}
	end
}
