local function getLinkedPlatformAccountName(p2)
	local platformAccountName = p2.getPlatformAccountName()

	if platformAccountName and p2.getUseSingleSignOn() then
		return platformAccountName
	end

	return nil
end

return getLinkedPlatformAccountName
