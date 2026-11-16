local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local parentModule = require(script.Parent)
local roact = dependencies.Roact
local llama = dependencies.llama

local friendsWithPresence = require(script.Parent.friendsWithPresence)

return function(p)
	return roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		frame = roact.createElement("Frame", {
			Size = UDim2.new(0, 150, 0, 0),
			BackgroundTransparency = 1
		}, {
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6)
			}),
			OnlineFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, { user = friendsWithPresence.OnlineFriend })
			),
			DeletedFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, { user = friendsWithPresence.DeletedFriend })
			),
			OfflineFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, { user = friendsWithPresence.OfflineFriend })
			),
			InGameFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, { user = friendsWithPresence.InGameFriend })
			),
			InGameWithoutLastLocationFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, {
					user = friendsWithPresence.InGameWithoutLastLocationFriend
				})
			),
			InStudioFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, { user = friendsWithPresence.InStudioFriend })
			),
			InStudioWithoutLastLocationFriend = roact.createElement(
				parentModule,
				llama.Dictionary.join(p, {
					user = friendsWithPresence.InStudioWithoutLastLocationFriend
				})
			)
		})
	})
end
