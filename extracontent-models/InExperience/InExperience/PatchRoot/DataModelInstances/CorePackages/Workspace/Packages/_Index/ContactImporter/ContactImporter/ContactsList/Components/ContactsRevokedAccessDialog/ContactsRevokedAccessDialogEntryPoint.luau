local parent = script.Parent.Parent.Parent.Parent.Parent
local React = require(parent.React)
local Dash = require(parent.Dash)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local ContactsRevokedAccessDialog = require(script.Parent.ContactsRevokedAccessDialog)

local function ContactsRevokedAccessDialogEntryPoint(p)
	local navigation = useNavigation()
	return React.createElement(ContactsRevokedAccessDialog, Dash.join(p, { navigation = navigation }))
end

return ContactsRevokedAccessDialogEntryPoint
