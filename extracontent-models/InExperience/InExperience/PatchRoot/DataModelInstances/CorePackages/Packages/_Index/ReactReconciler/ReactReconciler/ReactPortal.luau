local parent = script.Parent.Parent

local Shared = require(parent.Shared)
local REACT_PORTAL_TYPE = Shared.ReactSymbols.REACT_PORTAL_TYPE

require(parent.Shared)

return {
	createPortal = function(children, containerInfo, implementation, p: string?)
		if p ~= nil then
			p = tostring(p)
		end

		return {
			["$$typeof"] = REACT_PORTAL_TYPE,
			key = p,
			children = children,
			containerInfo = containerInfo,
			implementation = implementation
		}
	end
}
