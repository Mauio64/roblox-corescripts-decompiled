require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/AppStartupSequence")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/AppCommonLib")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/React")

return function(p2)
	local state, setState = React.useState(p2.appStartupSequence.isInteractive)

	React.useEffect(function()
		local changedConnection = nil

		if p2.appStartupSequence.isInteractive then
			setState(true)
		else
			changedConnection = p2.appStartupSequence.changed:connect(function()
				setState(p2.appStartupSequence.isInteractive)

				if changedConnection ~= nil and p2.appStartupSequence.isInteractive then
					changedConnection:disconnect()
					changedConnection = nil
				end
			end)
		end

		return if changedConnection then changedConnection.disconnect else nil
	end, { p2.appStartupSequence })
	return React.createElement(React.Fragment, nil, not state and {} or p2.children)
end
