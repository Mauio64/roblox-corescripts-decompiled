return {
	obfuscateUserId = function(n1: number?) -- line: 6
		if n1 == nil then
			return "<User ID: nil>"
		end

		if n1 == 0 then
			return "<User ID: 0>"
		end

		return "<User ID: ####>"
	end,
	obfuscatePlayer = function(p1) -- line: 16
		if p1 == nil then
			return "<Player: nil>"
		end

		local v3 = not (p1.UserId == 0 or p1.UserId == nil) and "" or " [NO USER ID]"

		return string.format("<Player: ####%s>", v3)
	end
}
