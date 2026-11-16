local contactImporterModalInfo = require(script.Parent.contactImporterModalInfo)

return function(p)
	local appStorageService = p.appStorageService
	local userid = p.userid

	if contactImporterModalInfo:isUserOptedInLocalStorage(appStorageService, userid) then
		return false
	end

	return contactImporterModalInfo:shouldUserSeeModalPotentiallyAgain(appStorageService, userid)
end
