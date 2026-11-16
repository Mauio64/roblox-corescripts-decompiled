local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/bundled/hHT")
local module3 = require("@luauforge/bundled/hHR")
local module4 = require("@luauforge/bundled/fys")
local module5 = require("@luauforge/bundled/dwA")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module7 = require("@luauforge/bundled/dUd")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function PlatformSettingsPage()
	local surface_0 = useTokens().Color.Surface.Surface_0
	local v5 = useSignalState(module7.GetDisplayStore().getDeviceSafePadding)

	local v6 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v7 = useAppPolicy(function(p2)
		return p2.getAllowPlatformAccountSwitching()
	end)

	local v8 = useLocalization({
		pageTitle = {
			"Feature.Settings.Heading.PlatformAccountSettings",
			platform = v6
		}
	})

	local createElement = React.createElement
	local v10 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = surface_0.Color3,
		BackgroundTransparency = surface_0.Transparency
	}
	local v11 = {
		TopBar = React.createElement(module.Container, { titleText = v8.pageTitle }),
		PageContent = 0
	}

	local createElement2 = React.createElement
	local pageContent = module.PageContent
	local createElement3 = React.createElement
	local v15 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.new(1, 0, 1, v5.bottom)
	}
	local v16 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, module5.MORE_PAGE_SECTION_PADDING),
			PaddingRight = UDim.new(0, module5.MORE_PAGE_SECTION_PADDING),
			PaddingTop = UDim.new(0, module5.MORE_PAGE_SECTION_PADDING),
			PaddingBottom = UDim.new(0, module5.MORE_PAGE_SECTION_PADDING)
		}),
		SwitchProfile = 0,
		PlatformSettings = 0
	}

	local v17 = if v7 then React.createElement(module3, {
		layoutOrder = 1,
		withDivider = true,
		titleKey = nil
	}) else nil
	v16.SwitchProfile = v17

	v16.PlatformSettings = React.createElement(module2, {
		layoutOrder = 2,
		withDivider = false
	})
	v11.PageContent = createElement2(pageContent, {}, {
		Scroller = createElement3(module4, v15, v16)
	})
	return createElement("Frame", v10, v11)
end

return PlatformSettingsPage
