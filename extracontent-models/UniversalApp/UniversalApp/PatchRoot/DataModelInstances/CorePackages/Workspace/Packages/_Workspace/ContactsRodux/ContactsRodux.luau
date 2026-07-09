local scriptParent = script.Parent
local Dash = require(scriptParent.Dash)
local RoduxNetworking = require(scriptParent.LuaSocialLibrariesDeps).RoduxNetworking
local NetworkingContacts = require(scriptParent.LuaSocialLibrariesDeps).NetworkingContacts
local ContactsReducer = require(script.Reducers.ContactsReducer)
local Selectors = require(script.Selectors)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 11
		-- upvalues: Dash (copy), NetworkingContacts (copy), RoduxNetworking (copy), ContactsReducer (copy), Selectors (copy)
		local u8 = Dash.join(p1, {
			networkingContacts = NetworkingContacts.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 19
				-- upvalues: ContactsReducer (copy), u8 (ref)
				return ContactsReducer(u8)
			end,
			Selectors = Selectors(u8),
			Models = require(script.Models),
			Actions = require(script.Actions)
		}
	end
}
