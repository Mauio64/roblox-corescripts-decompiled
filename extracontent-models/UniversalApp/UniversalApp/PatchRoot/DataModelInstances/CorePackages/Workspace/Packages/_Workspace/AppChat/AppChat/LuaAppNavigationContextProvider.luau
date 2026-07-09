local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local LuaAppNavigationContext = require(script.Parent.LuaAppNavigationContext)
local EnumScreens = require(script.Parent.EnumScreens)
local v6 = require(AppChatParent.Loggers).Logger:new(script.Name)
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local OpenUnfilteredThreadsLearnMoreLink = require(AppChat.Conversations.Thunks.OpenUnfilteredThreadsLearnMoreLink)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

function generateNavigateToGroups(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 23
	-- upvalues: EnumScreens (copy), v6 (copy)
	return function() -- line: 24
		-- upvalues: p1 (copy), t1 (copy), EnumScreens (copy), v6 (copy)
		if p1 then
			p1()
		end

		if t1 == nil then
			return
		end

		local v28 = t1[EnumScreens.Groups]

		if v28 then
			v6:info("Navigate To Groups from App Chat")
			v28()

			return
		end

		v6:warning("Groups page was not set in navigateToLuaAppPages")
	end
end

local function generateNavigateToUnfilteredThreadsLearnMore(p2, b1: boolean?) -- line: 43
	-- upvalues: EnumScreens (copy), OpenUnfilteredThreadsLearnMoreLink (copy)
	return function(p3: ((...any) -> ...any)) -- line: 44
		-- upvalues: p2 (copy), b1 (copy), EnumScreens (copy), OpenUnfilteredThreadsLearnMoreLink (copy)
		if not p2 then
			return
		end

		if b1 then
			if p3 then
				p3(EnumScreens.LearnMorePartialModal, {}, true)
			end

			return
		end

		p2(OpenUnfilteredThreadsLearnMoreLink())
	end
end

function LuaAppNavigationContextProvider(t2: {[any]: any}) -- line: 58
	-- upvalues: React (copy), useChatPlacementContext (copy), isPlacementInExperience (copy), useAnalytics (copy), EventNames (copy), LuaAppNavigationContext (copy), EnumScreens (copy), OpenUnfilteredThreadsLearnMoreLink (copy)
	local v19 = React.useRef(function() -- line: 59
	end)
	local chatPlacement = useChatPlacementContext().chatPlacement
	local v21 = isPlacementInExperience(chatPlacement)
	local v22 = useAnalytics()

	if v22 then
		function v19.current() -- line: 66
			-- upvalues: v22 (copy), EventNames (copy)
			v22.fireAnalyticsEvent(EventNames.ChatLandingGroupsBtnClicked)
		end
	end

	local createElement = React.createElement
	local Provider = LuaAppNavigationContext.Provider
	local t3 = {}
	local t4 = {
		navigateToGroups = generateNavigateToGroups(t2.navigateToLuaAppPages, v19.current)
	}
	local dispatch = t2.dispatch

	function t4.navigateToUnfilteredThreadsLearnMore(p4: ((...any) -> ...any)) -- line: 44
		-- upvalues: dispatch (copy), v21 (copy), EnumScreens (copy), OpenUnfilteredThreadsLearnMoreLink (copy)
		if not dispatch then
			return
		end

		if v21 then
			if p4 then
				p4(EnumScreens.LearnMorePartialModal, {}, true)
			end

			return
		end

		dispatch(OpenUnfilteredThreadsLearnMoreLink())
	end

	t3.value = t4

	return createElement(Provider, t3, t2.children)
end

return LuaAppNavigationContextProvider
