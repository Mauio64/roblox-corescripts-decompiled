local parent = script:FindFirstAncestor("SocialUpsell").Parent
local Signals = require(parent.Signals)

local createOverlayStore = require(script.Parent.createOverlayStore)

return Signals.createComputed(createOverlayStore)
