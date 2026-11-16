local function createGetFInt(p: string, p2: number)
	local success, result = pcall(function()
		game:DefineFastInt(p, p2)
	end)

	if success or not result:match("The current thread cannot call") then
		return function()
			return game:GetFastInt(p)
		end
	end

	return function()
		return p2
	end
end

return createGetFInt
