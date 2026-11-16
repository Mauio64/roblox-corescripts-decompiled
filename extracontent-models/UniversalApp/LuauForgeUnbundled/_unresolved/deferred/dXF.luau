local module = require("@luauforge/deferred/dXG")

return function(p2)
	local children = {}

	if not p2.current then
		return children
	end

	for i, child in pairs(p2.current:GetChildren()) do
		local name = child.Name
		local v5 = module(name)

		if string.match(name, "[a-f0-9]+-[a-f0-9]+-[a-f0-9]+-[a-f0-9]+-[a-f0-9]+") or v5 then
			table.insert(children, child)
		end
	end

	return children
end
