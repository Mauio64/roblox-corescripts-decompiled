require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local createVpcNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/createVpcNode")

local v5 = createVpcNode("ParentConsent")
local v6 = createVpcNode("ParentLink")

local function RemoteParentRequestNode(p2)
	if (p2.props.action or "ParentLink") == "ParentConsent" then
		return v5(p2)
	end

	return v6(p2)
end

return RemoteParentRequestNode
