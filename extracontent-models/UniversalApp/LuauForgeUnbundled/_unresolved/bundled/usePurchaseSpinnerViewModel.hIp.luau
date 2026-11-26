local module = require("@luauforge/bundled/hHO")

local module2 = require("@luauforge/bundled/hHI")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryLeavingOverlay")
local module3 = require("@luauforge/bundled/hIc")

local pageScopeFieldPageVisit = module2.PageScopeFieldPageVisit
local pageScopeFieldPurchaseInFlight = module2.PageScopeFieldPurchaseInFlight

local function usePurchaseSpinnerViewModel(p2)
	local v5 = module3()
	local v6 = module.useSignalState(v5.getSignal(pageScopeFieldPageVisit))
	local v7 = module.useSignalState(v5.getSignal(pageScopeFieldPurchaseInFlight))

	return {
		isVisible = v7 ~= nil and v7 == v6,
		ZIndex = p2.ZIndex
	}
end

return usePurchaseSpinnerViewModel
