require("@luauforge/bundled/gvc")
local module = require("@luauforge/bundled/gvS")

local v5 = module("ParentConsent")
local v6 = module("ParentLink")

local function RemoteParentRequestNode(p2)
	if (p2.props.action or "ParentLink") == "ParentConsent" then
		return v5(p2)
	end

	return v6(p2)
end

return RemoteParentRequestNode
