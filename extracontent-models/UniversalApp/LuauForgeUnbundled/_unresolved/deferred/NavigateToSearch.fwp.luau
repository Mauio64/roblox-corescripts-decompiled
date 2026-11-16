local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

local module2 = require("@luauforge/bundled/fuL")
require("@luauforge/bundled/dTN")
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local module3 = require("@luauforge/bundled/fpw")
local module4 = require("@luauforge/bundled/fpx")
local module5 = require("@luauforge/bundled/dTM")

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
