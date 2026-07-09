local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Parent = require(script.Parent)
local Roact = dependencies.Roact
local llama = dependencies.llama
local friendsWithPresence = require(script.Parent.friendsWithPresence)

return function(p1) -- line: 10
	-- upvalues: Roact (copy), Parent (copy), llama (copy), friendsWithPresence (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		frame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 150, 0, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 6)
			}),
			OnlineFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.OnlineFriend
			})),
			DeletedFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.DeletedFriend
			})),
			OfflineFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.OfflineFriend
			})),
			InGameFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.InGameFriend
			})),
			InGameWithoutLastLocationFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.InGameWithoutLastLocationFriend
			})),
			InStudioFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.InStudioFriend
			})),
			InStudioWithoutLastLocationFriend = Roact.createElement(Parent, llama.Dictionary.join(p1, {
				user = friendsWithPresence.InStudioWithoutLastLocationFriend
			}))
		})
	})
end
