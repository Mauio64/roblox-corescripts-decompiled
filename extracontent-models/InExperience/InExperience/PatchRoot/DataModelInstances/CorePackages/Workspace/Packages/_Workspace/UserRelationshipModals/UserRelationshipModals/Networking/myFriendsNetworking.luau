local parent = script:FindFirstAncestor("UserRelationshipModals").Parent

local FriendsNetworking = require(parent.FriendsNetworking)

local myRoduxNetworking = require(script.Parent.myRoduxNetworking)

return FriendsNetworking.config({ roduxNetworking = myRoduxNetworking })
