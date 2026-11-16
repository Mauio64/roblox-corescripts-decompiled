local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(ChromeShared.Service.ChromeUtils)

return function(object)
	if not object then
		warn("observableValue undefined")
		return nil
	end

	local state, setState = React.useState(object:get())
	React.useEffect(function()
		local connection = object:connect(function()
			setState(object:get())
		end)

		if state ~= object:get() then
			setState(object:get())
		end

		return function()
			connection:disconnect()
		end
	end, { object })

	return state
end
