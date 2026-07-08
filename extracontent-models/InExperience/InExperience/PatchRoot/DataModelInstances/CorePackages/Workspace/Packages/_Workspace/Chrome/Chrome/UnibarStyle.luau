local Parent = script:FindFirstAncestor("Chrome").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local v4 = React.createContext({})

local function UnibarStyleConstants() -- line: 10
	-- upvalues: useTokens (copy)
	local v7 = useTokens()

	return {
		ICON_CELL_WIDTH = v7.Size.Size_1100,
		ICON_SIZE = v7.Size.Size_900,
		UNIBAR_ICON_SIZE = v7.Size.Size_800,
		ICON_HIGHLIGHT_SIZE = UDim2.new(0, v7.Size.Size_900, 0, v7.Size.Size_900),
		ICON_DIVIDER_POSITION = UDim2.new(0, v7.Size.Size_50, 0.5, 0),
		ICON_BADGE_OFFSET_X = v7.Gap.XXLarge,
		ICON_BADGE_OFFSET_Y = v7.Gap.Small,
		MEDIUM_ICON_SIZE = v7.Size.Size_700,
		UNIBAR_END_PADDING = v7.Padding.XSmall,
		MENU_SUBMENU_PADDING = v7.Padding.Small,
		UNIBAR_LEFT_MARGIN = v7.Padding.Small,
		SUB_MENU_ROW_HEIGHT = v7.Size.Size_1400,
		SUBMENU_CORNER_RADIUS = v7.Radius.Medium,
		SUBMENU_PADDING_LEFT = v7.Padding.Small,
		SUBMENU_PADDING_RIGHT = v7.Padding.Small,
		SUBMENU_ROW_LABEL_FONT = v7.Typography.TitleLarge,
		SUBMENU_ROW_PADDING = v7.Padding.Small,
		SUBMENU_ROW_CORNER_RADIUS = v7.Radius.Medium,
		SUBMENU_BOTTOM_PADDING = v7.Padding.XLarge,
		CLOSE_BUTTON_FRAME = UDim2.new(0, v7.Size.Size_1100, 0, v7.Size.Size_1100),
		WINDOW_DEFAULT_PADDING = v7.Padding.Small
	}
end
local function UnibarStyleProvider(p1) -- line: 38
	-- upvalues: React (copy), v4 (copy), UnibarStyleConstants (copy)
	return React.createElement(v4.Provider, {
		value = UnibarStyleConstants()
	}, p1.children)
end

return {
	Context = v4,
	Provider = UnibarStyleProvider,
	use = function() -- line: 44
		-- upvalues: React (copy), v4 (copy)
		local v9 = React.useContext(v4)

		if v9 then
			return v9
		end

		error("attempt to use UnibarStyleContext with no provider. Add `UnibarStyleContext.Provider` to the React tree and try again")
	end
}
