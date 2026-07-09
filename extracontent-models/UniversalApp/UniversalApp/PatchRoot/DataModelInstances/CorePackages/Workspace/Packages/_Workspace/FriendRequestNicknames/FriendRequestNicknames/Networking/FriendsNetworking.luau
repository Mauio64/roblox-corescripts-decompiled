local ParentParent = script.Parent.Parent.Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return (require(ParentParent.FriendsNetworking).config({
	roduxNetworking = RoduxNetworking
}))
