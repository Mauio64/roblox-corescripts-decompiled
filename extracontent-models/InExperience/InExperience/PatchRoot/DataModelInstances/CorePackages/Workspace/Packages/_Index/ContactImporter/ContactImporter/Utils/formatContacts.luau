local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Constants = require(ContactImporter.Common.Constants)
local getFIntContactImporterUploadContactsMax = require(ContactImporter.Flags.getFIntContactImporterUploadContactsMax)
local getFIntContactImporterUploadContactsMin = require(ContactImporter.Flags.getFIntContactImporterUploadContactsMin)
local DeviceContact = dependencies.RoduxContacts.Models.DeviceContact

return function(p1) -- line: 12
	-- upvalues: getFIntContactImporterUploadContactsMax (copy), getFIntContactImporterUploadContactsMin (copy), DeviceContact (copy), Constants (copy)
	local t1 = {}
	local v9 = getFIntContactImporterUploadContactsMax()
	local v10 = getFIntContactImporterUploadContactsMin()

	for _, v in pairs(p1.contacts) do
		for _, v2 in pairs(v.phonenumber) do
			if v9 <= #t1 then
				break
			end

			table.insert(t1, {
				idAssignedByFE = DeviceContact.generateId(v),
				fields = {
					{
						name = Constants.LAST_NAME,
						value = if v.lastname ~= nil then tostring(v.lastname) else ""
					},
					{
						name = Constants.FIRST_NAME,
						value = if v.firstname ~= nil then tostring(v.firstname) else ""
					},
					{
						name = Constants.PHONE_NUMBER,
						value = tostring(v2):gsub("%s+", "")
					}
				}
			})
		end
	end

	local v15 = #t1

	if v10 <= v15 then
		return {
			countryCode = p1.countryCode,
			contacts = t1,
			contactsCount = v15,
			source = p1.source
		}
	end

	if v15 < v10 then
		return {
			countryCode = p1.countryCode,
			contacts = {},
			contactsCount = v15,
			source = p1.source
		}
	end

	return {
		countryCode = p1.countryCode,
		contacts = t1,
		contactsCount = v15,
		source = p1.source
	}
end
