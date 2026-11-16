local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")

local setContactsInStore = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/utils/setContactsInStore")
local updateContactsInStore = require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Reducers/Contacts/utils/updateContactsInStore")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")

local v5 = {}

return function(p2)
	local networkingContacts = p2.networkingContacts

	return Rodux.createReducer(v5, {
		[networkingContacts.FindContactFriends.Succeeded.name] = function(p3, p4)
			return setContactsInStore(p4)
		end,
		[networkingContacts.GetContactEntitiesByContactId.Succeeded.name] = function(p3, p4)
			return updateContactsInStore(p3, p4)
		end
	})
end
