require(script.createFriendsStore)
local Requests = require(script.Requests)

return {
	Enums = require(script.Enums),
	FriendsStore = require(script.FriendsStore),
	httpRequest = require(script.Networking.myHttpRequest),
	Requests = Requests
}
