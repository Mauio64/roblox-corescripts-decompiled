local module = require("@luauforge/bundled/drY")
local useAppPolicy = require("@luauforge/bundled/drN").useAppPolicy
local useUserExperiment = require("@luauforge/bundled/drT").useUserExperiment
local appUserLayers = require("@luauforge/bundled/drU").AppUserLayers
require("@luauforge/bundled/drl")

local module2 = require("@luauforge/bundled/dsn")
local module3 = require("@luauforge/bundled/dsu")

local module4 = require("@luauforge/bundled/dsz")

local v5 = { appUserLayers.GridUILayer }

local function fn(p2)
	return (p2[appUserLayers.GridUILayer] or {}).IsGameGridDesktopRefreshEnabled or false
end

return function(p2)
	local currentSidePadding = p2.currentSidePadding or 0

	local v6 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local v7 = module4 and true or useUserExperiment(v5, fn)

	if v6 and v7 then
		return module.createElement("Frame", {
			Position = UDim2.fromOffset(-currentSidePadding, 0),
			Size = UDim2.new(1, currentSidePadding * 2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p2.LayoutOrder,
			BackgroundTransparency = 1
		}, {
			Layout = module.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			GridTable = module.createElement(module3, p2)
		})
	end

	return module.createElement(module2, p2)
end
