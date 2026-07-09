local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Types = ParentParent.Types
local Rodux = require(ParentParentParent.Rodux)
local setContactsInStore = require(script.Parent.utils.setContactsInStore)
local updateContactsInStore = require(script.Parent.utils.updateContactsInStore)

require(Types.ActionTypes)
require(Types.ReducerTypes)

local t1 = {}

return function(p1) -- line: 13
	-- upvalues: Rodux (copy), t1 (copy), setContactsInStore (copy), updateContactsInStore (copy)
	local networkingContacts = p1.networkingContacts

	return Rodux.createReducer(t1, {
		[networkingContacts.FindContactFriends.Succeeded.name] = function(_, p3) -- line: 17
			-- upvalues: setContactsInStore (copy)
			return setContactsInStore(p3)
		end,
		[networkingContacts.GetContactEntitiesByContactId.Succeeded.name] = function(p4, p5) -- line: 27
			-- upvalues: updateContactsInStore (copy)
			return updateContactsInStore(p4, p5)
		end
	})
end
