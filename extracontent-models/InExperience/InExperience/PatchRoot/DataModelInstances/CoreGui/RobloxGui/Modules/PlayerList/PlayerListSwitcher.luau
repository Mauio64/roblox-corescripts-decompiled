local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider
local scriptParent = script.Parent
local Connection = scriptParent.Components.Connection
local PlayerListApp = require(scriptParent.Components.Presentation.PlayerListApp)
local PlayerListApp2 = require(scriptParent.Components.PresentationMobile.PlayerListApp)
local Provider = require(Connection.LayoutValues).Provider
local CreateLayoutValues = require(scriptParent.CreateLayoutValues)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local SetPlayerListVisibility = require(scriptParent.Actions.SetPlayerListVisibility)
local PlayerListInitialVisibleState = require(scriptParent.PlayerListInitialVisibleState)
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local v17 = Roact.PureComponent:extend("PlayerListSwitcher")

function v17.didMount(p1) -- line: 28
	-- upvalues: PlayerListInitialVisibleState (copy)
	p1.props.setPlayerListVisible(PlayerListInitialVisibleState())
end
function v17.wrapWithUiModeStyleProvider(p2, p3) -- line: 32
	-- upvalues: Roact (copy), UiModeStyleProvider (copy)
	return {
		ThemeProvider = Roact.createElement(UiModeStyleProvider, {
			style = {
				themeName = p2.props.appStyleForUiModeStyleProvider.themeName,
				fontName = p2.props.appStyleForUiModeStyleProvider.fontName
			}
		}, p3)
	}
end
function v17.render(p4) -- line: 43
	-- upvalues: Roact (copy), Provider (copy), CreateLayoutValues (copy), FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), PlayerListApp2 (copy), PlayerListApp (copy)
	return Roact.createElement(Provider, {
		layoutValues = CreateLayoutValues(not FFlagEnableMobilePlayerListOnConsole and TenFootInterface:IsEnabled())
	}, p4:wrapWithUiModeStyleProvider({
		PlayerListApp = p4.props.isSmallTouchDevice and Roact.createElement(PlayerListApp2, {
			setLayerCollectorEnabled = p4.props.setLayerCollectorEnabled
		}) or Roact.createElement(PlayerListApp, {
			setLayerCollectorEnabled = p4.props.setLayerCollectorEnabled
		})
	}))
end
function v17.didUpdate(p5) -- line: 59
	p5.props.setPlayerListVisible(not p5.props.isSmallTouchDevice)
end

local function mapStateToProps(p6) -- line: 63
	return {
		isSmallTouchDevice = p6.displayOptions.isSmallTouchDevice
	}
end
local function mapDispatchToProps(p7) -- line: 69
	-- upvalues: SetPlayerListVisibility (copy)
	return {
		setPlayerListVisible = function(p8) -- line: 71
			-- upvalues: p7 (copy), SetPlayerListVisibility (copy)
			return p7(SetPlayerListVisibility(p8))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v17)
