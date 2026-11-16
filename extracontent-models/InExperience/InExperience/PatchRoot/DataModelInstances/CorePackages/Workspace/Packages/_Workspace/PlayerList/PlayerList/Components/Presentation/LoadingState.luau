local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

local useLegacyAndTransparencyAwarePanelStyle = require(parent.Hooks.useLegacyAndTransparencyAwarePanelStyle)

local function LoadingStateImpl(p)
	local v = useLegacyAndTransparencyAwarePanelStyle(p.useLegacyPanelStyling)

	return React.createElement(
		View,
		{ tag = v.panelTag, LayoutOrder = p.layoutOrder, backgroundStyle = v.backgroundStyle },
		{
			Spinner = React.createElement(Loading, { size = IconSize.XLarge })
		}
	)
end

return React.memo(LoadingStateImpl)
