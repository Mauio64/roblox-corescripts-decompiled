local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/eiD")

local module3 = require("@luauforge/deferred/ejV")
local module4 = require("@luauforge/deferred/ejX")
local module5 = require("@luauforge/deferred/ekb")
local module6 = require("@luauforge/deferred/ekc")
local module7 = require("@luauforge/deferred/ekg")
local module8 = require("@luauforge/deferred/eki")
local module9 = require("@luauforge/deferred/elr")

local fFlagAFPConnectionsChannelsHeader = require("@luauforge/deferred/eiz").FFlagAFPConnectionsChannelsHeader

local v5 = {
	{ component = module6 },
	{ component = module7 }
}

if require("@luauforge/deferred/eiz").FFlagEnableSchoolEntry then
	table.insert(v5, { component = module8 })
end

local count = #v5

local function ConnectionChannelsSection(p2)
	local v6 = module2()

	local layoutOrder = p2.layoutOrder
	local navigateToLuaAppPages = p2.navigateToLuaAppPages

	local v7, v8 = module9(count)

	local v9 = module.useCallback(function(p3, p4, p5)
		return module.createElement(p3.component, {
			component = module5,
			componentUIProps = {
				layoutOrder = p4,
				itemSize = p5,
				onVisibilityChange = function(p6)
					v7(p4, p6)
				end
			},
			fireAnalyticsEvent = v6,
			navigateToLuaAppPages = p2.navigateToLuaAppPages
		}), "Item"
	end, { v6, navigateToLuaAppPages, v7 })

	if v8 then
		return nil
	end

	local createElement = module.createElement
	local v11 = {
		layoutOrder = layoutOrder,
		items = v5,
		contextualInfoHeight = 25,
		renderItem = v9,
		headerComponent = 0
	}

	local v12 = if fFlagAFPConnectionsChannelsHeader then module.createElement(module4) else nil
	v11.headerComponent = v12
	return createElement(module3, v11)
end

return ConnectionChannelsSection
