local module = require("@luauforge/bundled/hRF")

local module2 = require("@luauforge/bundled/hRI")
local module3 = require("@luauforge/bundled/hSb")

local module4 = require("@luauforge/bundled/hSm")
local module5 = require("@luauforge/bundled/hSo")
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
