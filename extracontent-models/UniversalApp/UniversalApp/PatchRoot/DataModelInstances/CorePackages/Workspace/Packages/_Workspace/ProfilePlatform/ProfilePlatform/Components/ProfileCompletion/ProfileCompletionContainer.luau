local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RoactNavigation = require(ProfilePlatformParent.RoactNavigation)
local SocialServerDrivenUi = require(ProfilePlatformParent.SocialServerDrivenUi)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local SocialSduiComponentWrapper = SocialServerDrivenUi.SocialSduiComponentWrapper
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileCompletionSduiContext = require(ProfilePlatform.Hooks.useProfileCompletionSduiContext)
local useProfileCompletionData = require(ProfilePlatform.Hooks.useProfileCompletionData)
local Enums = require(ProfilePlatform.Common.Enums)
local useScreenSize = RobloxAppHooks.useScreenSize

local function ProfileCompletionContainer(t1: {[any]: any}) -- line: 22
	-- upvalues: useProfileAnalyticsContext (copy), useScreenSize (copy), useDynamicSizeMargin (copy), React (copy), useProfileCompletionSduiContext (copy), SocialServerDrivenUi (copy), useProfileCompletionData (copy), RoactNavigation (copy), SocialSduiComponentWrapper (copy), Enums (copy)
	local v16 = useProfileAnalyticsContext()
	local v17 = useScreenSize()
	local v18, v19 = useDynamicSizeMargin()
	local v20, v21 = React.useState(v17.X)
	local v22 = useProfileCompletionSduiContext({
		sideMargin = v18,
		containerWidth = v20
	})
	local v23 = React.useMemo(function() -- line: 33
		-- upvalues: t1 (copy)
		return {
			collectionPosition = t1.layoutOrder
		}
	end, { t1.layoutOrder })
	local v24 = React.useRef(nil)
	local v25 = React.useCallback(function(p1) -- line: 38
		-- upvalues: v19 (copy), v21 (copy)
		v19(p1)
		v21(p1.AbsoluteSize.X)
	end, {
		v19,
		v21
	})

	React.useEffect(function() -- line: 43
		-- upvalues: SocialServerDrivenUi (copy)
		SocialServerDrivenUi.registerSocialActions()
	end, {})

	local v26, v27 = useProfileCompletionData()

	return React.createElement(React.Fragment, nil, {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = v27
		}),
		Content = if not v26 then nil else React.createElement(SocialSduiComponentWrapper, {
			testId = "profile-completion",
			layoutOrder = t1.layoutOrder,
			sduiContext = v22,
			sduiComponentConfig = v26,
			pageSideMargin = v18,
			onFrameResized = v25,
			verticalScrollingFrameRef = v24,
			scrollViewPositionChangedSignal = v16.scrollViewPositionChangedSignal,
			analyticsContext = v23,
			debugName = Enums.Components.ProfileCompletion
		})
	})
end

return React.memo(ProfileCompletionContainer)
