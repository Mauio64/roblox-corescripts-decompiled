local parent = script.Parent.Parent.Parent
local Rodux = require(parent.Rodux)

return {
	mockFindContactFriends = "FIND_CONTACT_FRIENDS_SUCCEEDED_ACTION",
	mockFindContactFriendsAction = Rodux.makeActionCreator("FIND_CONTACT_FRIENDS_SUCCEEDED_ACTION", function()
		return {
			responseBody = {
				userContactIds = {
					"abc-123-456-1235",
					"bglk-124f-323fd-2443f",
					"fgk49rf-45f0-fsdf45-fd341",
					"gfg4-f1sd-fdfet5-34sddhu"
				}
			}
		}
	end),
	mockGetContactEntitiesByContactId = "GET_CONTACT_ENTITIES",
	mockGetContactEntitiesByContactIdAction = Rodux.makeActionCreator("GET_CONTACT_ENTITIES", function()
		return {
			responseBody = {
				userContactsEntities = {
					{ id = "abc-123-456-1235", name = "Boberson Bob", mutualContacts = false },
					{ id = "bglk-124f-323fd-2443f", name = "Smith John", mutualContacts = false },
					{
						id = "fgk49rf-45f0-fsdf45-fd341",
						name = "Robertson Robert",
						mutualContacts = false
					},
					{ id = "gfg4-f1sd-fdfet5-34sddhu", name = "Folds Ben", mutualContacts = false }
				}
			}
		}
	end),
	mockUploadContacts = "UPLOAD_CONTACTS",
	mockUploadContactsAction = Rodux.makeActionCreator("UPLOAD_CONTACTS", function(matchedContactFields)
		return {
			responseBody = matchedContactFields and { matchedContactFields = matchedContactFields } or {
				matchedContactFields = {
					{ userContactId = "abc-123-456-1235", idAssignedByFE = "Boberson Bob1" },
					{ userContactId = "abc-456-1235", idAssignedByFE = "Danderson Dan1" },
					{ userContactId = "abc-123-456", idAssignedByFE = "Goferson Goff2" },
					{ userContactId = "abc-1235", idAssignedByFE = "Toferson Toff1" }
				}
			}
		}
	end)
}
