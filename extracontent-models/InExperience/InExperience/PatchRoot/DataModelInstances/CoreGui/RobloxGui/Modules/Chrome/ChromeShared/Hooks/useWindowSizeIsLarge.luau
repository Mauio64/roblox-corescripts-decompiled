local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function(object)
	local state, setState = React.useState(object:getIsLarge())

	React.useEffect(function()
		local connection = object:connect(function()
			setState(object:getIsLarge())
		end)

		if state ~= object:getIsLarge() then
			setState(object:getIsLarge())
		end

		return function()
			connection:disconnect()
		end
	end, { object })

	return state
end
