local CorePackages = game:GetService("CorePackages")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local Cryo = require(CorePackages.Packages.Cryo)
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local Foundation = require(CorePackages.Packages.Foundation)
local themeName = Foundation.Enums.ThemeName

local module2 = require("@luauforge/bundled/ftb")
local module3 = require("@luauforge/bundled/fsW")
local module4 = require("@luauforge/bundled/fsN")

local module5 = require("@luauforge/bundled/dHC")
local fFlagEnableHomeRobloxLogo = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableHomeRobloxLogo
local flyoutSidePanelIXP, flyoutLeftHeader, shouldShowLeftHeader

if module5 or fFlagEnableHomeRobloxLogo then
	flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP
	local module6 = require("@luauforge/bundled/fsS")
	flyoutLeftHeader = module6.Components.FlyoutLeftHeader
	shouldShowLeftHeader = module6.Utils.shouldShowLeftHeader
else
	shouldShowLeftHeader = nil
	flyoutLeftHeader = nil
	flyoutSidePanelIXP = nil
end

local extended = React.Component:extend("PersonalizationLeftItem")

function extended:init(p3)
	self.backButton = module3(nil)
end

local function shouldShowAvatarHeader(data)
	local name = data.currentRoute[1].name
	local name2 = data.currentRoute[#data.currentRoute].name

	if module5 or fFlagEnableHomeRobloxLogo then
		return shouldShowLeftHeader(data.routeName, name2, data.isSearching)
	end

	return module4(name, name2, data.formFactor, data.isSearching)
end

function extended.didMount(p2)
	if module5 or fFlagEnableHomeRobloxLogo then
		local v5

		if fFlagSignalsNavP3bTopBar then
			v5 = p2.props.showAvatarHeader
		else
			local props = p2.props
			local name = props.currentRoute[1].name
			local name2 = props.currentRoute[#props.currentRoute].name

			if module5 or fFlagEnableHomeRobloxLogo then
				v5 = shouldShowLeftHeader(props.routeName, name2, props.isSearching)
			else
				v5 = module4(name, name2, props.formFactor, props.isSearching)
			end
		end

		if v5 then
			p2.props.setVisible(v5)
		end
	end
end

function extended.didUpdate(p2, data)
	local v5

	if fFlagSignalsNavP3bTopBar then
		v5 = data.showAvatarHeader
	else
		local name = data.currentRoute[1].name
		local name2 = data.currentRoute[#data.currentRoute].name

		if module5 or fFlagEnableHomeRobloxLogo then
			v5 = shouldShowLeftHeader(data.routeName, name2, data.isSearching)
		else
			v5 = module4(name, name2, data.formFactor, data.isSearching)
		end
	end

	local v6

	if fFlagSignalsNavP3bTopBar then
		v6 = p2.props.showAvatarHeader
	else
		local props = p2.props
		local name = props.currentRoute[1].name
		local name2 = props.currentRoute[#props.currentRoute].name

		if module5 or fFlagEnableHomeRobloxLogo then
			v6 = shouldShowLeftHeader(props.routeName, name2, props.isSearching)
		else
			v6 = module4(name, name2, props.formFactor, props.isSearching)
		end
	end

	if v5 ~= v6 then
		p2.props.setVisible(v6)
	end
end

function extended.render(p2)
	local v5

	if fFlagSignalsNavP3bTopBar then
		v5 = p2.props.showAvatarHeader
	else
		local props = p2.props
		local name = props.currentRoute[1].name
		local name2 = props.currentRoute[#props.currentRoute].name

		if module5 or fFlagEnableHomeRobloxLogo then
			v5 = shouldShowLeftHeader(props.routeName, name2, props.isSearching)
		else
			v5 = module4(name, name2, props.formFactor, props.isSearching)
		end
	end

	if not v5 then
		return React.createElement(p2.backButton, {
			formFactor = p2.props.formFactor,
			isCompactView = p2.props.isCompactView,
			isSearching = p2.props.isSearching,
			isSecondary = p2.props.isSecondary,
			cancelSearch = p2.props.cancelSearch,
			activateSearch = p2.props.activateSearch,
			setVisible = p2.props.setVisible,
			buttonRef = p2.props.buttonRef
		})
	end

	if not (module5 or fFlagEnableHomeRobloxLogo) then
		return React.createElement(module2, {
			formFactor = p2.props.formFactor,
			titleText = p2.props.titleText,
			buttonRef = p2.props.buttonRef,
			isClassicTheme = p2.props.isClassicTheme
		})
	end

	local createElement = React.createElement
	local v7 = {
		formFactor = p2.props.formFactor,
		titleText = p2.props.titleText,
		buttonRef = p2.props.buttonRef,
		routeName = p2.props.routeName,
		isFlyoutEntrypointEnabled = 0,
		isRobloxLogoEnabled = 0,
		isAlternateEntryPointEnabled = 0,
		useHeaderLogo = true
	}

	local v8 = if fFlagEnableHomeRobloxLogo then flyoutSidePanelIXP.isFlyoutSidePanelEnabled() else nil
	v7.isFlyoutEntrypointEnabled = v8

	v7.isRobloxLogoEnabled = fFlagEnableHomeRobloxLogo and true or flyoutSidePanelIXP.isRobloxLogoEnabled()
	v7.isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
	return createElement(flyoutLeftHeader, v7)
end

local function mapStateToProps(p2)
	local v6 = if fFlagUseNavigationSelectors then selectors.selectCurrentLegacyRoute(p2) else p2.Navigation.history[#p2.Navigation.history]
	return { currentRoute = v6 }
end

local v5

if fFlagSignalsNavP3bTopBar then
	local function PersonalizationLeftItemWithSignals(props)
		local legacyNavigationStore = getLegacyNavigationStore(false)
		local formFactor = props.formFactor
		local isSearching = props.isSearching
		local routeName = props.routeName
		local v7 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				return shouldShowAvatarHeader({
					currentRoute = legacyNavigationStore.getCurrentLegacyRoute(p2),
					formFactor = formFactor,
					isSearching = isSearching,
					routeName = routeName
				})
			end)
		end, { legacyNavigationStore, formFactor, isSearching, routeName })))
		return React.createElement(extended, Cryo.Dictionary.union(props, {
			showAvatarHeader = v7
		}))
	end

	v5 = React.memo(PersonalizationLeftItemWithSignals)
else
	v5 = RoactRodux.connect(mapStateToProps)(extended)
end

local function PersonalizationLeftItemWithTheme(p2)
	local name = Foundation.Hooks.useTokens().Config.Theme.Name
	return React.createElement(v5, Cryo.Dictionary.union(p2, {
		isClassicTheme = name == themeName.Classic
	}))
end

return React.memo(PersonalizationLeftItemWithTheme)
