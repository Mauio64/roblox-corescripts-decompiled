local function createGetFFlag(value: string, flag: boolean?)
	local success, result = pcall(function()
		local game = game
		local v = if flag then flag else false
		game:DefineFastFlag(value, v)
	end)

	if success or not result:match("The current thread cannot call") then
		return function()
			return game:GetFastFlag(value)
		end
	end

	return function(): boolean
		return value:match("^Debug") == nil
	end
end

return createGetFFlag
