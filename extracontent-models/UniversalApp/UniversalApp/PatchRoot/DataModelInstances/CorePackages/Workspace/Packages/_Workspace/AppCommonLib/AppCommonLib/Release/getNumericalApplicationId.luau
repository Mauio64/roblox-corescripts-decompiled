local AppStorageService = game:GetService("AppStorageService")

game:DefineFastFlag("EnableContactInvitesForNonPhoneVerifiedForAll", false)
game:DefineFastInt("EnableContactInvitesForNonPhoneVerifiedRollout", 0)

return function(t1: {[any]: any}?) -- line: 7
	-- upvalues: AppStorageService (copy)
	local v3 = AppStorageService

	if t1 then
		v3 = t1
	end

	local Item = v3:GetItem("AppInstallationId")
	local v5 = typeof(Item)

	if v5 == "number" then
		return Item
	end

	if v5 == "string" then
		if string.len(Item) <= 0 then
			return nil
		end

		return (tonumber((string.sub(Item, -2))))
	end

	return nil
end
