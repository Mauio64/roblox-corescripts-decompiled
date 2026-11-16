local ContactImporter = script:FindFirstAncestor("ContactImporter")

local dependencies = require(ContactImporter.dependencies)
local Constants = require(ContactImporter.Common.Constants)

local getFIntContactImporterUploadContactsMax = require(ContactImporter.Flags.getFIntContactImporterUploadContactsMax)
local getFIntContactImporterUploadContactsMin = require(ContactImporter.Flags.getFIntContactImporterUploadContactsMin)

local deviceContact = dependencies.RoduxContacts.Models.DeviceContact

return function(data)
	local fIntContactImporterUploadContactsMax = getFIntContactImporterUploadContactsMax()
	local fIntContactImporterUploadContactsMin = getFIntContactImporterUploadContactsMin()
	local contacts = {}

	for _, contact in pairs(data.contacts) do
		for _, v in pairs(contact.phonenumber) do
			if fIntContactImporterUploadContactsMax <= #contacts then
				break
			end

			table.insert(contacts, {
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
					{ name = Constants.PHONE_NUMBER, value = tostring(v):gsub("%s+", "") }
				}
			})
		end
	end

	local count = #contacts

	if fIntContactImporterUploadContactsMin <= count then
		return {
			countryCode = data.countryCode,
			contacts = contacts,
			contactsCount = count,
			source = data.source
		}
	end

	if count < fIntContactImporterUploadContactsMin then
		return {
			countryCode = data.countryCode,
			contacts = {},
			contactsCount = count,
			source = data.source
		}
	end

	return {
		countryCode = data.countryCode,
		contacts = contacts,
		contactsCount = count,
		source = data.source
	}
end
