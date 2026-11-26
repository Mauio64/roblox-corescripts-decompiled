local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

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

	return React.createElement(
		"Frame",
		{
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = padding,
				PaddingRight = padding
			}),
			Text = React.createElement("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = props.text,
				FontFace = normalizeFontFace(v6.Font),
				LayoutOrder = 1,
				TextColor3 = v7.Color3,
				TextTransparency = v7.Transparency,
				TextSize = v6.FontSize,
				TextWrapped = true,
				TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
				TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center,
				Size = props.size or UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			})
		}
	)
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
