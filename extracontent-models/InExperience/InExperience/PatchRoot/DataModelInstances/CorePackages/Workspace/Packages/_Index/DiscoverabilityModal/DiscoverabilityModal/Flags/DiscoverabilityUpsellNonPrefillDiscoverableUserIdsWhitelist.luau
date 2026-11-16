game:DefineFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist", "")

return {
	isWhitelistedUserId = function(p): boolean
		local fastString = game:GetFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist")

		for k in string.gmatch(fastString, "[^,]+") do
			if tostring(p) == k then
				return true
			end
		end

		return false
	end
}
