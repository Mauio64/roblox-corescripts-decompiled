return {
	Enum = {
		IN_APP = "IN_APP",
		IN_EXPERIENCE = "IN_EXPERIENCE"
	},
	get = function() -- line: 14
		if game.GameId == 0 then
			return "IN_APP"
		end

		return "IN_EXPERIENCE"
	end
}
