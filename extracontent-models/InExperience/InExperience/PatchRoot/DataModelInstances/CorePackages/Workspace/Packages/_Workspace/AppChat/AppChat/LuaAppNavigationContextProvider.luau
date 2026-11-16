local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local LuaAppNavigationContext = require(script.Parent.LuaAppNavigationContext)
local EnumScreens = require(script.Parent.EnumScreens)
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new(script.Name)
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)

local OpenUnfilteredThreadsLearnMoreLink = require(AppChat.Conversations.Thunks.OpenUnfilteredThreadsLearnMoreLink)

local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

function generateNavigateToGroups(p, callback)
	return function()
		if callback then
			callback()
		end

		if p == nil then
			return
		end

		local v2 = p[EnumScreens.Groups]

		if not v2 then
			v:warning("Groups page was not set in navigateToLuaAppPages")

			return
		end

		v:info("Navigate To Groups from App Chat")
		v2()
	end
end

local function generateNavigateToUnfilteredThreadsLearnMore(dispatch, placementInExperience: boolean?) -- 1 equivalent call inferred from this helper
	return function(callback)
		if not dispatch then
			return
		end

		if not placementInExperience then
			dispatch(OpenUnfilteredThreadsLearnMoreLink())
		elseif callback then
			callback(EnumScreens.LearnMorePartialModal, {}, true)
		end
	end
end

function LuaAppNavigationContextProvider(props)
	local ref = React.useRef(function() end)

	local placementInExperience = isPlacementInExperience(useChatPlacementContext().chatPlacement)

	local v2 = useAnalytics()

	if v2 then
		function ref.current()
			v2.fireAnalyticsEvent(EventNames.ChatLandingGroupsBtnClicked)
		end
	end

	return React.createElement(LuaAppNavigationContext.Provider, {
		value = {
			navigateToGroups = generateNavigateToGroups(props.navigateToLuaAppPages, ref.current),
			navigateToUnfilteredThreadsLearnMore = generateNavigateToUnfilteredThreadsLearnMore( -- inferred equivalent call
				props.dispatch,
				placementInExperience
			)
		}
	}, props.children)
end

return LuaAppNavigationContextProvider
