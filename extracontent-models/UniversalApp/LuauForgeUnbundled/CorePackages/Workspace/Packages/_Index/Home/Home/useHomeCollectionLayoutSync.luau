local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/React")
local startHomeCollectionLayoutSync = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/startHomeCollectionLayoutSync")

local fFlagEnableHomePageSduiPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagEnableHomePageSduiPrefetch

local function useHomeCollectionLayoutSync()
	React.useEffect(function()
		if fFlagEnableHomePageSduiPrefetch then
			return startHomeCollectionLayoutSync()
		end
	end, {})
end

return useHomeCollectionLayoutSync
