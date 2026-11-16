local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local fFlagEnableAddAuthMethodPageEmailSignup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAddAuthMethodPageEmailSignup

local module = require("@luauforge/bundled/fNe")

local function PageWithDisclaimerLinks(p2)
	local children = p2.children
	local showFooter = p2.showFooter
	local v5 = useTokens()
	local size_1400 = v5.Size.Size_1400

	if fFlagEnableAddAuthMethodPageEmailSignup and showFooter then
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Page = React.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, -size_1400),
				BackgroundTransparency = 1
			}, children),
			Footer = React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, size_1400),
					BackgroundTransparency = 1
				},
				{
					FooterPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v5.Padding.Large)
					}),
					FooterLayout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Links = React.createElement(module, {
						fillDirection = Enum.FillDirection.Horizontal
					})
				}
			)
		})
	end

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
		children
	)
end

return PageWithDisclaimerLinks
