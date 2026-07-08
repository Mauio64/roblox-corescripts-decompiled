local contactImporterModalInfo = require(script.Parent.contactImporterModalInfo)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: contactImporterModalInfo (copy)
	local appStorageService = t1.appStorageService
	local userid = t1.userid

	if contactImporterModalInfo:isUserOptedInLocalStorage(appStorageService, userid) then
		return false
	end

	return contactImporterModalInfo:shouldUserSeeModalPotentiallyAgain(appStorageService, userid)
end
