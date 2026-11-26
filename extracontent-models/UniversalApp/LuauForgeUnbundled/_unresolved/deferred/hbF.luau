local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.Foundation)
local itemCardAnimationStateIndicator = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCardAnimationStateIndicator

require("@luauforge/bundled/dPs")

local module = require("@luauforge/deferred/hbG")

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
