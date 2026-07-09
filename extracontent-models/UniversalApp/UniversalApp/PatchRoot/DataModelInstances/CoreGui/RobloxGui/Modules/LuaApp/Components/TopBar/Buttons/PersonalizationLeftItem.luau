local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v6 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local Cryo = require(CorePackages.Packages.Cryo)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ProfileLeftHeader = require(Modules.LuaApp.Components.TopBar.Buttons.ProfileLeftHeader)
local makeBackButton = require(Modules.LuaApp.Components.TopBar.Buttons.makeBackButton)
local shouldShowProfileInHeaderBar = require(Modules.LuaApp.Components.TopBar.Utils.shouldShowProfileInHeaderBar)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagEnableHomeRobloxLogo = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableHomeRobloxLogo
local FlyoutLeftHeader = nil
local FlyoutSidePanelIXP = nil
local shouldShowLeftHeader = nil

if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
	FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP

	local FlyoutSidePanel = require(CorePackages.Workspace.Packages.FlyoutSidePanel)

	FlyoutLeftHeader = FlyoutSidePanel.Components.FlyoutLeftHeader
	shouldShowLeftHeader = FlyoutSidePanel.Utils.shouldShowLeftHeader
end

local v21 = React.Component:extend("PersonalizationLeftItem")

function v21.init(p1, _) -- line: 54
	-- upvalues: makeBackButton (copy)
	p1.backButton = makeBackButton(nil)
end

local function shouldShowAvatarHeader(p3) -- line: 58
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), shouldShowLeftHeader (ref), shouldShowProfileInHeaderBar (copy)
	local name = p3.currentRoute[1].name
	local name2 = p3.currentRoute[#p3.currentRoute].name

	if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
		local routeName = p3.routeName

		return shouldShowLeftHeader(routeName, name2, p3.isSearching)
	end

	return shouldShowProfileInHeaderBar(name, name2, p3.formFactor, p3.isSearching)
end

function v21.didMount(p4) -- line: 70
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), shouldShowLeftHeader (ref), shouldShowProfileInHeaderBar (copy)
	if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
		local props = p4.props
		local name = props.currentRoute[1].name
		local name3 = props.currentRoute[#props.currentRoute].name
		local v36

		if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
			local routeName = props.routeName

			v36 = shouldShowLeftHeader(routeName, name3, props.isSearching)
		else
			v36 = shouldShowProfileInHeaderBar(name, name3, props.formFactor, props.isSearching)
		end

		if v36 then
			p4.props.setVisible(v36)
		end
	end
end
function v21.didUpdate(p5, p6) -- line: 81
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), shouldShowLeftHeader (ref), shouldShowProfileInHeaderBar (copy)
	local name = p6.currentRoute[1].name
	local name4 = p6.currentRoute[#p6.currentRoute].name
	local v42

	if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
		local routeName = p6.routeName

		v42 = shouldShowLeftHeader(routeName, name4, p6.isSearching)
	else
		v42 = shouldShowProfileInHeaderBar(name, name4, p6.formFactor, p6.isSearching)
	end

	local props = p5.props
	local name5 = props.currentRoute[1].name
	local name6 = props.currentRoute[#props.currentRoute].name
	local v47

	if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
		local routeName = props.routeName

		v47 = shouldShowLeftHeader(routeName, name6, props.isSearching)
	else
		v47 = shouldShowProfileInHeaderBar(name5, name6, props.formFactor, props.isSearching)
	end

	if v42 ~= v47 then
		p5.props.setVisible(v47)
	end
end
function v21.render(p7) -- line: 90
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), shouldShowLeftHeader (ref), shouldShowProfileInHeaderBar (copy), React (copy), FlyoutLeftHeader (ref), FlyoutSidePanelIXP (ref), ProfileLeftHeader (copy)
	local props = p7.props
	local name = props.currentRoute[1].name
	local name7 = props.currentRoute[#props.currentRoute].name
	local v53

	if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
		local routeName = props.routeName

		v53 = shouldShowLeftHeader(routeName, name7, props.isSearching)
	else
		v53 = shouldShowProfileInHeaderBar(name, name7, props.formFactor, props.isSearching)
	end

	if v53 then
		if FFlagEnableFlyoutSidePanel or FFlagEnableHomeRobloxLogo then
			return React.createElement(FlyoutLeftHeader, {
				formFactor = p7.props.formFactor,
				titleText = p7.props.titleText,
				buttonRef = p7.props.buttonRef,
				routeName = p7.props.routeName,
				isFlyoutEntrypointEnabled = if not FFlagEnableHomeRobloxLogo then nil else FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
				isRobloxLogoEnabled = not not FFlagEnableHomeRobloxLogo or FlyoutSidePanelIXP.isRobloxLogoEnabled(),
				isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
			})
		end

		return React.createElement(ProfileLeftHeader, {
			formFactor = p7.props.formFactor,
			titleText = p7.props.titleText,
			buttonRef = p7.props.buttonRef
		})
	end

	return React.createElement(p7.backButton, {
		formFactor = p7.props.formFactor,
		isCompactView = p7.props.isCompactView,
		isSearching = p7.props.isSearching,
		isSecondary = p7.props.isSecondary,
		cancelSearch = p7.props.cancelSearch,
		activateSearch = p7.props.activateSearch,
		setVisible = p7.props.setVisible,
		buttonRef = p7.props.buttonRef
	})
end

local v24

if FFlagSignalsNavP3bTopBar then
	local v23 = v21

	function v24(p8) -- line: 129
		-- upvalues: v6 (copy), useSignalState (copy), React (copy), v23 (copy), Cryo (copy)
		local v55 = v6(false)
		local v56 = useSignalState(v55.getCurrentLegacyRoute)

		return React.createElement(v23, Cryo.Dictionary.union(p8, {
			currentRoute = v56
		}))
	end
else
	v24 = RoactRodux.connect(function(p9, _) -- line: 140
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
		return {
			currentRoute = if not FFlagUseNavigationSelectors then p9.Navigation.history[#p9.Navigation.history] else Selectors.selectCurrentLegacyRoute(p9)
		}
	end)(v21)
end

return v24
