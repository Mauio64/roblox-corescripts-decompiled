local module = require("@luauforge/bundled/hwd")
local module2 = require("@luauforge/bundled/hwe")
local fFlagEnableBuyRobuxSdui = require("@luauforge/bundled/hwf").FFlagEnableBuyRobuxSdui

return {
	BuyRobuxUniversalApp = function(props)
		local ref = module.useRef(nil)
		local ref2 = module.useRef(false)

		if ref.current == nil then
			ref.current = module2.resolveDestination({
				productId = props.productId,
				analyticId = props.analyticId
			})
		end

		module.useEffect(function()
			module2.logBuyRobuxRoutingCallsite(props.callsite)
		end, { props.callsite })

		module.useEffect(function()
			local current = ref.current

			if props.isVisible and current ~= nil and current.shouldExpose and not ref2.current then
				ref2.current = true

				task.defer(function()
					module2.logExposure(current)
				end)
			end
		end, { props.isVisible })

		local current = ref.current

		if fFlagEnableBuyRobuxSdui and current.kind == "native" then
			local module3 = require("@luauforge/bundled/hwg")
			return module.createElement(module3.BuyRobuxSduiPage, {
				analyticId = props.analyticId
			})
		end

		local v5 = if current.kind == "web" then current.url else module2.fallbackWebUrl({
			productId = props.productId,
			analyticId = props.analyticId
		})

		return module.createElement(props.pageWrapper, {
			url = v5,
			isVisible = props.isVisible,
			DisplayOrder = props.displayOrder,
			transitionAnimation = props.transitionAnimation
		})
	end
}
