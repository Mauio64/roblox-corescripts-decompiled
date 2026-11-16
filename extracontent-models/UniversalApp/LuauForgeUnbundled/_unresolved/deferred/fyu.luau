local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/dYT")
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local fFlagUseSignalsForPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForPlatform
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fyv") else nil

local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle

local module2 = require("@luauforge/bundled/dwA")

local module3 = require("@luauforge/bundled/fox")
local module4 = require("@luauforge/bundled/fys")
local module5 = require("@luauforge/deferred/fyx")
local module6 = require("@luauforge/deferred/fAc")

local module7 = require("@luauforge/deferred/fyI")

local module8 = require("@luauforge/deferred/fAd")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local module10 = require("@luauforge/bundled/fAe")
local module11 = require("@luauforge/bundled/fAf")
local module12 = require("@luauforge/bundled/fAg")
local module13 = require("@luauforge/bundled/fzH")
local module14 = require("@luauforge/bundled/fsR")
local module15 = require("@luauforge/bundled/eeu")

local extended = Roact.PureComponent:extend("DeviceSettingsPage")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	platform = t.EnumItem,
	paddings = t.optional(t.strictInterface({
		paddingHorizontal = t.number,
		paddingVertical = t.number,
		contentMaxWidth = t.number
	})),
	roactAnalytics = t.union(t.Instance, t.table)
})

local function WithHooksComponent(p2)
	local paddings = p2.paddings
	local backgroundStyle = p2.backgroundStyle
	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local v6 = paddings.contentMaxWidth
	local v7 = useDesignTokens()
	local v8

	if fFlagUnifyConsoleSettingsPage then
		v8 = useAppPolicy(function(p3): boolean
			return not p3.getWebViewSupport()
		end)
	else
		v8 = false
	end

	local v9 = nil
	local v10 = nil

	if module10 then
		if module14 then
			v10 = module15.useThemeBackground()
		else
			v9 = module12()
		end
	end

	local image = if v9 then v9.image else nil

	local createElement = Roact.createElement
	local v12 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		maxWidth = 0
	}

	if fFlagUnifyConsoleSettingsPage then
		v6 = module2.MORE_PAGE_CONTENT_MAX_WIDTH * v7.Stroke.Standard + paddingHorizontal * 2
	end

	v12.maxWidth = v6

	local createElement2 = Roact.createElement
	local v14 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = 0
	}
	local newUDim = UDim.new

	local v16 = if module7 then v7.Size.Size_600 else module2.MORE_PAGE_SECTION_PADDING
	v14.Padding = newUDim(0, v16)
	local children = {
		Layout = createElement2("UIListLayout", v14),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, paddingHorizontal),
			PaddingRight = UDim.new(0, paddingHorizontal),
			PaddingTop = UDim.new(0, paddingVertical),
			PaddingBottom = UDim.new(0, paddingVertical)
		}),
		Content = 0
	}

	local v17 = if module10 then React.createElement(module13.Provider, {
		value = image
	}, {
		Content = Roact.createElement(module5)
	}) else Roact.createElement(module5)
	children.Content = v17
	local element = createElement(module4, v12, children)

	local createElement3 = Roact.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundStyle.Color,
		BackgroundTransparency = (image or v10) and 1 or backgroundStyle.Transparency
	}

	local v20 = if v9 and image then React.createElement(module11.HomeThemeBackgroundFill, {
		image = image,
		baseColor = backgroundStyle.Color,
		onPageChanged = v9.onPageChanged
	}) else nil

	local createElement4 = Roact.createElement
	local container = module3.Container
	local v22 = if not (fFlagUnifyConsoleSettingsPage and v8) then module3.BackButton else nil

	local v23 = if v9 and image then React.createElement(module11.HomeThemeBackgroundSlice, {
		image = image,
		baseColor = backgroundStyle.Color,
		pageGeometry = v9.geometry
	}) else nil
	local children2 = {
		ThemeBackground = v20,
		TopBar = createElement4(container, {
			leftItem = v22,
			transparentBackground = image and true or nil,
			backgroundSlot = v23
		}),
		PageContent = 0
	}

	local createElement5 = Roact.createElement
	local pageContent = module3.PageContent

	local v26 = if module8 then Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, v7.Size.Size_1000)
	}) else nil
	children2.PageContent = createElement5(pageContent, {}, {
		UIPadding = v26,
		Scroller = element
	})
	return createElement3("Frame", v19, children2)
end

function extended.render(p2)
	return withStyle(function(p3)
		return Roact.createElement(WithHooksComponent, {
			paddings = p2.props.paddings,
			backgroundStyle = p3.Theme.BackgroundDefault
		})
	end)
end

function extended.willUnmount(p2)
	if game:GetEngineFeature("GlobalBasicSettingsSaveStateReflection") then
		task.spawn(function()
			UserSettings():SaveState()
		end)
	end
end

local v6 = RoactRodux.connect(function(p2, p3)
	local v7 = { formFactor = p2.FormFactor, platform = 0 }
	local v8 = if not fFlagUseSignalsForPlatform then p2.Platform else nil
	v7.platform = v8
	return v7
end)(extended)
local v7

if fFlagUseSignalsForPlatform then
	local function DeviceSettingsPageWithSignals(p2)
		local v8 = useSignalState(v5(false).getPlatform)
		return Roact.createElement(v6, Cryo.Dictionary.union(p2, { platform = v8 }))
	end

	v7 = React.memo(DeviceSettingsPageWithSignals)
else
	v7 = v6
end

return module6((roactServices.connect({ roactAnalytics = module })(v7)))
