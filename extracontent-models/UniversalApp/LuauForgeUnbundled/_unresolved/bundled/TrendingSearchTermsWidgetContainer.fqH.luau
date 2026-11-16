local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")

local module2 = require("@luauforge/bundled/fqI")
local module3 = require("@luauforge/bundled/fqJ")

local function TrendingSearchTermsWidgetContainer(p2)
	local v5 = module3({ onSubmitSearch = p2.onSubmitSearch })

	return React.createElement(module2, {
		chips = v5.chips,
		LayoutOrder = p2.LayoutOrder
	})
end

return TrendingSearchTermsWidgetContainer
