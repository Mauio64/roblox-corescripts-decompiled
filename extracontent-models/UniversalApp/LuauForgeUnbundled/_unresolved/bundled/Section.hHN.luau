local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local headerText = require("@luauforge/bundled/hHO").HeaderText
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

local v5 = { withDivider = true }

local function Section(props)
	local v6 = useDesignTokens()
	local emphasis = v6.Color.Stroke.Emphasis
	local udim = UDim.new(0, v6.Size.Size_400)
	local v7 = type(props.withDivider) ~= "boolean" or props.withDivider

	local createElement = React.createElement

	local v9 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local assign = Dash.assign
	local v10 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = udim
		}),
		Title = 0,
		Divider = 0
	}

	local v11 = if not fFlagUnifyConsoleSettingsPage or not not props.title and props.title ~= "" then React.createElement(headerText, {
		layoutOrder = -1,
		text = props.title
	}) else nil
	v10.Title = v11

	local v12 = if v7 then React.createElement("Frame", {
		LayoutOrder = 10000000,
		BackgroundColor3 = emphasis.Color3,
		BackgroundTransparency = emphasis.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1)
	}) else nil
	v10.Divider = v12
	return createElement("Frame", v9, assign(v10, props.children))
end

return Section
