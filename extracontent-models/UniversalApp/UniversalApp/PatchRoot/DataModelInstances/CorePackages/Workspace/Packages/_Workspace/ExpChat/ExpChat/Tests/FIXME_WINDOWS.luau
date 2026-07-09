local UserInputService = game:GetService("UserInputService")

return function(p1, p2, p3, p4) -- line: 4
	-- upvalues: UserInputService (copy)
	if UserInputService:GetPlatform() == Enum.Platform.Windows then
		p2(p3 .. " TODO: EXPCHAT-812 Test disabled on Windows", p4)

		return
	end

	p1(p3, p4)
end
