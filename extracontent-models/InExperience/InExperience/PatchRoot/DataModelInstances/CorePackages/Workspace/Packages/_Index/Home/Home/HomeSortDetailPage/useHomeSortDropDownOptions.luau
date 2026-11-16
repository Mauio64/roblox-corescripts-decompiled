local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local buildHomeSortDropDownOptions = require(Home.HomeSortDetailPage.buildHomeSortDropDownOptions)
local HomeConstants = require(Home.HomeConstants)

local function useHomeSortDropDownOptions()
	local v = SduiSharedUtilities.useInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
	return React.useMemo(function()
		return buildHomeSortDropDownOptions(v)
	end, { v })
end

return useHomeSortDropDownOptions
