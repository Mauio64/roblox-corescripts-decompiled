local function registerBackHandler(p2)
	return function() end
end

return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React").createContext(registerBackHandler)
