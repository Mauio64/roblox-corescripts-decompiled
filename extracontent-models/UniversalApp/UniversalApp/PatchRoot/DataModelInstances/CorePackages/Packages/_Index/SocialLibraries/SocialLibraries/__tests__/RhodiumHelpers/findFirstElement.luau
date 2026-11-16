local Packages = script:FindFirstAncestor("Packages")
local Rhodium = require(Packages.Dev.Rhodium)
local Element = Rhodium.Element
local findFirstInstance = require(script.Parent.findFirstInstance)

return function(p, p2)
	local firstInstance = findFirstInstance(p, p2)

	if firstInstance then
		return Element.new("game." .. firstInstance:GetFullName())
	end

	return nil
end
