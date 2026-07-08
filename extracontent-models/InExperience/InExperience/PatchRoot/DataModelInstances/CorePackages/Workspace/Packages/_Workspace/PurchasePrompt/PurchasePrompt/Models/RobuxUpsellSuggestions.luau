local ParentParent = script.Parent.Parent
local RobuxUpsell = require(ParentParent.Models.RobuxUpsell)
local t2 = {
	new = function(t1: {[any]: any}) -- line: 17
		return {
			products = t1
		}
	end
}

function t2.fromJson(t3: {[any]: any}) -- line: 25
	-- upvalues: RobuxUpsell (copy), t2 (copy)
	local t4 = {}

	for k, v in pairs(t3.products) do
		t4[k] = RobuxUpsell.fromJson(v)
	end

	return t2.new(t4)
end

return t2
