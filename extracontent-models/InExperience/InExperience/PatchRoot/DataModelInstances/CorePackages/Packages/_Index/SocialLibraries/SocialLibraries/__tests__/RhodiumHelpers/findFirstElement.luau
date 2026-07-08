local Packages = script:FindFirstAncestor("Packages")
local Element = require(Packages.Dev.Rhodium).Element
local findFirstInstance = require(script.Parent.findFirstInstance)

return function(p1, p2) -- line: 12
	-- upvalues: findFirstInstance (copy), Element (copy)
	local v6 = findFirstInstance(p1, p2)

	if v6 then
		return Element.new("game." .. v6:GetFullName())
	end

	return nil
end
