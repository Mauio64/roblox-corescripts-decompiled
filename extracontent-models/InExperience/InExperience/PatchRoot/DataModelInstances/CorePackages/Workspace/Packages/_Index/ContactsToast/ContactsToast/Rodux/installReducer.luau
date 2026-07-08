local ContactsToast = script:FindFirstAncestor("ContactsToast")
local ContactsToastParent = ContactsToast.Parent
local Rodux = require(ContactsToastParent.Rodux)
local configuredUsers = require(script.Parent.configuredUsers)
local configuredRoduxNetworking = require(ContactsToast.Networking.configuredRoduxNetworking)

return function() -- line: 12
	-- upvalues: Rodux (copy), configuredUsers (copy), configuredRoduxNetworking (copy)
	return Rodux.combineReducers({
		Users = configuredUsers(),
		NetworkStatus = configuredRoduxNetworking.installReducer()
	})
end
