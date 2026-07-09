local Parent = script:FindFirstAncestor("SocialUpsell").Parent
local Signals = require(Parent.Signals)
local createOverlayStore = require(script.Parent.createOverlayStore)

return Signals.createComputed(createOverlayStore)
