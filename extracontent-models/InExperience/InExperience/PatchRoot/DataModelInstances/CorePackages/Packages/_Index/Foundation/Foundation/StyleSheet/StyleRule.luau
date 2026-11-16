local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local function StyleRule(props)
	local ref = React.useCallback(function(object)
		if object ~= nil then
			object:SetProperties(props.properties)
		end
	end, { props.properties })

	return React.createElement("StyleRule", {
		Priority = props.Priority or 1,
		Selector = props.Selector,
		ref = ref
	})
end

return React.memo(StyleRule)
