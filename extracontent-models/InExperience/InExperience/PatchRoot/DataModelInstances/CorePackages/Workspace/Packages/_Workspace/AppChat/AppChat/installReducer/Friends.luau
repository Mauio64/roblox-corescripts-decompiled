local AppChat = script:FindFirstAncestor("AppChat")

local RoduxFriends = require(AppChat.Http.RoduxFriends)

return (RoduxFriends.installReducer())
