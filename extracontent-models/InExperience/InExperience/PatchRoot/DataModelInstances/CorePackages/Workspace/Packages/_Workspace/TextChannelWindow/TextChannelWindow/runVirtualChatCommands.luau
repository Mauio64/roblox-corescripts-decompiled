local Commands = require(script.Parent.Commands)

return function(value: string, p: string)
	for _, command in Commands do
		for _, alias in command.aliases do
			if value == alias or string.find(value, "^" .. alias .. "%s") ~= nil then
				return command.run(value, p)
			end
		end
	end

	return nil
end
