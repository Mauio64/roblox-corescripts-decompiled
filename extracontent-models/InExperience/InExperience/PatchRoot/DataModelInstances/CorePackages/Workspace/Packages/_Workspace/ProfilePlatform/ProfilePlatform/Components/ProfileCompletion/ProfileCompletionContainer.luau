local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local SocialServerDrivenUi = require(parent.SocialServerDrivenUi)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SocialSduiComponentWrapper = SocialServerDrivenUi.SocialSduiComponentWrapper
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileCompletionSduiContext = require(ProfilePlatform.Hooks.useProfileCompletionSduiContext)
local useProfileCompletionData = require(ProfilePlatform.Hooks.useProfileCompletionData)
local Enums = require(ProfilePlatform.Common.Enums)

local useScreenSize = RobloxAppHooks.useScreenSize

local function ProfileCompletionContainer(p)
	local v = useProfileAnalyticsContext()
	local v2 = useScreenSize()
	local v3, v4 = useDynamicSizeMargin()

	local state, setState = React.useState(v2.X)
	local sduiContext = useProfileCompletionSduiContext({ sideMargin = v3, containerWidth = state })

	local analyticsContext = React.useMemo(function()
		return { collectionPosition = p.layoutOrder }
	end, { p.layoutOrder })

	local ref = React.useRef(nil)
	local onFrameResized = React.useCallback(function(p2)
		v4(p2)
		setState(p2.AbsoluteSize.X)
	end, { v4, setState })

	React.useEffect(function()
		SocialServerDrivenUi.registerSocialActions()
	end, {})

	local sduiComponentConfig, onDidFocus = useProfileCompletionData()

	local createElement = React.createElement
	local fragment = React.Fragment
	local v5 = {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = onDidFocus
		}),
		Content = 0
	}
	local content

	if sduiComponentConfig then
		content = React.createElement(SocialSduiComponentWrapper, {
			layoutOrder = p.layoutOrder,
			sduiContext = sduiContext,
			sduiComponentConfig = sduiComponentConfig,
			pageSideMargin = v3,
			onFrameResized = onFrameResized,
			verticalScrollingFrameRef = ref,
			scrollViewPositionChangedSignal = v.scrollViewPositionChangedSignal,
			analyticsContext = analyticsContext,
			debugName = Enums.Components.ProfileCompletion,
			testId = "profile-completion"
		})
	end

	v5.Content = content
	return createElement(fragment, nil, v5)
end

return React.memo(ProfileCompletionContainer)
