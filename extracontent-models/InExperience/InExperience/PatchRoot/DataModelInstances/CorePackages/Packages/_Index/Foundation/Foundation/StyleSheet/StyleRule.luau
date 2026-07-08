local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function StyleRule(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy)
	local v5 = React.useCallback(function(p1) -- line: 14
		-- upvalues: t1 (copy)
		if p1 ~= nil then
			p1:SetProperties(t1.properties)
		end
	end, { t1.properties })

	return React.createElement("StyleRule", {
		Priority = t1.Priority or 1,
		Selector = t1.Selector,
		ref = v5
	})
end

return React.memo(StyleRule)
