local ContactsToast = script:FindFirstAncestor("ContactsToast")
local ContactsToastParent = ContactsToast.Parent
local RoduxUsers = require(ContactsToastParent.RoduxUsers)
local RODUX_KEY = require(ContactsToast.Common.Constants).RODUX_KEY

return RoduxUsers.config({
	keyPath = RODUX_KEY .. ".Users"
})
