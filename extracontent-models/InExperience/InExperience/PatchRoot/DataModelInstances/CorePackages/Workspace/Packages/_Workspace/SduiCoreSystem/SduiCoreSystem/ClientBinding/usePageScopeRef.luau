local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local React = require(parent.React)
local getSduiClientPageScope = require(SduiCoreSystem.ClientBinding.getSduiClientPageScope)

local function usePageScopeRef(p: string?)
	local ref = React.useRef(nil)

	if p and ref.current == nil then
		ref.current = getSduiClientPageScope(p)
	end

	return ref.current
end

return usePageScopeRef
