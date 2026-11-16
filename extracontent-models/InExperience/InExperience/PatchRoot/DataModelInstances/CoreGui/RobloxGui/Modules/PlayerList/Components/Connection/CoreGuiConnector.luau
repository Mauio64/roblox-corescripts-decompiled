local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local blockedStatusChangedEvent = BlockingUtility:GetBlockedStatusChangedEvent()

local parent = script.Parent.Parent.Parent

local SetPerformanceStatsVisible = require(parent.Actions.SetPerformanceStatsVisible)
local SetPlayerIsBlocked = require(parent.Actions.SetPlayerIsBlocked)

local EventConnection = require(script.Parent.EventConnection)

local extended = Roact.PureComponent:extend("CoreGuiConnector")

function extended.didMount(p)
	p.props.setPerformanceStatsVisible(UserGameSettings.PerformanceStatsVisible)
end

function extended.render(p)
	return Roact.createFragment({
		PerformanceStatsChangedConnection = Roact.createElement(EventConnection, {
			event = UserGameSettings.PerformanceStatsVisibleChanged,
			callback = function(p2)
				p.props.setPerformanceStatsVisible(p2)
			end
		}),
		BlockedStatusChangedConnection = Roact.createElement(EventConnection, {
			event = blockedStatusChangedEvent,
			callback = function(p2, p3)
				local playerByUserId = Players:GetPlayerByUserId(p2)

				if playerByUserId then
					p.props.setPlayerIsBlocked(playerByUserId, p3)
				end
			end
		})
	})
end

local function mapDispatchToProps(callback)
	return {
		setPerformanceStatsVisible = function(p)
			return callback(SetPerformanceStatsVisible(p))
		end,
		setPlayerIsBlocked = function(p, p2)
			return callback(SetPlayerIsBlocked(p, p2))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
