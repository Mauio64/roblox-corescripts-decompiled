local getFFlagPassNavigationToContactsRevoked = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFFlagPassNavigationToContactsRevoked")
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsRevokedAccessDialog/ContactsRevokedAccessDialog")

if getFFlagPassNavigationToContactsRevoked() then
	return (require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsRevokedAccessDialog/ContactsRevokedAccessDialogEntryPoint"))
end

return (require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsRevokedAccessDialog/ContactsRevokedAccessDialog"))
