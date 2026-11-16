local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/bundled/hIM")
local module3 = require("@luauforge/bundled/dwA")
local module4 = require("@luauforge/bundled/fys")

local function AccountSettingsPage()
	local surface_0 = useTokens().Color.Surface.Surface_0
	local v5, v6 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()

	return React.createElement("Frame", {
		ref = v6,
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = surface_0.Color3,
		BackgroundTransparency = surface_0.Transparency,
		SelectionGroup = true,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}, {
		TopBar = React.createElement(module.Container, {}),
		PageContent = React.createElement(module.PageContent, {}, {
			Scroller = React.createElement(
				module4,
				{ Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1) },
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING),
						PaddingRight = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING),
						PaddingTop = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING),
						PaddingBottom = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING)
					}),
					AccountInfo = React.createElement(module2, {
						layoutOrder = 1,
						itemData = { itemType = "Settings_AccountSettingsInfo" }
					})
				}
			)
		})
	})
end

return AccountSettingsPage
