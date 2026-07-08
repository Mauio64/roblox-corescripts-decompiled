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
local v11 = if not FFlagEnableUISelector then nil else CoreGuiCommon.Stores.GetUiSelectorSignalStore

local function createComputedScrimVisible() -- line: 19
	-- upvalues: Signals (copy), GamepadConnector (copy), ExpChat (copy), FFlagEnableUISelector (copy), v11 (copy)
	return Signals.createComputed(function(p1) -- line: 20
		-- upvalues: GamepadConnector (copy), ExpChat (copy), FFlagEnableUISelector (copy), v11 (copy)
		local v16 = GamepadConnector:topBarFocused(p1)
		local v17 = ExpChat.Stores.GetFocusNavigationStore(p1).getChatInputBarFocused(p1)
		local v18 = FFlagEnableUISelector and v11(p1).getVisibility(p1)

		return v16 or (v17 or v18)
	end)
end
local function TopBarScrim() -- line: 29
	-- upvalues: SignalsReact (copy), createComputedScrimVisible (copy), React (copy), Scrim (copy)
	local v14 = SignalsReact.useSignalBinding(createComputedScrimVisible())

	return React.createElement(Scrim, {
		Visible = v14
	})
end

return React.memo(TopBarScrim)
