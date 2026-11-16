local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local function GenericText(props)
	local v5 = useDesignTokens()
	local udim = UDim.new(0, v5.Size.Size_600)
	local v6 = ({
		Header = v5.Typography.HeadingSmall,
		Subheader = v5.Typography.TitleLarge,
		Body = v5.Typography.BodyLarge
	})[props.type]
	local v7 = if props.emphasis then v5.Color.Content.Emphasis else v5.Color.Content.Default
	local padding = props.padding or udim

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local v10 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = padding,
			PaddingRight = padding
		}),
		Text = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = props.text,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 0,
		TextWrapped = true,
		TextXAlignment = 0,
		TextYAlignment = 0,
		Size = 0,
		BackgroundTransparency = 1
	}
	local v13 = if not foundationFontFaceMigration then v6.Font else nil
	v12.Font = v13
	local v14 = if foundationFontFaceMigration then normalizeFontFace(v6.Font) else nil
	v12.FontFace = v14

	v12.TextColor3 = v7.Color3
	v12.TextTransparency = v7.Transparency
	v12.TextSize = v6.FontSize

	v12.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	v12.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	v12.Size = props.size or UDim2.new(1, 0, 1, 0)
	v10.Text = createElement2("TextLabel", v12)
	return createElement("Frame", v9, v10)
end

return {
	HeaderText = function(p2)
		return React.createElement(
			GenericText,
			Dash.join(p2, { type = "Header", emphasis = true, padding = UDim.new(0, 0) })
		)
	end,
	SubheaderText = function(p2)
		return React.createElement(GenericText, Dash.join(p2, {
			type = "Subheader",
			emphasis = true
		}))
	end,
	BodyText = function(p2)
		return React.createElement(GenericText, Dash.join(p2, {
			type = "Body",
			emphasis = false
		}))
	end,
	BoldBodyText = function(p2)
		return React.createElement(GenericText, Dash.join(p2, {
			type = "Header",
			emphasis = false
		}))
	end
}
