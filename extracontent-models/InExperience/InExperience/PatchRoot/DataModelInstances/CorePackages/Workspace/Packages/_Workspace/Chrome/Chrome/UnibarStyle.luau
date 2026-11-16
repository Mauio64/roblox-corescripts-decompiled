local parent = script:FindFirstAncestor("Chrome").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local context = React.createContext({})

local function UnibarStyleConstants()
	local v = useTokens()

	return {
		ICON_CELL_WIDTH = v.Size.Size_1100,
		ICON_SIZE = v.Size.Size_900,
		UNIBAR_ICON_SIZE = v.Size.Size_800,
		ICON_HIGHLIGHT_SIZE = UDim2.new(0, v.Size.Size_900, 0, v.Size.Size_900),
		ICON_DIVIDER_POSITION = UDim2.new(0, v.Size.Size_50, 0.5, 0),
		ICON_BADGE_OFFSET_X = v.Gap.XXLarge,
		ICON_BADGE_OFFSET_Y = v.Gap.Small,
		MEDIUM_ICON_SIZE = v.Size.Size_700,
		UNIBAR_END_PADDING = v.Padding.XSmall,
		MENU_SUBMENU_PADDING = v.Padding.Small,
		UNIBAR_LEFT_MARGIN = v.Padding.Small,
		SUB_MENU_ROW_HEIGHT = v.Size.Size_1400,
		SUBMENU_CORNER_RADIUS = v.Radius.Medium,
		SUBMENU_PADDING_LEFT = v.Padding.Small,
		SUBMENU_PADDING_RIGHT = v.Padding.Small,
		SUBMENU_ROW_LABEL_FONT = v.Typography.TitleLarge,
		SUBMENU_ROW_PADDING = v.Padding.Small,
		SUBMENU_ROW_CORNER_RADIUS = v.Radius.Medium,
		SUBMENU_BOTTOM_PADDING = v.Padding.XLarge,
		CLOSE_BUTTON_FRAME = UDim2.new(0, v.Size.Size_1100, 0, v.Size.Size_1100),
		WINDOW_DEFAULT_PADDING = v.Padding.Small
	}
end

local function UnibarStyleProvider(p)
	return React.createElement(context.Provider, { value = UnibarStyleConstants() }, p.children)
end

return {
	Context = context,
	Provider = UnibarStyleProvider,
	use = function()
		local v = React.useContext(context)

		if v then
			return v
		end

		error("attempt to use UnibarStyleContext with no provider. Add `UnibarStyleContext.Provider` to the React tree and try again")
	end
}
