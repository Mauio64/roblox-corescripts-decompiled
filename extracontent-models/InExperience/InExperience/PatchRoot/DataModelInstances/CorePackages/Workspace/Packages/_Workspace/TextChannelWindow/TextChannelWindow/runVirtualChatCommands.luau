local Commands = require(script.Parent.Commands)

return function(s1: string, s2: string) -- line: 11
	-- upvalues: Commands (copy)
	for _, v5 in Commands do
		for _, v7 in v5.aliases do
			if s1 == v7 or string.find(s1, "^" .. v7 .. "%s") ~= nil then
				return v5.run(s1, s2)
			end
		end
	end

	return nil
end
