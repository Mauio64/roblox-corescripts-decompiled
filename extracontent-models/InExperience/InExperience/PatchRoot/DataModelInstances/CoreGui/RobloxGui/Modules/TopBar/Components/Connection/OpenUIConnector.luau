local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateMoreMenuRodux) then
	return nil
end

local SetBackpackOpen = require(ParentParent.Actions.SetBackpackOpen)
local SetEmotesOpen = require(ParentParent.Actions.SetEmotesOpen)
local SetLeaderboardOpen = require(ParentParent.Actions.SetLeaderboardOpen)
local SetEmotesEnabled = require(ParentParent.Actions.SetEmotesEnabled)
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v14 = if FFlagEnableNewBackpack then nil else require(RobloxGui.Modules.BackpackScript)
local v15 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local EmotesMenuMaster = require(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local v18 = Roact.PureComponent:extend("OpenUIConnector")

v18.validateProps = t.strictInterface({
	setBackpackOpen = t.callback,
	setEmotesOpen = t.callback,
	setLeaderboardOpen = t.callback,
	setEmotesEnabled = t.callback
})

function v18.didMount(p1) -- line: 42
	-- upvalues: PlayerListManager (copy), FFlagEnableNewBackpack (copy), v15 (copy), v14 (copy), EmotesMenuMaster (copy)
	p1.props.setLeaderboardOpen(PlayerListManager:GetSetVisible())

	if FFlagEnableNewBackpack then
		p1.props.setBackpackOpen(v15.getVisibility(v15.FeatureName.Backpack))
		p1.disposeBackpackListener = v15.onVisibilityChanged(v15.FeatureName.Backpack, function(p2) -- line: 47
			-- upvalues: p1 (copy)
			p1.props.setBackpackOpen(p2)
		end)
	else
		p1.props.setBackpackOpen(v14.IsOpen)
	end

	p1.props.setEmotesOpen(EmotesMenuMaster:isOpen())
	p1.props.setEmotesEnabled(EmotesMenuMaster.MenuIsVisible)
end
function v18.willUnmount(p3) -- line: 57
	if p3.disposeBackpackListener then
		p3.disposeBackpackListener()
		p3.disposeBackpackListener = nil
	end
end
function v18.render(p4) -- line: 64
	-- upvalues: PlayerListManager (copy), Roact (copy), EventConnection (copy), FFlagEnableNewBackpack (copy), v14 (copy), EmotesMenuMaster (copy)
	local SetVisibleChangedEvent = PlayerListManager:GetSetVisibleChangedEvent()

	return Roact.createFragment({
		LeaderboardOpenChangedConnection = Roact.createElement(EventConnection, {
			event = SetVisibleChangedEvent.Event,
			callback = function(p5) -- line: 70
				-- upvalues: p4 (copy)
				p4.props.setLeaderboardOpen(p5)
			end
		}),
		BackpackOpenChangedConnection = if FFlagEnableNewBackpack then nil else Roact.createElement(EventConnection, {
			event = v14.StateChanged.Event,
			callback = function(p6) -- line: 77
				-- upvalues: p4 (copy)
				p4.props.setBackpackOpen(p6)
			end
		}),
		EmotesOpenChangedConnection = Roact.createElement(EventConnection, {
			event = EmotesMenuMaster.EmotesMenuToggled.Event,
			callback = function(p7) -- line: 84
				-- upvalues: p4 (copy)
				p4.props.setEmotesOpen(p7)
			end
		}),
		EmotesEnabledChangedConnection = Roact.createElement(EventConnection, {
			event = EmotesMenuMaster.MenuVisibilityChanged.Event,
			callback = function(p8) -- line: 91
				-- upvalues: p4 (copy)
				p4.props.setEmotesEnabled(p8)
			end
		})
	})
end

local function mapDispatchToProps(p9) -- line: 98
	-- upvalues: SetBackpackOpen (copy), SetEmotesOpen (copy), SetLeaderboardOpen (copy), SetEmotesEnabled (copy)
	return {
		setBackpackOpen = function(p10) -- line: 100
			-- upvalues: p9 (copy), SetBackpackOpen (copy)
			return p9(SetBackpackOpen(p10))
		end,
		setEmotesOpen = function(p11) -- line: 104
			-- upvalues: p9 (copy), SetEmotesOpen (copy)
			return p9(SetEmotesOpen(p11))
		end,
		setLeaderboardOpen = function(p12) -- line: 108
			-- upvalues: p9 (copy), SetLeaderboardOpen (copy)
			return p9(SetLeaderboardOpen(p12))
		end,
		setEmotesEnabled = function(p13) -- line: 112
			-- upvalues: p9 (copy), SetEmotesEnabled (copy)
			return p9(SetEmotesEnabled(p13))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v18)
