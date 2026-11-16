local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local parent = script.Parent.Parent.Parent

local SetFriendStatus = require(parent.Actions.SetFriendStatus)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local extended = Roact.PureComponent:extend("FriendStatusConnector")

function extended:init()
	self.state = { localPlayer = Players.LocalPlayer }
end

function extended.render(object)
	local v = {
		PlayerAdded = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerAdded,
			callback = function(localPlayer)
				if localPlayer == Players.LocalPlayer then
					object:setState({ localPlayer = localPlayer })
				else
					object.props.setFriendStatus(localPlayer.UserId, Enum.FriendStatus.Unknown)
				end
			end
		}),
		PlayerRemoving = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerRemoving,
			callback = function(p)
				object.props.setFriendStatus(p.UserId, nil)
			end
		})
	}

	if object.state.localPlayer then
		v.FriendStatusChanged = Roact.createElement(ExternalEventConnection, {
			event = Players.LocalPlayer.FriendStatusChanged,
			callback = function(p, p2)
				object.props.setFriendStatus(p.UserId, p2)
			end
		})
	end

	return Roact.createFragment(v)
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		setFriendStatus = function(p, p2)
			return callback(SetFriendStatus(p, p2))
		end
	}
end)(extended)
