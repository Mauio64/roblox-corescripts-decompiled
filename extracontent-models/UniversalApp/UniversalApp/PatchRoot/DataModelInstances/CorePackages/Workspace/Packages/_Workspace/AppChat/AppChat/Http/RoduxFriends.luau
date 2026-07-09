local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.FriendsRodux).config({
	keyPath = "ChatAppReducer.Friends"
})
