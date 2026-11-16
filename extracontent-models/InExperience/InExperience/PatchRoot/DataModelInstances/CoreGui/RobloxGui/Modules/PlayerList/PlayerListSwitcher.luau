local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Style = require(CorePackages.Workspace.Packages.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider

local parent = script.Parent
local connection = parent.Components.Connection

local PlayerListApp = require(parent.Components.Presentation.PlayerListApp)
local PlayerListApp2 = require(parent.Components.PresentationMobile.PlayerListApp)

local LayoutValues = require(connection.LayoutValues)
local Provider = LayoutValues.Provider
local CreateLayoutValues = require(parent.CreateLayoutValues)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local SetPlayerListVisibility = require(parent.Actions.SetPlayerListVisibility)
local PlayerListInitialVisibleState = require(parent.PlayerListInitialVisibleState)

local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListTwoTabsOnLegacy = PlayerList.Flags.FFlagPlayerListTwoTabsOnLegacy
local FFlagPlayerListKeepModalHiddenOnRemount = require(parent.Flags.FFlagPlayerListKeepModalHiddenOnRemount)
local PlatformLeaderboardContainer = PlayerList.Container.PlatformLeaderboardContainer

local extended = Roact.PureComponent:extend("PlayerListSwitcher")

function extended.didMount(p)
	if FFlagPlayerListKeepModalHiddenOnRemount and p.props.isSmallTouchDevice then
		p.props.setPlayerListVisible(false)
	else
		p.props.setPlayerListVisible(PlayerListInitialVisibleState())
	end
end

function extended:wrapWithUiModeStyleProvider(p)
	return {
		ThemeProvider = Roact.createElement(UiModeStyleProvider, {
			style = {
				themeName = self.props.appStyleForUiModeStyleProvider.themeName,
				fontName = self.props.appStyleForUiModeStyleProvider.fontName
			}
		}, p)
	}
end

function extended:render()
	local createElement = Roact.createElement
	local v

	if FFlagEnableMobilePlayerListOnConsole then
		v = false
	else
		v = TenFootInterface:IsEnabled()
	end

	local element = createElement(Provider, { layoutValues = CreateLayoutValues(v) }, self:wrapWithUiModeStyleProvider({
		PlayerListApp = self.props.isSmallTouchDevice and Roact.createElement(PlayerListApp2, {
			setLayerCollectorEnabled = self.props.setLayerCollectorEnabled
		}) or Roact.createElement(PlayerListApp, {
			setLayerCollectorEnabled = self.props.setLayerCollectorEnabled
		})
	}))

	if FFlagPlayerListTwoTabsOnLegacy then
		return Roact.createElement(PlatformLeaderboardContainer, {}, element)
	end

	return element
end

function extended.didUpdate(p)
	p.props.setPlayerListVisible(not p.props.isSmallTouchDevice)
end

local function mapStateToProps(p)
	return { isSmallTouchDevice = p.displayOptions.isSmallTouchDevice }
end

local function mapDispatchToProps(callback)
	return {
		setPlayerListVisible = function(p)
			return callback(SetPlayerListVisibility(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
