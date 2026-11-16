game:DefineFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist", "")

return {
	isWhitelistedUserId = function(p2): boolean
		local fastString = game:GetFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist")

		for k in string.gmatch(fastString, "[^,]+") do
			if tostring(p2) == k then
				return true
			end
		end

		return false
	end
}
