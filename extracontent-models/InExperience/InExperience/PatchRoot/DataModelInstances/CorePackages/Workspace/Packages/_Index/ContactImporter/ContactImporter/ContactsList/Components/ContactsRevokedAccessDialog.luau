local parent = script.Parent.Parent.Parent
local getFFlagPassNavigationToContactsRevoked = require(parent.Flags.getFFlagPassNavigationToContactsRevoked)
require(script.ContactsRevokedAccessDialog)

if getFFlagPassNavigationToContactsRevoked() then
	local ContactsRevokedAccessDialogEntryPoint = require(script.ContactsRevokedAccessDialogEntryPoint)
	return ContactsRevokedAccessDialogEntryPoint
end

local ContactsRevokedAccessDialog = require(script.ContactsRevokedAccessDialog)

return ContactsRevokedAccessDialog
