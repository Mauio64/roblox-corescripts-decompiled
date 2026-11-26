local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local LuaAppNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContext")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger:new("LuaAppNavigationContextProvider")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")

local OpenUnfilteredThreadsLearnMoreLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/OpenUnfilteredThreadsLearnMoreLink")

local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

function LUAUFORGE_MODULE_GLOBALS_hFG_generateNavigateToGroups(p2, callback)
	return function()
		if callback then
			callback()
		end

		if p2 == nil then
			return
		end

		local v6 = p2[EnumScreens.Groups]

		if not v6 then
			v5:warning("Groups page was not set in navigateToLuaAppPages")

			return
		end

		v5:info("Navigate To Groups from App Chat")
		v6()
	end
end

local function generateNavigateToUnfilteredThreadsLearnMore(callback, p2)
	return function(callback2)
		if not callback then
			return
		end

		if not p2 then
			callback(OpenUnfilteredThreadsLearnMoreLink())
		elseif callback2 then
			callback2(EnumScreens.LearnMorePartialModal, {}, true)
		end
	end
end

function LUAUFORGE_MODULE_GLOBALS_hFG_LuaAppNavigationContextProvider(props)
	local ref = React.useRef(function() end)

	local placementInExperience = isPlacementInExperience(useChatPlacementContext().chatPlacement)

	local v6 = useAnalytics()

	if v6 then
		function ref.current()
			v6.fireAnalyticsEvent(EventNames.ChatLandingGroupsBtnClicked)
		end
	end

	local createElement = React.createElement
	local provider = LuaAppNavigationContext.Provider
	local v8 = {
		navigateToGroups = LUAUFORGE_MODULE_GLOBALS_hFG_generateNavigateToGroups(
			props.navigateToLuaAppPages,
			ref.current
		),
		navigateToUnfilteredThreadsLearnMore = 0
	}

	local dispatch = props.dispatch

	function v8.navigateToUnfilteredThreadsLearnMore(callback)
		if not dispatch then
			return
		end

		if not placementInExperience then
			dispatch(OpenUnfilteredThreadsLearnMoreLink())
		elseif callback then
			callback(EnumScreens.LearnMorePartialModal, {}, true)
		end
	end

	return createElement(provider, { value = v8 }, props.children)
end

return LUAUFORGE_MODULE_GLOBALS_hFG_LuaAppNavigationContextProvider
