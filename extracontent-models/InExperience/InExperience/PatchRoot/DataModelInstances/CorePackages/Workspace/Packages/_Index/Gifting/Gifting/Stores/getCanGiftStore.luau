local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local Signals = require(parent.Signals)

local createCanGiftStore = require(Gifting.Stores.createCanGiftStore)

return Signals.createComputed(function()
	return createCanGiftStore()
end)
