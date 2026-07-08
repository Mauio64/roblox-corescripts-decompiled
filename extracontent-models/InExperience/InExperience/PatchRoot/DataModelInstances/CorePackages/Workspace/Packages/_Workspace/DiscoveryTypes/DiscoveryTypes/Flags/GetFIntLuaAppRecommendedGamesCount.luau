game:DefineFastInt("LuaAppRecommendedGamesCount", 6)

return function() -- line: 3
	local FastInt = game:GetFastInt("LuaAppRecommendedGamesCount")

	if FastInt > 20 then
		warn("Maximum Recommended Games Fetch Count has exceeded 20: ", FastInt)
	end

	return FastInt
end
