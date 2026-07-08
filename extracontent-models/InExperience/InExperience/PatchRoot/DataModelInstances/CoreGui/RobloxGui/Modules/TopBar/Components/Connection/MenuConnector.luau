local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent
local SetMenuOpen = require(ParentParent.Actions.SetMenuOpen)
local SetRespawnBehaviour = require(ParentParent.Actions.SetRespawnBehaviour)
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local RobloxGui2 = CoreGui:WaitForChild("RobloxGui")
local isNewInGameMenuEnabled = require(RobloxGui2.Modules.isNewInGameMenuEnabled)
local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui2.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
local FFlagTopBarSignalizeMenuOpen = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateRespawnRodux = require(ParentParent.Flags.FFlagTopBarDeprecateRespawnRodux)
local v17 = Roact.PureComponent:extend("MenuConnector")

v17.validateProps = t.strictInterface({
	setMenuOpen = if not FFlagTopBarSignalizeMenuOpen then t.callback else nil,
	setRespawnBehaviour = t.callback
})

function v17.didMount(p1) -- line: 38
	-- upvalues: isNewInGameMenuEnabled (copy), RobloxGui2 (copy), FFlagTopBarSignalizeMenuOpen (copy)
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(RobloxGui2.Modules.InGameMenuInit)

		if not FFlagTopBarSignalizeMenuOpen then
			p1.props.setMenuOpen(InGameMenuInit.getOpen())
		end

		local v21, v22 = InGameMenuInit.getRespawnBehaviour()

		p1.props.setRespawnBehaviour(v21, v22)

		return
	end

	local SettingsHub = require(RobloxGui2.Modules.Settings.SettingsHub)

	if not FFlagTopBarSignalizeMenuOpen then
		p1.props.setMenuOpen(SettingsHub:GetVisibility())
	end

	local v24, v25 = SettingsHub:GetRespawnBehaviour()

	p1.props.setRespawnBehaviour(v24, v25)
end
function v17.render(p2) -- line: 58
	-- upvalues: isNewInGameMenuEnabled (copy), RobloxGui2 (copy), Roact (copy), FFlagTopBarSignalizeMenuOpen (copy), EventConnection (copy), GetFFlagEnableInGameMenuDurationLogger (copy), PerfUtils (copy)
	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(RobloxGui2.Modules.InGameMenuInit)
		local v28 = InGameMenuInit.getOpenChangedEvent()
		local v29 = InGameMenuInit.getRespawnBehaviourChangedEvent()

		return Roact.createFragment({
			MenuOpenChangedConnection = if not FFlagTopBarSignalizeMenuOpen then Roact.createElement(EventConnection, {
				event = v28.Event,
				callback = function(p3) -- line: 70
					-- upvalues: p2 (copy)
					p2.props.setMenuOpen(p3)
				end
			}) else nil,
			RespawnBehaviourConnection = Roact.createElement(EventConnection, {
				event = v29.Event,
				callback = function(p4, p5) -- line: 77
					-- upvalues: p2 (copy)
					p2.props.setRespawnBehaviour(p4, p5)
				end
			})
		})
	end

	local SettingsHub = require(RobloxGui2.Modules.Settings.SettingsHub)
	local SettingsShowEvent = SettingsHub.SettingsShowEvent
	local RespawnBehaviourChangedEvent = SettingsHub.RespawnBehaviourChangedEvent

	return Roact.createFragment({
		MenuOpenChangedConnection = if not FFlagTopBarSignalizeMenuOpen then Roact.createElement(EventConnection, {
			event = SettingsShowEvent.Event,
			callback = function(p6) -- line: 91
				-- upvalues: GetFFlagEnableInGameMenuDurationLogger (copy), PerfUtils (copy), p2 (copy)
				if GetFFlagEnableInGameMenuDurationLogger() and p6 then
					PerfUtils.menuOpenBegin()
				end

				p2.props.setMenuOpen(p6)
			end
		}) else nil,
		RespawnBehaviourConnection = Roact.createElement(EventConnection, {
			event = RespawnBehaviourChangedEvent.Event,
			callback = function(p7, p8) -- line: 101
				-- upvalues: p2 (copy)
				p2.props.setRespawnBehaviour(p7, p8)
			end
		})
	})
end

local function mapDispatchToProps(p9) -- line: 109
	-- upvalues: FFlagTopBarSignalizeMenuOpen (copy), SetMenuOpen (copy), FFlagTopBarDeprecateRespawnRodux (copy), SetRespawnBehaviour (copy)
	return {
		setMenuOpen = not FFlagTopBarSignalizeMenuOpen and function(p10) -- line: 111
			-- upvalues: p9 (copy), SetMenuOpen (copy)
			return p9(SetMenuOpen(p10))
		end or nil,
		setRespawnBehaviour = if not FFlagTopBarDeprecateRespawnRodux then function(p11, p12) -- line: 115
			-- upvalues: p9 (copy), SetRespawnBehaviour (copy)
			return p9(SetRespawnBehaviour(p11, p12))
		end or nil else nil
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v17)
