game:DefineFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist", "")

return {
	isWhitelistedUserId = function(p1) -- line: 9
		local FastString = game:GetFastString("DiscoverabilityUpsellNonPrefillDiscoverableUserIdsWhitelist")

		for match in string.gmatch(FastString, "[^,]+") do
			if match == tostring(p1) then
				return true
			end
		end

		return false
	end
}
