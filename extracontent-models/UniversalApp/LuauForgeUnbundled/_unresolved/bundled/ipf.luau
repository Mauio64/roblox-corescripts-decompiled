return {
	obfuscateUserId = function(p2): string
		if p2 == nil then
			return "<User ID: nil>"
		elseif p2 == 0 then
			return "<User ID: 0>"
		end

		return "<User ID: ####>"
	end,
	obfuscatePlayer = function(p2)
		if p2 == nil then
			return "<Player: nil>"
		end

		local v5 = (p2.UserId == 0 or p2.UserId == nil) and " [NO USER ID]" or ""

		return string.format("<Player: ####%s>", v5)
	end
}
