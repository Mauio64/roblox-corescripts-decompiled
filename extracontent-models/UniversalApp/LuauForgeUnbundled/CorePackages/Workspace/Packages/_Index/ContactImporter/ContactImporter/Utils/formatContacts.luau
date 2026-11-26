local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")

local getFIntContactImporterUploadContactsMax = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterUploadContactsMax")
local getFIntContactImporterUploadContactsMin = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterUploadContactsMin")

local deviceContact = dependencies.RoduxContacts.Models.DeviceContact

return function(data)
	local v5 = getFIntContactImporterUploadContactsMax()
	local v6 = getFIntContactImporterUploadContactsMin()
	local v7 = {}

	for k, contact in pairs(data.contacts) do
		for k2, v9 in pairs(contact.phonenumber) do
			if v5 <= #v7 then
				break
			end

			table.insert(v7, {
				idAssignedByFE = deviceContact.generateId(contact),
				fields = {
					{
						name = Constants.LAST_NAME,
						value = contact.lastname == nil and "" or tostring(contact.lastname)
					},
					{
						name = Constants.FIRST_NAME,
						value = contact.firstname == nil and "" or tostring(contact.firstname)
					},
					{
						name = Constants.PHONE_NUMBER,
						value = tostring(v9):gsub("%s+", "")
					}
				}
			})
		end
	end

	local count = #v7

	if v6 <= count then
		return {
			countryCode = data.countryCode,
			contacts = v7,
			contactsCount = count,
			source = data.source
		}
	end

	if count < v6 then
		return {
			countryCode = data.countryCode,
			contacts = {},
			contactsCount = count,
			source = data.source
		}
	end

	return {
		countryCode = data.countryCode,
		contacts = v7,
		contactsCount = count,
		source = data.source
	}
end
