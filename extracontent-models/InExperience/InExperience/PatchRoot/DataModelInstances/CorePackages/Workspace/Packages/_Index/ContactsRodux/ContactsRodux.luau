local parent = script.Parent
local Dash = require(parent.Dash)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local LuaSocialLibrariesDeps2 = require(parent.LuaSocialLibrariesDeps)
local NetworkingContacts = LuaSocialLibrariesDeps2.NetworkingContacts

local ContactsReducer = require(script.Reducers.ContactsReducer)
local Selectors = require(script.Selectors)

return {
	["jest.config"] = script["jest.config"],
	config = function(p)
		local joined = Dash.join(p, {
			networkingContacts = NetworkingContacts.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return ContactsReducer(joined)
			end,
			Selectors = Selectors(joined),
			Models = require(script.Models),
			Actions = require(script.Actions)
		}
	end
}
