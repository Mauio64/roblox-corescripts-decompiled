local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local Signals = require(AvatarSwitcherParent.Signals)
local createAvatarSwitcherStore = require(AvatarSwitcher.Stores.createAvatarSwitcherStore)

return Signals.createComputed(createAvatarSwitcherStore)
