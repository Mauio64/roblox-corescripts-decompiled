local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")

local parent = ServerDrivenUi.Parent
local React = require(parent.React)

require(parent.SduiCoreSystem)

local useSduiSocialData = require(ServerDrivenUi.DataStore.useSduiSocialData)

local function useSduiDataStore()
	local social = useSduiSocialData()

	return React.useMemo(function()
		return { social = social }
	end, { social })
end

return useSduiDataStore
