local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local CreatorCreditPageView = require(script.Parent.CreatorCreditPageView)
local DailyLimitBottomSheet = require(script.Parent.DailyLimitBottomSheet)
local useCreatorCreditPageViewModel = require(script.Parent.useCreatorCreditPageViewModel)

local function CreatorCreditPageContainer(_: {[any]: any}) -- line: 12
	-- upvalues: useCreatorCreditPageViewModel (copy), React (copy), CreatorCreditPageView (copy), DailyLimitBottomSheet (copy)
	local v8 = useCreatorCreditPageViewModel()

	return React.createElement(React.Fragment, nil, {
		Page = React.createElement(CreatorCreditPageView, v8.pageProps),
		LimitSheet = React.createElement(DailyLimitBottomSheet, v8.limitSheetProps)
	})
end

return CreatorCreditPageContainer
