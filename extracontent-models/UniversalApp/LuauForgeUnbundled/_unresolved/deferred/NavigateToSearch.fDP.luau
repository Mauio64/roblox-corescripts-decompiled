local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

local module2 = require("@luauforge/bundled/fCm")
require("@luauforge/bundled/dXi")
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local module3 = require("@luauforge/bundled/fwR")
local module4 = require("@luauforge/bundled/fwS")
local module5 = require("@luauforge/bundled/dXh")

local function NavigateToSearch(p2, options)
	return function(object)
		local v5 = searchUuid()
		object:dispatch(module3(v5, RobloxAppEnums.SearchTypes.Catalog))

		local sortAndFilters = module2.selectSortAndFilters(object:getState())
		local joined = Dash.join(options or {}, { sortAndFilters = sortAndFilters })

		object:dispatch(module4(v5, joined))

		module5.navigateToSearch(p2, v5, joined)
	end
end

return NavigateToSearch
