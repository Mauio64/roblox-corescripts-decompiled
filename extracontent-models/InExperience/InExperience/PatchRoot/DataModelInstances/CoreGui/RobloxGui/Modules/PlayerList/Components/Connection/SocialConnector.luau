local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local SetPlayerFriendStatus = require(parent.Actions.SetPlayerFriendStatus)

local EventConnection = require(script.Parent.EventConnection)

local extended = Roact.PureComponent:extend("SocialConnector")

function extended:didMount()
	self.mounted = true
end

function extended.render(p)
	return Roact.createFragment({
		FriendStatusChangedConnection = Roact.createElement(EventConnection, {
			event = Players.LocalPlayer.FriendStatusChanged,
			callback = function(p2, p3)
				p.props.setPlayerFriendStatus(p2, p3)
			end
		})
	})
end

function extended:willUnmount()
	self.mounted = false
end

local function mapDispatchToProps(callback)
	return {
		setPlayerFriendStatus = function(p, p2)
			return callback(SetPlayerFriendStatus(p, p2))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
