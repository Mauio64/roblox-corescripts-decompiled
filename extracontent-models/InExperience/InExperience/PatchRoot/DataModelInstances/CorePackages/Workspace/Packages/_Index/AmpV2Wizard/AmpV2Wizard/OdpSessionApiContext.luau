local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local OdpSessionApiProvider = require(AmpV2Wizard.OdpSessionApiProvider)

return (React.createContext(OdpSessionApiProvider))
