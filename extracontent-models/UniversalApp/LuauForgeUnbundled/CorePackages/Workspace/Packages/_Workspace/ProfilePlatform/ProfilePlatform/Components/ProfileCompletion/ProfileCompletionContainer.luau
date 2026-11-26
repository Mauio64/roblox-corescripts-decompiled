local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactNavigation")

local SocialServerDrivenUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialServerDrivenUi")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local socialSduiComponentWrapper = SocialServerDrivenUi.SocialSduiComponentWrapper
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local useProfileCompletionSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCompletionSduiContext")
local useProfileCompletionData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCompletionData")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local useScreenSize = RobloxAppHooks.useScreenSize

local function ProfileCompletionContainer(p2)
	local v5 = useProfileAnalyticsContext()
	local v6 = useScreenSize()
	local v7, v8 = useDynamicSizeMargin()

	local state, setState = React.useState(v6.X)
	local v9 = useProfileCompletionSduiContext({ sideMargin = v7, containerWidth = state })

	local v10 = React.useMemo(function()
		return { collectionPosition = p2.layoutOrder }
	end, { p2.layoutOrder })

	local ref = React.useRef(nil)
	local v11 = React.useCallback(function(p3)
		v8(p3)
		setState(p3.AbsoluteSize.X)
	end, { v8, setState })

	React.useEffect(function()
		SocialServerDrivenUi.registerSocialActions()
	end, {})

	local v12, v13 = useProfileCompletionData()

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, { onDidFocus = v13 }),
		Content = 0
	}

	local v16 = if v12 then React.createElement(socialSduiComponentWrapper, {
		layoutOrder = p2.layoutOrder,
		sduiContext = v9,
		sduiComponentConfig = v12,
		pageSideMargin = v7,
		onFrameResized = v11,
		verticalScrollingFrameRef = ref,
		scrollViewPositionChangedSignal = v5.scrollViewPositionChangedSignal,
		analyticsContext = v10,
		debugName = Enums.Components.ProfileCompletion,
		testId = "profile-completion"
	}) else nil
	v15.Content = v16
	return createElement(fragment, nil, v15)
end

return React.memo(ProfileCompletionContainer)
