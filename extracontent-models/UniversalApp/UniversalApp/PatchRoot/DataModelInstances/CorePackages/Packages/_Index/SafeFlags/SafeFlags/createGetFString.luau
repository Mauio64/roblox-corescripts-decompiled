local function createGetFString(p: string, p2: string)
	local success, result = pcall(function()
		game:DefineFastString(p, p2)
	end)

	if success or not result:match("The current thread cannot call") then
		return function()
			return game:GetFastString(p)
		end
	end

	return function()
		return p2
	end
end

return createGetFString
