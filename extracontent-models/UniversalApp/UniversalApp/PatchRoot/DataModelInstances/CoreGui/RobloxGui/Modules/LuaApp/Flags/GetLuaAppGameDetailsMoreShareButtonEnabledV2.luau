game:DefineFastInt("LuaAppGameDetailsMoreShareButtonRolloutV2", 0)

return function(p1) -- line: 4
	local FastInt = game:GetFastInt("LuaAppGameDetailsMoreShareButtonRolloutV2")

	if FastInt <= 0 then
		return false
	end

	if not p1 or p1 == "" then
		return false
	end

	return FastInt > (p1 + 55) % 100
end
