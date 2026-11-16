local module = require("@luauforge/bundled/hRF")

local module2 = require("@luauforge/bundled/hRP")
local module3 = require("@luauforge/bundled/hRT")

local function ProfileChipContainer(p2, p3)
	local v5 = module3()

	return module.createElement(module2, {
		isUserLoaded = v5.isUserLoaded,
		thumbnail = v5.thumbnail,
		name = v5.name,
		isVerified = v5.isVerified,
		showSubscriberBadge = v5.showSubscriberBadge,
		layoutOrder = p2.layoutOrder,
		onActivated = v5.onActivated,
		ref = p3
	})
end

local forwardRef = module.forwardRef(ProfileChipContainer)
return module.memo(forwardRef)
