local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local React = require(parent.React)
local startHomeCollectionLayoutSync = require(Home.startHomeCollectionLayoutSync)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableHomePageSduiPrefetch = SharedFlags.FFlagEnableHomePageSduiPrefetch

local function useHomeCollectionLayoutSync()
	React.useEffect(function()
		if FFlagEnableHomePageSduiPrefetch then
			return startHomeCollectionLayoutSync()
		end
	end, {})
end

return useHomeCollectionLayoutSync
