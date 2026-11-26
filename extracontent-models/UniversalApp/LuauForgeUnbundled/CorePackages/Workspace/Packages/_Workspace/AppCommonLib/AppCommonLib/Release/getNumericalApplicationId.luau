local AppStorageService = game:GetService("AppStorageService")
game:DefineFastFlag("EnableContactInvitesForNonPhoneVerifiedForAll", false)
game:DefineFastInt("EnableContactInvitesForNonPhoneVerifiedRollout", 0)

return function(p2)
	local item = (p2 or AppStorageService):GetItem("AppInstallationId")

	local typeName = typeof(item)

	if typeName == "number" then
		return item
	end

	if typeName ~= "string" or string.len(item) <= 0 then
		return nil
	end

	return (tonumber((string.sub(item, -2))))
end
