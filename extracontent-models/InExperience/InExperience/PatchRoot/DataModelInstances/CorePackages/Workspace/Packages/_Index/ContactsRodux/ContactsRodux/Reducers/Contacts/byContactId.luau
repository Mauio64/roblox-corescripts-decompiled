local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local types = parent.Types
local Rodux = require(parent2.Rodux)

local setContactsInStore = require(script.Parent.utils.setContactsInStore)
local updateContactsInStore = require(script.Parent.utils.updateContactsInStore)
require(types.ActionTypes)
require(types.ReducerTypes)

local v = {}

return function(p)
	local networkingContacts = p.networkingContacts

	return Rodux.createReducer(v, {
		[networkingContacts.FindContactFriends.Succeeded.name] = function(_, p2)
			return setContactsInStore(p2)
		end,
		[networkingContacts.GetContactEntitiesByContactId.Succeeded.name] = function(p2, p3)
			return updateContactsInStore(p2, p3)
		end
	})
end
