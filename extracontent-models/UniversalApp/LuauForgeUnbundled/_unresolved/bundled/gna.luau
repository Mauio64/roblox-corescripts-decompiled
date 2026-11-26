local module = require("@luauforge/bundled/gmo")

local module2 = require("@luauforge/bundled/gmz")
local fitChildren = module2.Components.FitChildren
local alignment = module2.Enums.Alignment
local module3 = require("@luauforge/bundled/gmp")

local useDesignTokens = require("@luauforge/bundled/gnb").useDesignTokens
local backgroundFill = module2.Components.BackgroundFill

return (module.forwardRef(function(props, p2)
	local authConsoleLayout = useDesignTokens().LuaApps.AuthConsoleLayout

	local children = props.children
	local contentAlign = props.ContentAlign or alignment.Top
	local footerElement = props.FooterElement

	local v5 = {
		[alignment.Top] = {
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		},
		[alignment.Bottom] = {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1)
		}
	}

	return {
		Logo = module.createElement("ImageLabel", {
			Position = authConsoleLayout.robloxLogoTextImagePosition,
			Size = authConsoleLayout.robloxLogoTextImageSize,
			Image = authConsoleLayout.robloxLogoTextImageUrl,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}),
		AlignmentContainer = module.createElement("Frame", {
			Position = authConsoleLayout.buttonContainerPosition,
			Size = UDim2.new(0, authConsoleLayout.containerWidth, 0, authConsoleLayout.containerHeight),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 2,
			ref = p2
		}, {
			Content = module.createElement(fitChildren.FitFrame, {
				Position = v5[contentAlign].Position,
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = fitChildren.FitAxis.Height,
				AnchorPoint = v5[contentAlign].AnchorPoint,
				BackgroundTransparency = 1
			}, { children })
		}),
		Footer = footerElement and module.createElement(module3.View, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 1, -40),
			AnchorPoint = Vector2.new(0.5, 1),
			ZIndex = 3,
			tag = "col align-x-center"
		}, { Content = footerElement }),
		Background = module.createElement(backgroundFill, {
			Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg"
		})
	}
end))
