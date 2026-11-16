local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local CreatorCreditPageView = require(script.Parent.CreatorCreditPageView)
local DailyLimitBottomSheet = require(script.Parent.DailyLimitBottomSheet)
local useCreatorCreditPageViewModel = require(script.Parent.useCreatorCreditPageViewModel)

local function CreatorCreditPageContainer(_)
	local v = useCreatorCreditPageViewModel()
	return React.createElement(React.Fragment, nil, {
		Page = React.createElement(CreatorCreditPageView, v.pageProps),
		LimitSheet = React.createElement(DailyLimitBottomSheet, v.limitSheetProps)
	})
end

return CreatorCreditPageContainer
