game:DefineFastInt("LuaAppGameDetailsMoreShareButtonRolloutV2", 0)

return function(p2): boolean
	local fastInt = game:GetFastInt("LuaAppGameDetailsMoreShareButtonRolloutV2")

	if fastInt <= 0 then
		return false
	end

	if p2 and p2 ~= "" then
		return (p2 + 55) % 100 < fastInt
	end

	return false
end
