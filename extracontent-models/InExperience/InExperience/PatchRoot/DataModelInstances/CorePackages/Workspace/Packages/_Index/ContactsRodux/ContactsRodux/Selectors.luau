return function(p)
	local sortContacts = require(script.sortContacts)
	return { sortContacts = sortContacts(p), getPhoneNumber = require(script.getPhoneNumber) }
end
