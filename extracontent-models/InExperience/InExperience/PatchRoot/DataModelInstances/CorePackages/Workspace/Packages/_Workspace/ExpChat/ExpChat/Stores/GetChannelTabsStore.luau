local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createChannelTabsStore = require(script.createChannelTabsStore)

return Signals.createComputed(createChannelTabsStore)
