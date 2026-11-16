local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local CreatorCreditPageView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditPageView")
local DailyLimitBottomSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/DailyLimitBottomSheet")
local useCreatorCreditPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/useCreatorCreditPageViewModel")

local function CreatorCreditPageContainer(p2)
	local v5 = useCreatorCreditPageViewModel()
	return React.createElement(React.Fragment, nil, {
		Page = React.createElement(CreatorCreditPageView, v5.pageProps),
		LimitSheet = React.createElement(DailyLimitBottomSheet, v5.limitSheetProps)
	})
end

return CreatorCreditPageContainer
