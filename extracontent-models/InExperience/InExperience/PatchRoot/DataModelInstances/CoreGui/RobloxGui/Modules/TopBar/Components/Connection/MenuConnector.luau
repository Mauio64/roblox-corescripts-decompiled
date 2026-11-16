local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SetRespawnBehaviour = require(parent.Actions.SetRespawnBehaviour)

local EventConnection = require(parent.Parent.Common.EventConnection)

local robloxGui = CoreGui:WaitForChild("RobloxGui")
local isNewInGameMenuEnabled = require(robloxGui.Modules.isNewInGameMenuEnabled)

local GetFFlagEnableInGameMenuDurationLogger = require(robloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateRespawnRodux = require(parent.Flags.FFlagTopBarDeprecateRespawnRodux)

local extended = Roact.PureComponent:extend("MenuConnector")

local strictInterface = t.strictInterface
local setMenuOpen

if not FFlagTopBarSignalizeMenuOpen then
	setMenuOpen = t.callback
end

extended.validateProps = strictInterface({
	setMenuOpen = setMenuOpen,
	setRespawnBehaviour = t.callback
})

function extended.didMount(p)
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(robloxGui.Modules.InGameMenuInit)

		if not FFlagTopBarSignalizeMenuOpen then
			p.props.setMenuOpen(InGameMenuInit.getOpen())
		end

		local respawnBehaviour, v = InGameMenuInit.getRespawnBehaviour()
		p.props.setRespawnBehaviour(respawnBehaviour, v)
	else
		local SettingsHub = require(robloxGui.Modules.Settings.SettingsHub)

		if not FFlagTopBarSignalizeMenuOpen then
			p.props.setMenuOpen(SettingsHub:GetVisibility())
		end

		local respawnBehaviour, v = SettingsHub:GetRespawnBehaviour()
		p.props.setRespawnBehaviour(respawnBehaviour, v)
	end
end

function extended.render(p)
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(robloxGui.Modules.InGameMenuInit)
		local openChangedEvent = InGameMenuInit.getOpenChangedEvent()

		local respawnBehaviourChangedEvent = InGameMenuInit.getRespawnBehaviourChangedEvent()

		local createFragment = Roact.createFragment
		local menuOpenChangedConnection

		if not FFlagTopBarSignalizeMenuOpen then
			menuOpenChangedConnection = Roact.createElement(EventConnection, {
				event = openChangedEvent.Event,
				callback = function(p2)
					p.props.setMenuOpen(p2)
				end
			})
		end

		return createFragment({
			MenuOpenChangedConnection = menuOpenChangedConnection,
			RespawnBehaviourConnection = Roact.createElement(EventConnection, {
				event = respawnBehaviourChangedEvent.Event,
				callback = function(p2, p3)
					p.props.setRespawnBehaviour(p2, p3)
				end
			})
		})
	else
		local SettingsHub = require(robloxGui.Modules.Settings.SettingsHub)
		local settingsShowEvent = SettingsHub.SettingsShowEvent

		local respawnBehaviourChangedEvent = SettingsHub.RespawnBehaviourChangedEvent

		local createFragment = Roact.createFragment
		local menuOpenChangedConnection

		if not FFlagTopBarSignalizeMenuOpen then
			menuOpenChangedConnection = Roact.createElement(EventConnection, {
				event = settingsShowEvent.Event,
				callback = function(p2)
					if GetFFlagEnableInGameMenuDurationLogger() and p2 then
						PerfUtils.menuOpenBegin()
					end

					p.props.setMenuOpen(p2)
				end
			})
		end

		return createFragment({
			MenuOpenChangedConnection = menuOpenChangedConnection,
			RespawnBehaviourConnection = Roact.createElement(EventConnection, {
				event = respawnBehaviourChangedEvent.Event,
				callback = function(p2, p3)
					p.props.setRespawnBehaviour(p2, p3)
				end
			})
		})
	end
end

local function mapDispatchToProps(callback)
	return {
		setMenuOpen = not FFlagTopBarSignalizeMenuOpen and function(p)
			return callback(SetMenuOpen(p))
		end or nil,
		setRespawnBehaviour = not FFlagTopBarDeprecateRespawnRodux and (function(p, p2)
			return callback(SetRespawnBehaviour(p, p2))
		end or nil) or nil
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)
