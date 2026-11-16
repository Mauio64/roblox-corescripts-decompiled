local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(ChromeShared.Service.ChromeUtils)

return function(object, callback)
	if not object then
		warn("observableValue undefined")
		return nil
	end

	local state, setState = React.useState(callback(object:get()))
	React.useEffect(function()
		local connection = object:connect(function()
			setState(callback(object:get()))
		end)

		local v = callback(object:get())

		if state ~= v then
			setState(v)
		end

		return function()
			connection:disconnect()
		end
	end, { object })

	return state
end
