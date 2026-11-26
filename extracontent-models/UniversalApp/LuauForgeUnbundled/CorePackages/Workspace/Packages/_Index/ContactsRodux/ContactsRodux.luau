local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")
local roduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/LuaSocialLibrariesDeps").RoduxNetworking
local networkingContacts = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/LuaSocialLibrariesDeps").NetworkingContacts

local ContactsReducer = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/ContactsReducer")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Selectors")

return {
	config = function(p2)
		local joined = Dash.join(p2, {
			networkingContacts = networkingContacts.config({
				roduxNetworking = roduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return ContactsReducer(joined)
			end,
			Selectors = module3(joined),
			Models = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Models"),
			Actions = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Actions")
		}
	end
}
