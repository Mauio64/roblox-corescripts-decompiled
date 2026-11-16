local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local WidgetPanelView = require(script.Parent.WidgetPanelView)
local useWidgetPanelViewModel = require(script.Parent.useWidgetPanelViewModel)

local function WidgetPanelContainer(p)
	local v = useWidgetPanelViewModel(p)

	if v.status == "visible" then
		return React.createElement(WidgetPanelView, v.viewProps)
	end

	return nil
end

return React.memo(WidgetPanelContainer)
