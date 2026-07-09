local ParentParent = script.Parent.Parent.Parent
local getFFlagPassNavigationToContactsRevoked = require(ParentParent.Flags.getFFlagPassNavigationToContactsRevoked)

require(script.ContactsRevokedAccessDialog)

if getFFlagPassNavigationToContactsRevoked() then
	return (require(script.ContactsRevokedAccessDialogEntryPoint))
end

return (require(script.ContactsRevokedAccessDialog))
