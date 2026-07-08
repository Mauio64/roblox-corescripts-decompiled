local function exitCreationFlow(p1: ((...any) -> ...any)?) -- line: 16
	if p1 then
		p1()
	end
end

return exitCreationFlow
