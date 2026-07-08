local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ParentParent = script.Parent.Parent.Parent
local SetFriendStatus = require(ParentParent.Actions.SetFriendStatus)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local v9 = Roact.PureComponent:extend("FriendStatusConnector")

function v9.init(p1) -- line: 15
	-- upvalues: Players (copy)
	p1.state = {
		localPlayer = Players.LocalPlayer
	}
end
function v9.render(p2) -- line: 21
	-- upvalues: Roact (copy), ExternalEventConnection (copy), Players (copy)
	local t1 = {
		PlayerAdded = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerAdded,
			callback = function(p3) -- line: 25
				-- upvalues: Players (copy), p2 (copy)
				if p3 == Players.LocalPlayer then
					p2:setState({
						localPlayer = p3
					})

					return
				end

				p2.props.setFriendStatus(p3.UserId, Enum.FriendStatus.Unknown)
			end
		}),
		PlayerRemoving = Roact.createElement(ExternalEventConnection, {
			event = Players.PlayerRemoving,
			callback = function(p4) -- line: 38
				-- upvalues: p2 (copy)
				p2.props.setFriendStatus(p4.UserId, nil)
			end
		})
	}

	if p2.state.localPlayer then
		t1.FriendStatusChanged = Roact.createElement(ExternalEventConnection, {
			event = Players.LocalPlayer.FriendStatusChanged,
			callback = function(p5, p6) -- line: 47
				-- upvalues: p2 (copy)
				p2.props.setFriendStatus(p5.UserId, p6)
			end
		})
	end

	return Roact.createFragment(t1)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p7) -- line: 56
	-- upvalues: SetFriendStatus (copy)
	return {
		setFriendStatus = function(p8, p9) -- line: 58
			-- upvalues: p7 (copy), SetFriendStatus (copy)
			return p7(SetFriendStatus(p8, p9))
		end
	}
end)(v9)
