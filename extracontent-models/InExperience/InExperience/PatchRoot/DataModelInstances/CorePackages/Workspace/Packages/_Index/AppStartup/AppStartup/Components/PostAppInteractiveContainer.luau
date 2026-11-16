local AppStartup = script:FindFirstAncestor("AppStartup")
local parent = AppStartup.Parent

require(AppStartup.AppStartupSequence)
require(parent.AppCommonLib)
local React = require(parent.React)

return function(p)
	local state, setState = React.useState(p.appStartupSequence.isInteractive)

	React.useEffect(function()
		local changedConnection = nil

		if p.appStartupSequence.isInteractive then
			setState(true)
		else
			changedConnection = p.appStartupSequence.changed:connect(function()
				setState(p.appStartupSequence.isInteractive)

				if changedConnection ~= nil and p.appStartupSequence.isInteractive then
					changedConnection:disconnect()
					changedConnection = nil
				end
			end)
		end

		local v

		if changedConnection then
			return changedConnection.disconnect
		end

		return v
	end, { p.appStartupSequence })
	return React.createElement(React.Fragment, nil, not state and {} or p.children)
end
