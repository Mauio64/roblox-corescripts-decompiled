local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(CorePackages.Workspace.Packages.Chrome)

return function(p)
	if not (p and p.windowSize) then
		warn("windowSize object not found")
		return UDim2.new()
	end

	local windowSize = p.windowSize

	local state, setState = React.useState(windowSize:get())

	React.useEffect(function()
		local connection = windowSize:connect(function()
			setState(windowSize:get())
		end)

		if state ~= windowSize:get() then
			setState(windowSize:get())
		end

		return function()
			connection:disconnect()
		end
	end, { p.id })

	return state
end
