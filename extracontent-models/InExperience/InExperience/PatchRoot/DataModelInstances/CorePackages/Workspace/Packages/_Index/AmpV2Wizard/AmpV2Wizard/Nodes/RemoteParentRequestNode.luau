local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")

require(AmpV2Wizard.Types)
local createVpcNode = require(AmpV2Wizard.Nodes.createVpcNode)

local vpcNode = createVpcNode("ParentConsent")
local vpcNode2 = createVpcNode("ParentLink")

local function RemoteParentRequestNode(p)
	if (p.props.action or "ParentLink") == "ParentConsent" then
		return vpcNode(p)
	end

	return vpcNode2(p)
end

return RemoteParentRequestNode
