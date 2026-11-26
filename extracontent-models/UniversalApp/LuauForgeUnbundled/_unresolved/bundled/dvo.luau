local module = require("@luauforge/bundled/dva")
local useAppPolicy = require("@luauforge/bundled/duP").useAppPolicy
local useUserExperiment = require("@luauforge/bundled/duV").useUserExperiment
local appUserLayers = require("@luauforge/bundled/duW").AppUserLayers
require("@luauforge/bundled/dun")

local module2 = require("@luauforge/bundled/dvp")
local module3 = require("@luauforge/bundled/dvw")

local module4 = require("@luauforge/bundled/dvB")

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
