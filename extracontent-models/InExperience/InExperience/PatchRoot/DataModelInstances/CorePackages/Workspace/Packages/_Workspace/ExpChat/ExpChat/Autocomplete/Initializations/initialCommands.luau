local v = {}
local function setAllCommands(p) -- 1 equivalent call inferred from this helper
	v = p
end

return function(p)
	if p then
		setAllCommands(p) -- inferred equivalent call
	end

	return v
end
