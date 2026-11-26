local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Dash")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Navigation").useNavigation

local ContactsRevokedAccessDialog = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsRevokedAccessDialog/ContactsRevokedAccessDialog")

local function ContactsRevokedAccessDialogEntryPoint(p2)
	local v5 = useNavigation()
	return React.createElement(ContactsRevokedAccessDialog, Dash.join(p2, { navigation = v5 }))
end

return ContactsRevokedAccessDialogEntryPoint
