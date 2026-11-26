local module = require("@luauforge/bundled/ibe")

local module2 = require("@luauforge/bundled/ibh")
local module3 = require("@luauforge/bundled/ibA")

local module4 = require("@luauforge/bundled/ibL")
local module5 = require("@luauforge/bundled/ibN")
local function SupportRegionAvatarOverlayContainer()
	local v5 = module3()

	module5({
		showLeftChevron = v5.showLeftChevron,
		isSwitchingOutfit = v5.isSwitchingOutfit,
		onLeftChevronActivated = v5.onLeftChevronActivated,
		onRightChevronActivated = v5.onRightChevronActivated
	})

	module4()

	return module.createElement(module2, v5)
end

return module.memo(SupportRegionAvatarOverlayContainer)
