local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiClientPageScope")

local function usePageScopeRef(p2)
	local ref = React.useRef(nil)

	if p2 and ref.current == nil then
		ref.current = getSduiClientPageScope(p2)
	end

	return ref.current
end

return usePageScopeRef
