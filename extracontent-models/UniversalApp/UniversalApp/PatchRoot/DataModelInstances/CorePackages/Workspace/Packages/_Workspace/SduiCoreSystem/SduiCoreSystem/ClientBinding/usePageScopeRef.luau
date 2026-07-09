local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local React = require(SduiCoreSystemParent.React)
local SharedFlags = require(SduiCoreSystemParent.SharedFlags)
local getSduiClientPageScope = require(SduiCoreSystem.ClientBinding.getSduiClientPageScope)
local FFlagSduiClientPageScope = SharedFlags.FFlagSduiClientPageScope

local function usePageScopeRef(s1: string?) -- line: 20
	-- upvalues: React (copy), FFlagSduiClientPageScope (copy), getSduiClientPageScope (copy)
	local v9 = React.useRef(nil)

	if FFlagSduiClientPageScope and (s1 and v9.current == nil) then
		v9.current = getSduiClientPageScope(s1)
	end

	return v9.current
end

return usePageScopeRef
