local function getLinkedPlatformAccountName(p)
	local platformAccountName = p.getPlatformAccountName()

	if platformAccountName and p.getUseSingleSignOn() then
		return platformAccountName
	end

	return nil
end

return getLinkedPlatformAccountName
