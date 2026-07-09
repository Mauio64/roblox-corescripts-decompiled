local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)

require(AccountRecovery.Store.State)

return React.createContext({
	dispatch = nil,
	parentNavigation = nil,
	state = {}
})
