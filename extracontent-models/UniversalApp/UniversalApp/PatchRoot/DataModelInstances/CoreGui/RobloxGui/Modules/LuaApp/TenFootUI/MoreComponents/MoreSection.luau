local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local HeaderText = require(script.Parent.MoreText).HeaderText
local _ = {
	withDivider = true
}

local function Section(t1: {[any]: any}) -- line: 20
	-- upvalues: useDesignTokens (copy), React (copy), Dash (copy), HeaderText (copy)
	local v9 = useDesignTokens()
	local Emphasis = v9.Color.Stroke.Emphasis
	local uDim = UDim.new(0, v9.Size.Size_400)
	local v12 = type(t1.withDivider) ~= "boolean" or t1.withDivider

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, Dash.assign({
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = uDim
		}),
		Title = React.createElement(HeaderText, {
			layoutOrder = -1,
			text = t1.title
		}),
		Divider = if not v12 then nil else React.createElement("Frame", {
			LayoutOrder = 10000000,
			BorderSizePixel = 0,
			BackgroundColor3 = Emphasis.Color3,
			BackgroundTransparency = Emphasis.Transparency,
			Size = UDim2.new(1, 0, 0, 1)
		})
	}, t1.children))
end

return Section
