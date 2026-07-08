local LocalPlayer = game:GetService("Players").LocalPlayer

return function(p1) -- line: 3
	-- upvalues: LocalPlayer (copy)
	if LocalPlayer and p1 > LocalPlayer.UserId % 10000 then
		return true
	end

	return false
end
