local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gaH")
local getFStringBlackbirdUrl = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringBlackbirdUrl

local module2 = require("@luauforge/bundled/fsq")

local getSubscriptionPurchaseCloseCallback = require("@luauforge/bundled/fzr").Utils.getSubscriptionPurchaseCloseCallback

local function BlackbirdPageWrapper(props)
	local v5 = React.useMemo(getSubscriptionPurchaseCloseCallback, {})

	return React.createElement(module, {
		isVisible = props.isVisible,
		DisplayOrder = props.DisplayOrder,
		url = module2.fromString(getFStringBlackbirdUrl())(),
		titleKey = "CommonUI.Features.Label.X",
		transitionAnimation = props.transitionAnimation,
		onClose = v5
	})
end

return BlackbirdPageWrapper
