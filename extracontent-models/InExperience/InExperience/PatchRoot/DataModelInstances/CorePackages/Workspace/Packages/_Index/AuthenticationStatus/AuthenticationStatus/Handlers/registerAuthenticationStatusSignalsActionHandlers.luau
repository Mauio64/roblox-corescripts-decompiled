local AuthenticationStatus = script:FindFirstAncestor("AuthenticationStatus")
local AuthenticationStatusParent = AuthenticationStatus.Parent
local ActionHandlers = require(AuthenticationStatusParent.SignalsMiddleware).ActionHandlers
local SetAuthenticationStatus = require(AuthenticationStatus.Actions.SetAuthenticationStatus)
local GetAuthenticationStatusStore = require(AuthenticationStatus.Stores.GetAuthenticationStatusStore)

local function handleSetAuthenticationStatus(t1: {[any]: any}) -- line: 8
	-- upvalues: GetAuthenticationStatusStore (copy)
	GetAuthenticationStatusStore(false).setAuthenticationStatus(t1.status)

	return false
end

return function(p1) -- line: 13
	-- upvalues: ActionHandlers (copy), SetAuthenticationStatus (copy), handleSetAuthenticationStatus (copy)
	ActionHandlers.register(p1, SetAuthenticationStatus.name, handleSetAuthenticationStatus)
end
