game:DefineFastString("DebugDefaultPageOverride", "")

return function() -- line: 3
	local FVariable = settings():GetFVariable("LuaAppDefaultPageOverride")

	if #FVariable > 0 then
		return FVariable
	end

	return game:GetFastString("DebugDefaultPageOverride")
end
