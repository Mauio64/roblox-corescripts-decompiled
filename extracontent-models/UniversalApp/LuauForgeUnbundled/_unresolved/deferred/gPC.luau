local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.Foundation)
local itemCardAnimationStateIndicator = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardAnimationStateIndicator

require("@luauforge/bundled/dMc")

local module = require("@luauforge/deferred/gPD")

local function CatalogItemCardAnimationIndicatorContainer(props)
	local v5 = module(props.bundleInfo)
	return React.createElement(itemCardAnimationStateIndicator, {
		states = v5.states,
		ZIndex = props.ZIndex,
		paddingTop = props.paddingTop,
		paddingBottom = props.paddingBottom,
		paddingLeft = props.paddingLeft,
		paddingRight = props.paddingRight
	})
end

return React.memo(CatalogItemCardAnimationIndicatorContainer)
