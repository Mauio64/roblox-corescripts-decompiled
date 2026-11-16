local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local GamepadConnector = require(script.Parent.GamepadConnector)
local Scrim = CoreScriptsRoactCommon.Scrim

local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector
local getUiSelectorSignalStore

if FFlagEnableUISelector then
	getUiSelectorSignalStore = CoreGuiCommon.Stores.GetUiSelectorSignalStore
else
	getUiSelectorSignalStore = nil
end

local function createComputedScrimVisible()
	return Signals.createComputed(function(p)
		local topBarFocused = GamepadConnector:topBarFocused(p)
		local chatInputBarFocused = ExpChat.Stores.GetFocusNavigationStore(p).getChatInputBarFocused(p)
		local v = FFlagEnableUISelector and getUiSelectorSignalStore(p).getVisibility(p)
		return topBarFocused or chatInputBarFocused or v
	end)
end

local function TopBarScrim()
	local visible = SignalsReact.useSignalBinding(createComputedScrimVisible())

	return React.createElement(Scrim, { Visible = visible })
end

return React.memo(TopBarScrim)
