local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad
local module = require("@luauforge/deferred/gXU")
local checkboxGroup = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Filters.CheckboxGroup
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fuL")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local udim = UDim.new(0, 4)

local function getTotalHeight(p2)
	return p2 + 19 + udim.Offset
end

local function FilterSubsection(props)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local v6 = useIsGamepad()

	local v7, v8 = React.useBinding(0)

	local function onHeightChanged(p2)
		v8(p2)

		if props.onHeightChanged then
			props.onHeightChanged(p2 + 19 + udim.Offset)
		end
	end

	local v9 = if props.selectionMode == "multiple" then checkboxGroup else module

	local createElement = React.createElement
	local frame = focusable.Frame
	local v10 = {
		Size = v7:map(function(p2)
			return UDim2.new(1, 0, 0, p2 + 19 + udim.Offset)
		end),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ref = props.frameRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}
	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = udim
		}),
		Title = 0,
		RadioButtonGroupContainer = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		Text = 0,
		TextColor3 = 0,
		TextTransparency = 0
	}
	local v13 = if not foundationFontFaceMigration then font.Header2.Font else nil
	v12.Font = v13

	local v14 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
	v12.FontFace = v14

	v12.TextSize = font.Header2.RelativeSize * font.BaseSize
	v12.Text = props.title
	v12.TextColor3 = theme.TextEmphasis.Color
	v12.TextTransparency = theme.TextEmphasis.Transparency
	children.Title = createElement2("TextLabel", v12)

	children.RadioButtonGroupContainer = React.createElement(
		"Frame",
		{
			Size = v7:map(module3.mapHeightToSize),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			RadioButtons = React.createElement(v9, {
				items = props.items,
				itemHeight = module2.SortAndFiltersRowHeight,
				selectedValue = props.selectedValue,
				onActivated = function(p2)
					if props.setSelectedValue then
						props.setSelectedValue(p2)
					end
				end,
				useDefaultControlState = v6,
				onHeightChanged = onHeightChanged
			})
		}
	)
	return createElement(frame, v10, children)
end

return FilterSubsection
