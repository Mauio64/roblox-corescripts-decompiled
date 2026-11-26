local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Foundation").Hooks.useTokens

local context = React.createContext({})

local function UnibarStyleConstants()
	local v5 = useTokens()

	return {
		ICON_CELL_WIDTH = v5.Size.Size_1100,
		ICON_SIZE = v5.Size.Size_900,
		UNIBAR_ICON_SIZE = v5.Size.Size_800,
		ICON_HIGHLIGHT_SIZE = UDim2.new(0, v5.Size.Size_900, 0, v5.Size.Size_900),
		ICON_DIVIDER_POSITION = UDim2.new(0, v5.Size.Size_50, 0.5, 0),
		ICON_BADGE_OFFSET_X = v5.Gap.XXLarge,
		ICON_BADGE_OFFSET_Y = v5.Gap.Small,
		MEDIUM_ICON_SIZE = v5.Size.Size_700,
		UNIBAR_END_PADDING = v5.Padding.XSmall,
		MENU_SUBMENU_PADDING = v5.Padding.Small,
		UNIBAR_LEFT_MARGIN = v5.Padding.Small,
		SUB_MENU_ROW_HEIGHT = v5.Size.Size_1400,
		SUBMENU_CORNER_RADIUS = v5.Radius.Medium,
		SUBMENU_PADDING_LEFT = v5.Padding.Small,
		SUBMENU_PADDING_RIGHT = v5.Padding.Small,
		SUBMENU_ROW_LABEL_FONT = v5.Typography.TitleLarge,
		SUBMENU_ROW_PADDING = v5.Padding.Small,
		SUBMENU_ROW_CORNER_RADIUS = v5.Radius.Medium,
		SUBMENU_BOTTOM_PADDING = v5.Padding.XLarge,
		CLOSE_BUTTON_FRAME = UDim2.new(0, v5.Size.Size_1100, 0, v5.Size.Size_1100),
		WINDOW_DEFAULT_PADDING = v5.Padding.Small
	}
end

local function UnibarStyleProvider(p2)
	return React.createElement(context.Provider, { value = UnibarStyleConstants() }, p2.children)
end

return {
	Context = context,
	Provider = UnibarStyleProvider,
	use = function()
		local v5 = React.useContext(context)

		if v5 then
			return v5
		end

		error("attempt to use UnibarStyleContext with no provider. Add `UnibarStyleContext.Provider` to the React tree and try again")
	end
}
