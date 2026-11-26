local module = require("@luauforge/bundled/ggX")

local module2 = require("@luauforge/bundled/gya")
local module3 = require("@luauforge/bundled/gyf")

local function CrossDeviceMagicSignInContainer(props)
	local v5 = module3()

	local createElement = module.createElement
	local v7 = {
		card = v5.card,
		renderQrPane = 0,
		switchAccount = 0,
		defaultRef = 0,
		containerRef = 0
	}
	local v8 = if v5.showsQr then props.renderQrPane else nil
	v7.renderQrPane = v8
	v7.switchAccount = props.switchAccount
	v7.defaultRef = props.defaultRef
	v7.containerRef = props.containerRef
	return createElement(module2, v7)
end

return CrossDeviceMagicSignInContainer
