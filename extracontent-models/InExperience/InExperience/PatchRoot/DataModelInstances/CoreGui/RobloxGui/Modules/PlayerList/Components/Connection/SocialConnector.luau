local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local SetPlayerFriendStatus = require(ParentParent.Actions.SetPlayerFriendStatus)
local EventConnection = require(script.Parent.EventConnection)
local v8 = Roact.PureComponent:extend("SocialConnector")

function v8.didMount(p1) -- line: 17
	p1.mounted = true
end
function v8.render(p2) -- line: 21
	-- upvalues: Roact (copy), EventConnection (copy), Players (copy)
	return Roact.createFragment({
		FriendStatusChangedConnection = Roact.createElement(EventConnection, {
			event = Players.LocalPlayer.FriendStatusChanged,
			callback = function(p3, p4) -- line: 25
				-- upvalues: p2 (copy)
				p2.props.setPlayerFriendStatus(p3, p4)
			end
		})
	})
end
function v8.willUnmount(p5) -- line: 32
	p5.mounted = false
end

local function mapDispatchToProps(p6) -- line: 36
	-- upvalues: SetPlayerFriendStatus (copy)
	return {
		setPlayerFriendStatus = function(p7, p8) -- line: 38
			-- upvalues: p6 (copy), SetPlayerFriendStatus (copy)
			return p6(SetPlayerFriendStatus(p7, p8))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v8)
