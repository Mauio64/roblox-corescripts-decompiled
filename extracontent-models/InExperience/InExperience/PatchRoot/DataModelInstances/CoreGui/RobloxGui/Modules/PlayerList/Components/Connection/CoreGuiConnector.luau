local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local BlockedStatusChangedEvent = require(CorePackages.Workspace.Packages.BlockingUtility):GetBlockedStatusChangedEvent()
local ParentParent = script.Parent.Parent.Parent
local SetPerformanceStatsVisible = require(ParentParent.Actions.SetPerformanceStatsVisible)
local SetPlayerIsBlocked = require(ParentParent.Actions.SetPlayerIsBlocked)
local EventConnection = require(script.Parent.EventConnection)
local v11 = Roact.PureComponent:extend("CoreGuiConnector")

function v11.didMount(p1) -- line: 22
	-- upvalues: UserGameSettings (copy)
	p1.props.setPerformanceStatsVisible(UserGameSettings.PerformanceStatsVisible)
end
function v11.render(p2) -- line: 26
	-- upvalues: Roact (copy), EventConnection (copy), UserGameSettings (copy), BlockedStatusChangedEvent (copy), Players (copy)
	return Roact.createFragment({
		PerformanceStatsChangedConnection = Roact.createElement(EventConnection, {
			event = UserGameSettings.PerformanceStatsVisibleChanged,
			callback = function(p3) -- line: 30
				-- upvalues: p2 (copy)
				p2.props.setPerformanceStatsVisible(p3)
			end
		}),
		BlockedStatusChangedConnection = Roact.createElement(EventConnection, {
			event = BlockedStatusChangedEvent,
			callback = function(p4, p5) -- line: 37
				-- upvalues: Players (copy), p2 (copy)
				local PlayerByUserId = Players:GetPlayerByUserId(p4)

				if PlayerByUserId then
					p2.props.setPlayerIsBlocked(PlayerByUserId, p5)
				end
			end
		})
	})
end

local function mapDispatchToProps(p6) -- line: 47
	-- upvalues: SetPerformanceStatsVisible (copy), SetPlayerIsBlocked (copy)
	return {
		setPerformanceStatsVisible = function(p7) -- line: 49
			-- upvalues: p6 (copy), SetPerformanceStatsVisible (copy)
			return p6(SetPerformanceStatsVisible(p7))
		end,
		setPlayerIsBlocked = function(p8, p9) -- line: 53
			-- upvalues: p6 (copy), SetPlayerIsBlocked (copy)
			return p6(SetPlayerIsBlocked(p8, p9))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v11)
