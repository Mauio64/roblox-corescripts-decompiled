local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
require("@luauforge/bundled/dHL")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eeH")

local module2 = require("@luauforge/bundled/dxy")
local module3 = require("@luauforge/bundled/eda")
local module4 = require("@luauforge/bundled/gNV")
local module5 = require("@luauforge/bundled/gNW")

local function useWidgetHydration(data)
	local widgetInfo = data.widgetInfo
	local hydratedWidgetData = data.hydratedWidgetData
	local hydrationCount = data.hydrationCount

	local v5 = useDispatch()
	local v6 = module(module3)
	local state, setState = React.useState(module2.NotStarted)

	local v7 = React.useMemo(function()
		return module5(widgetInfo, hydratedWidgetData, hydrationCount)
	end, { hydratedWidgetData, widgetInfo, hydrationCount })

	React.useEffect(function()
		if
			widgetInfo.type ~= widgetConstants.Types.MySharedAvatarsWidget
			and v7
			and #v7 > 0
			and state == module2.NotStarted
		then
			setState(module2.Fetching)
			v5(module4(v6, v7, widgetInfo.id))
		end
	end, { v7, widgetInfo, state, v5, v6 })
end

return useWidgetHydration
