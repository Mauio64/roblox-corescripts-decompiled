local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ParentParent = script.Parent.Parent
local FFlagTopBarDeprecateCoreGuiRodux = require(ParentParent.Flags.FFlagTopBarDeprecateCoreGuiRodux)
local FFlagTopBarDeprecateChatRodux = require(ParentParent.Flags.FFlagTopBarDeprecateChatRodux)
local FFlagTopBarDeprecateDisplayOptionsRodux = require(ParentParent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local FFlagTopBarDeprecateRespawnRodux = require(ParentParent.Flags.FFlagTopBarDeprecateRespawnRodux)
local FFlagTopBarDeprecateMoreMenuRodux = require(ParentParent.Flags.FFlagTopBarDeprecateMoreMenuRodux)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local CoreGuiConnector = require(script.CoreGuiConnector)
local MenuConnector = require(script.MenuConnector)
local ChatConnector = require(script.ChatConnector)
local HealthConnector = require(script.HealthConnector)
local EnabledNotifier = require(script.EnabledNotifier)
local OpenUIConnector = require(script.OpenUIConnector)

require(script.LastInputTypeConnector)

local v18 = Roact.PureComponent:extend("Connection")

function v18.render(_) -- line: 26
	-- upvalues: Roact (copy), FFlagTopBarDeprecateCoreGuiRodux (copy), CoreGuiConnector (copy), FFlagTopBarSignalizeMenuOpen (copy), FFlagTopBarDeprecateRespawnRodux (copy), MenuConnector (copy), FFlagTopBarDeprecateChatRodux (copy), ChatConnector (copy), FFlagTopBarSignalizeHealthBar (copy), HealthConnector (copy), FFlagTopBarDeprecateDisplayOptionsRodux (copy), EnabledNotifier (copy), FFlagTopBarDeprecateMoreMenuRodux (copy), OpenUIConnector (copy)
	return Roact.createFragment({
		CoreGuiConnector = if not FFlagTopBarDeprecateCoreGuiRodux then Roact.createElement(CoreGuiConnector) else nil,
		MenuConnector = if not FFlagTopBarSignalizeMenuOpen or not FFlagTopBarDeprecateRespawnRodux then Roact.createElement(MenuConnector) else nil,
		ChatConnector = if not FFlagTopBarDeprecateChatRodux then Roact.createElement(ChatConnector) else nil,
		HealthConnector = if not FFlagTopBarSignalizeHealthBar then Roact.createElement(HealthConnector) else nil,
		EnabledNotifier = if not FFlagTopBarDeprecateDisplayOptionsRodux then Roact.createElement(EnabledNotifier) else nil,
		OpenUIConnector = if not FFlagTopBarDeprecateMoreMenuRodux then Roact.createElement(OpenUIConnector) else nil
	})
end

return v18
