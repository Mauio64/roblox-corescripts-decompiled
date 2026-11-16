local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local button = Foundation.Button

local useSignalState = SignalsReact.useSignalState

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Types")
local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
local useJoinExperience = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Join/useJoinExperience")
local useJoinCtaImpression = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Join/useJoinCtaImpression")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")

local FFlagMomentsFixRecommendationImpressionLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixRecommendationImpressionLifecycle")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")
local FFlagMomentsPlayEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsPlayEvent")

local function JoinButton(props)
	local v5 = useJoinExperience()
	local v6 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	useJoinCtaImpression(props.isDisabled == true, props.reportsImpression == true)

	local v7 = if FFlagMomentsFixRecommendationImpressionLifecycle then FeedContext.useFeedOptional() else nil

	local context = props.context

	return React.createElement(button, {
		LayoutOrder = props.LayoutOrder,
		text = props.text,
		size = Foundation.Enums.InputSize.Medium,
		variant = Foundation.Enums.ButtonVariant.Emphasis,
		isDisabled = props.isDisabled == true or v6,
		testId = props.testId,
		onActivated = function()
			local v8

			if FFlagMomentsFixRecommendationImpressionLifecycle and v7 ~= nil then
				local flushView = v7.flushView
				local v9 = if FFlagMomentsNavigationEvent then NavigationDestinationType.ExperienceJoin else nil
				v8 = flushView(v9)
			end

			if not FFlagMomentsPlayEvent then
				v8 = nil
			end

			v5(context, nil, v8)
		end
	})
end

return React.memo(JoinButton)
