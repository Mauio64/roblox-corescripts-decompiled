local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)

require(ServerDrivenUiParent.SduiCoreSystem)

local useSduiSocialData = require(ServerDrivenUi.DataStore.useSduiSocialData)

local function useSduiDataStore() -- line: 16
	-- upvalues: useSduiSocialData (copy), React (copy)
	local v6 = useSduiSocialData()

	return React.useMemo(function() -- line: 19
		-- upvalues: v6 (copy)
		return {
			social = v6
		}
	end, { v6 })
end

return useSduiDataStore
