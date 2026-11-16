local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Signals")

local createCanGiftStore = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/createCanGiftStore")

return Signals.createComputed(function()
	return createCanGiftStore()
end)
