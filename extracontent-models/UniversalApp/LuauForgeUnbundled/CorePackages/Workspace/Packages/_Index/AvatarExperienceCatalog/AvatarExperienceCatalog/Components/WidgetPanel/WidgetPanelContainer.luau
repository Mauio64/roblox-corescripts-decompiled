local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local WidgetPanelView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/WidgetPanel/WidgetPanelView")
local useWidgetPanelViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/WidgetPanel/useWidgetPanelViewModel")

local function WidgetPanelContainer(p2)
	local v5 = useWidgetPanelViewModel(p2)

	if v5.status == "visible" then
		return React.createElement(WidgetPanelView, v5.viewProps)
	end

	return nil
end

return React.memo(WidgetPanelContainer)
