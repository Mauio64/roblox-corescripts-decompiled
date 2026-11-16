local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local parent = script.Parent.Parent
local FFlagTopBarDeprecateCoreGuiRodux = require(parent.Flags.FFlagTopBarDeprecateCoreGuiRodux)
local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)
local FFlagTopBarDeprecateDisplayOptionsRodux = require(parent.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local FFlagTopBarDeprecateRespawnRodux = require(parent.Flags.FFlagTopBarDeprecateRespawnRodux)
local FFlagTopBarDeprecateMoreMenuRodux = require(parent.Flags.FFlagTopBarDeprecateMoreMenuRodux)

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

local extended = Roact.PureComponent:extend("Connection")

function extended.render(_)
	local createFragment = Roact.createFragment
	local coreGuiConnector

	if not FFlagTopBarDeprecateCoreGuiRodux then
		coreGuiConnector = Roact.createElement(CoreGuiConnector)
	end

	local menuConnector

	if not (FFlagTopBarSignalizeMenuOpen and FFlagTopBarDeprecateRespawnRodux) then
		menuConnector = Roact.createElement(MenuConnector)
	end

	local chatConnector

	if not FFlagTopBarDeprecateChatRodux then
		chatConnector = Roact.createElement(ChatConnector)
	end

	local healthConnector

	if not FFlagTopBarSignalizeHealthBar then
		healthConnector = Roact.createElement(HealthConnector)
	end

	local enabledNotifier

	if not FFlagTopBarDeprecateDisplayOptionsRodux then
		enabledNotifier = Roact.createElement(EnabledNotifier)
	end

	local openUIConnector

	if not FFlagTopBarDeprecateMoreMenuRodux then
		openUIConnector = Roact.createElement(OpenUIConnector)
	end

	return createFragment({
		CoreGuiConnector = coreGuiConnector,
		MenuConnector = menuConnector,
		ChatConnector = chatConnector,
		HealthConnector = healthConnector,
		EnabledNotifier = enabledNotifier,
		OpenUIConnector = openUIConnector
	})
end

return extended
