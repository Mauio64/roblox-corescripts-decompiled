local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local Signals = require(parent.Signals)

local createAvatarSwitcherStore = require(AvatarSwitcher.Stores.createAvatarSwitcherStore)

return Signals.createComputed(createAvatarSwitcherStore)
