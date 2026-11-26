local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/ecq")
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local fFlagUseSignalsForPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForPlatform
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fGm") else nil

local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle

local module2 = require("@luauforge/bundled/dzD")

local module3 = require("@luauforge/bundled/fvR")
local module4 = require("@luauforge/bundled/fGj")
local module5 = require("@luauforge/deferred/fGo")
local module6 = require("@luauforge/deferred/fHR")

local module7 = require("@luauforge/deferred/fGy")

local module8 = require("@luauforge/deferred/fHS")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local module10 = require("@luauforge/bundled/fHT")
local module11 = require("@luauforge/bundled/fHU")
local module12 = require("@luauforge/bundled/fHV")
local module13 = require("@luauforge/bundled/fHw")
local module14 = require("@luauforge/bundled/fAl")
local fFlagNavigationCallbackParam = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagNavigationCallbackParam
local module15 = require("@luauforge/bundled/ehR")

local extended = Roact.PureComponent:extend("DeviceSettingsPage")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	platform = t.EnumItem,
	paddings = t.optional(t.strictInterface({
		paddingHorizontal = t.number,
		paddingVertical = t.number,
		contentMaxWidth = t.number
	})),
	roactAnalytics = t.union(t.Instance, t.table),
	navigationCallback = t.optional(t.string)
})

local function WithHooksComponent(props)
	local paddings = props.paddings
	local backgroundStyle = props.backgroundStyle
	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local v6 = paddings.contentMaxWidth
	local navigationCallback = props.navigationCallback
	local v7

	if fFlagNavigationCallbackParam then
		v7 = React.useMemo(function()
			if navigationCallback == nil then
				return nil
			end

			return (module3.makeBackButton(function()
				return require("@luauforge/bundled/fHW").run(navigationCallback)
			end))
		end, { navigationCallback })
	end

	local v8 = useDesignTokens()
	local v9

	if fFlagUnifyConsoleSettingsPage then
		v9 = useAppPolicy(function(p2): boolean
			return not p2.getWebViewSupport()
		end)
	else
		v9 = false
	end

	local v10 = nil
	local v11 = nil

	if module10 then
		if module14 then
			v11 = module15.useThemeBackground()
		else
			v10 = module12()
		end
	end

	local image = if v10 then v10.image else nil

	local createElement = Roact.createElement
	local v13 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		maxWidth = 0
	}

	if fFlagUnifyConsoleSettingsPage then
		v6 = module2.MORE_PAGE_CONTENT_MAX_WIDTH * v8.Stroke.Standard + paddingHorizontal * 2
	end

	v13.maxWidth = v6

	local createElement2 = Roact.createElement
	local v15 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = 0
	}
	local newUDim = UDim.new

	local v17 = if module7 then v8.Size.Size_600 else module2.MORE_PAGE_SECTION_PADDING
	v15.Padding = newUDim(0, v17)
	local children = {
		Layout = createElement2("UIListLayout", v15),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, paddingHorizontal),
			PaddingRight = UDim.new(0, paddingHorizontal),
			PaddingTop = UDim.new(0, paddingVertical),
			PaddingBottom = UDim.new(0, paddingVertical)
		}),
		Content = 0
	}

	local v18 = if module10 then React.createElement(module13.Provider, {
		value = image
	}, {
		Content = Roact.createElement(module5)
	}) else Roact.createElement(module5)
	children.Content = v18
	local element = createElement(module4, v13, children)

	local createElement3 = Roact.createElement
	local v20 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundStyle.Color,
		BackgroundTransparency = (image or v11) and 1 or backgroundStyle.Transparency
	}

	local v21 = if v10 and image then React.createElement(module11.HomeThemeBackgroundFill, {
		image = image,
		baseColor = backgroundStyle.Color,
		onPageChanged = v10.onPageChanged
	}) else nil

	local createElement4 = Roact.createElement
	local container = module3.Container

	local v23 = if not (fFlagUnifyConsoleSettingsPage and v9) then v7 or module3.BackButton else nil

	local v24 = if v10 and image then React.createElement(module11.HomeThemeBackgroundSlice, {
		image = image,
		baseColor = backgroundStyle.Color,
		pageGeometry = v10.geometry
	}) else nil
	local children2 = {
		ThemeBackground = v21,
		TopBar = createElement4(container, {
			leftItem = v23,
			transparentBackground = image and true or nil,
			backgroundSlot = v24
		}),
		PageContent = 0
	}

	local createElement5 = Roact.createElement
	local pageContent = module3.PageContent

	local v27 = if module8 then Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, v8.Size.Size_1000)
	}) else nil
	children2.PageContent = createElement5(pageContent, {}, {
		UIPadding = v27,
		Scroller = element
	})
	return createElement3("Frame", v20, children2)
end

function extended.render(p2)
	return withStyle(function(p3)
		return Roact.createElement(WithHooksComponent, {
			paddings = p2.props.paddings,
			backgroundStyle = p3.Theme.BackgroundDefault,
			navigationCallback = p2.props.navigationCallback
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
