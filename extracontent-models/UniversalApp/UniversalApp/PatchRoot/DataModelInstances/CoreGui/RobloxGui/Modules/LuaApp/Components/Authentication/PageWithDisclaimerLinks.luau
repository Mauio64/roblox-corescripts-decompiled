local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local FFlagEnableAddAuthMethodPageEmailSignup = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAddAuthMethodPageEmailSignup
local DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)

local function PageWithDisclaimerLinks(p1) -- line: 12
	-- upvalues: useTokens (copy), FFlagEnableAddAuthMethodPageEmailSignup (copy), React (copy), DisclaimerLinks (copy)
	local children = p1.children
	local showFooter = p1.showFooter
	local v11 = useTokens()
	local Size_1400 = v11.Size.Size_1400

	if not FFlagEnableAddAuthMethodPageEmailSignup or not showFooter then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, children)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Page = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -Size_1400)
		}, children),
		Footer = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Size_1400)
		}, {
			FooterPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v11.Padding.Large)
			}),
			FooterLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Links = React.createElement(DisclaimerLinks, {
				fillDirection = Enum.FillDirection.Horizontal
			})
		})
	})
end

return PageWithDisclaimerLinks
