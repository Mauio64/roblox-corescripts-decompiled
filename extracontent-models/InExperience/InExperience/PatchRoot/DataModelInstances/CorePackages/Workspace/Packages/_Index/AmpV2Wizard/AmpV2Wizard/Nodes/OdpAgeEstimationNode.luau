local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")

local Types = require(AmpV2Wizard.OdpVerification.Types)
local createOdpVerificationNode = require(AmpV2Wizard.Nodes.createOdpVerificationNode)

return createOdpVerificationNode(Types.OdpVerificationMethod.Fae)
