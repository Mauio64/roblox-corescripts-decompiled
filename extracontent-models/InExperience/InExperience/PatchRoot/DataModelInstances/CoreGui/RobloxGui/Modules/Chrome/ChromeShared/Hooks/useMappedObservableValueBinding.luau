local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(ChromeShared.Service.ChromeUtils)

return function(object, callback)
	if not object then
		warn("observableValue undefined")
		return React.useBinding(nil)
	end

	local v = callback or function(p)
		return p
	end

	local v2, v3 = React.useBinding(v(object:get()))

	React.useEffect(function()
		local connection = object:connect(function()
			v3(v(object:get()))
		end)

		v3(v(object:get()))

		return function()
			connection:disconnect()
		end
	end, { object })

	return v2
end
