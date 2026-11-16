local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Button = Foundation.Button

local useSignalState = SignalsReact.useSignalState

require(Moments.ExperienceDetailsSheet.Types)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useJoinExperience = require(script.Parent.useJoinExperience)
local useJoinCtaImpression = require(script.Parent.useJoinCtaImpression)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local FFlagMomentsFixRecommendationImpressionLifecycle = require(Moments.Flags.FFlagMomentsFixRecommendationImpressionLifecycle)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)
local FFlagMomentsPlayEvent = require(Moments.Flags.FFlagMomentsPlayEvent)

local function JoinButton(props)
	local v = useJoinExperience()
	local v2 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)

	useJoinCtaImpression(props.isDisabled == true, props.reportsImpression == true)
	local v3

	if FFlagMomentsFixRecommendationImpressionLifecycle then
		v3 = FeedContext.useFeedOptional()
	else
		v3 = nil
	end

	local context = props.context

	return React.createElement(Button, {
		LayoutOrder = props.LayoutOrder,
		text = props.text,
		size = Foundation.Enums.InputSize.Medium,
		variant = Foundation.Enums.ButtonVariant.Emphasis,
		isDisabled = props.isDisabled == true or v2,
		testId = props.testId,
		onActivated = function()
			local v4

			if FFlagMomentsFixRecommendationImpressionLifecycle and v3 ~= nil then
				local flushView = v3.flushView
				local v5

				if FFlagMomentsNavigationEvent then
					v5 = NavigationDestinationType.ExperienceJoin
				end

				v4 = flushView(v5)
			end

			if not FFlagMomentsPlayEvent then
				v4 = nil
			end

			v(context, nil, v4)
		end
	})
end

return React.memo(JoinButton)
