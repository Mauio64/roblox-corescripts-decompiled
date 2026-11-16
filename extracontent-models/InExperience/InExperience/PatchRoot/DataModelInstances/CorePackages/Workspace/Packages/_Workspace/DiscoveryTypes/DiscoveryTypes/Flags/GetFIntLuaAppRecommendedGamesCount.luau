game:DefineFastInt("LuaAppRecommendedGamesCount", 6)

return function()
	local fastInt = game:GetFastInt("LuaAppRecommendedGamesCount")

	if fastInt > 20 then
		warn("Maximum Recommended Games Fetch Count has exceeded 20: ", fastInt)
	end

	return fastInt
end
