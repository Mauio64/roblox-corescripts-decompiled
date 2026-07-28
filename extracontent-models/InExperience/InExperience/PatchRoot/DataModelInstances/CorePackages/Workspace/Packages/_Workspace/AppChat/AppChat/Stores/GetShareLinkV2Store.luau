local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createShareLinkV2Store = require(script.createShareLinkV2Store)

return Signals.createComputed(function(_) -- line: 8
	-- upvalues: createShareLinkV2Store (copy)
	return createShareLinkV2Store()
end)
