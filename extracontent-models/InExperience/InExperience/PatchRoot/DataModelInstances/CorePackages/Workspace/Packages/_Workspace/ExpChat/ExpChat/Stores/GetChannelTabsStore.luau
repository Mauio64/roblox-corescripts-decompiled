local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChannelTabsStore = require(script.createChannelTabsStore)

return Signals.createComputed(createChannelTabsStore)
