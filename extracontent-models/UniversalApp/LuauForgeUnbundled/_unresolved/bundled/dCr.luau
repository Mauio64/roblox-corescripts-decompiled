game:DefineFastString("DebugDefaultPageOverride", "")

return function()
	local fVariable = settings():GetFVariable("LuaAppDefaultPageOverride")

	if #fVariable > 0 then
		return fVariable
	end

	return game:GetFastString("DebugDefaultPageOverride")
end
