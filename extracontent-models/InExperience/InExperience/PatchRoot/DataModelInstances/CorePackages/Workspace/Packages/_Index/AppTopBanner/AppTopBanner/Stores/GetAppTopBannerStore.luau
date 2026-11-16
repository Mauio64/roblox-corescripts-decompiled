local parent = script:FindFirstAncestor("AppTopBanner").Parent

local Signals = require(parent.Signals)

local createAppTopBannerStore = require(script.createAppTopBannerStore)

return Signals.createComputed(createAppTopBannerStore)
