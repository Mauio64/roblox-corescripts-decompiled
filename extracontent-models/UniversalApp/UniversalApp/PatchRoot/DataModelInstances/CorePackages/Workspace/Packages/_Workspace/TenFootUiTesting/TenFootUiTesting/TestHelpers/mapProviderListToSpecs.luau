local Parent = script:FindFirstAncestor("TenFootUiTesting").Parent
local Cryo = require(Parent.Cryo)

require(Parent.Dev.RoactUtils)

local function mapProviderListToSpecs(t1: {[any]: any}) -- line: 10
	-- upvalues: Cryo (copy)
	return Cryo.List.map(t1, function(p1) -- line: 11
		return {
			class = p1
		}
	end)
end

return mapProviderListToSpecs
