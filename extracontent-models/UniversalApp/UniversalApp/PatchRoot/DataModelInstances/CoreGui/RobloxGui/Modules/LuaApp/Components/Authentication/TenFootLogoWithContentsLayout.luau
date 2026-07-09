local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FitChildren = require(Modules.LuaApp.FitChildren)
local Alignment = require(Modules.LuaApp.Enum.Alignment)
local Foundation = require(CorePackages.Packages.Foundation)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local BackgroundFill = require(CorePackages.Workspace.Packages.AuthCommon).Components.BackgroundFill
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

return (React.forwardRef(function(p1, p2) -- line: 18
	-- upvalues: useDesignTokens (copy), Alignment (copy), React (copy), FitChildren (copy), Foundation (copy), FFlagEnableLeftNavOnConsole (copy), BackgroundFill (copy)
	local EngagementScreen = useDesignTokens().LuaApps.EngagementScreen
	local children = p1.children
	local v14 = p1.ContentAlign or Alignment.Top
	local FooterElement = p1.FooterElement
	local t1 = {
		[Alignment.Top] = {
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		},
		[Alignment.Bottom] = {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1)
		}
	}

	return {
		Logo = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Position = EngagementScreen.robloxLogoTextImagePosition,
			Size = EngagementScreen.robloxLogoTextImageSize,
			Image = EngagementScreen.robloxLogoTextImageUrl,
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		AlignmentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = EngagementScreen.buttonContainerPosition,
			Size = UDim2.new(0, EngagementScreen.containerWidth, 0, EngagementScreen.containerHeight),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ref = p2
		}, {
			Content = React.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				Position = t1[v14].Position,
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = FitChildren.FitAxis.Height,
				AnchorPoint = t1[v14].AnchorPoint
			}, { children })
		}),
		Footer = FooterElement and React.createElement(Foundation.View, {
			ZIndex = 3,
			tag = "col align-x-center",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 1, -40),
			AnchorPoint = Vector2.new(0.5, 1)
		}, {
			Content = FooterElement
		}),
		Background = if not FFlagEnableLeftNavOnConsole then nil else React.createElement(BackgroundFill, {
			Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg"
		})
	}
end))
