local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local ContactsListContainer = require(script.ContactsListContainer)

local dash = dependencies.Dash
local roact = dependencies.Roact
local useNavigation = dependencies.useNavigation

function ContactsList(options)
	local navigation = useNavigation()
	return roact.createElement(ContactsListContainer, dash.join({ navigation = navigation }, options or {}))
end

return ContactsList
