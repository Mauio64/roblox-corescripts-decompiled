local AppStartup = script:FindFirstAncestor("AppStartup")
local AppStartupParent = AppStartup.Parent

require(AppStartup.AppStartupSequence)
require(AppStartupParent.AppCommonLib)

local React = require(AppStartupParent.React)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy)
	local v5, v6 = React.useState(t1.appStartupSequence.isInteractive)

	React.useEffect(function() -- line: 17
		-- upvalues: t1 (copy), v6 (copy)
		local u7 = nil

		if t1.appStartupSequence.isInteractive then
			v6(true)
		else
			u7 = t1.appStartupSequence.changed:connect(function() -- line: 23
				-- upvalues: v6 (copy), t1 (copy), u7 (ref)
				v6(t1.appStartupSequence.isInteractive)

				if u7 ~= nil and t1.appStartupSequence.isInteractive then
					u7:disconnect()
					u7 = nil
				end
			end)
		end

		return if not u7 then nil else u7.disconnect
	end, { t1.appStartupSequence })

	return React.createElement(React.Fragment, nil, if not v5 then {} else t1.children)
end
