local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local useNavigation = require(ParentParent.Navigation).useNavigation
local ContactsRevokedAccessDialog = require(script.Parent.ContactsRevokedAccessDialog)

local function ContactsRevokedAccessDialogEntryPoint(t1: {[any]: any}) -- line: 14
	-- upvalues: useNavigation (copy), React (copy), ContactsRevokedAccessDialog (copy), Dash (copy)
	local v8 = useNavigation()

	return React.createElement(ContactsRevokedAccessDialog, Dash.join(t1, {
		navigation = v8
	}))
end

return ContactsRevokedAccessDialogEntryPoint
