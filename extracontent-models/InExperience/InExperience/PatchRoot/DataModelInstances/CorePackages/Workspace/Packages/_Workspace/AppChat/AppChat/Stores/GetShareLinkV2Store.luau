local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createShareLinkV2Store = require(script.createShareLinkV2Store)

return Signals.createComputed(function(_)
	return createShareLinkV2Store()
end)
