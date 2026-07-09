local CorePackages = game:GetService("CorePackages")
local SetConnectionState = require(CorePackages.Workspace.Packages.AppChat.SetConnectionState)

return function(p1, p2) -- line: 6
	-- upvalues: SetConnectionState (copy)
	local v5 = p1 or Enum.ConnectionState.Connected

	if p2.type == SetConnectionState.name then
		v5 = p2.connectionState
	end

	return v5
end
