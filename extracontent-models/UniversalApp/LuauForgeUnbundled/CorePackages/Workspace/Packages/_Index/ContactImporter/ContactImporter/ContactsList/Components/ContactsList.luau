local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local ContactsListContainer = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/ContactsListContainer")

local dash = dependencies.Dash
local roact = dependencies.Roact
local useNavigation = dependencies.useNavigation

function LUAUFORGE_MODULE_GLOBALS_cty_ContactsList(options)
	local v5 = useNavigation()
	return roact.createElement(ContactsListContainer, dash.join({ navigation = v5 }, options or {}))
end

return LUAUFORGE_MODULE_GLOBALS_cty_ContactsList
