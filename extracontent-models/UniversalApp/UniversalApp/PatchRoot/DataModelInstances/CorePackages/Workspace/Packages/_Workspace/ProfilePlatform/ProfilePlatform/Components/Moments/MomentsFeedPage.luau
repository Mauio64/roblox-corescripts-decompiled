local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Navigation = require(Parent.Navigation)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local RoactUtils = require(Parent.RoactUtils)
local MomentsCommon = require(Parent.MomentsCommon)
local Moments = require(Parent.Moments)
local FFlagEnableArgusImmersiveNav = require(Parent.SharedFlags).FFlagEnableArgusImmersiveNav
local View = Foundation.View
local IconButton = Foundation.IconButton
local ButtonSize = Foundation.Enums.ButtonSize
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local useScreenSize = RobloxAppHooks.useScreenSize
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent
local EventNames = MomentsCommon.Analytics.EventNames
local useNavigation = Navigation.useNavigation
local Feed = Moments.Feed
local MomentsImmersivePresentation = Moments.MomentsImmersivePresentation
local CreateUserMomentsFeedSource = require(Parent.Moments.CreateUserMomentsFeedSource)

local function MomentsFeedPageImmersive() -- line: 50
	-- upvalues: useNavigation (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), useScreenSize (copy), View (copy), MomentsImmersivePresentation (copy)
	local v26 = useNavigation()
	local v27 = v26.getParam("extraProps")
	local v28 = (not v27 or not v27.targetUserId) and 0 or v27.targetUserId
	local v29 = (not v27 or not v27.initialIndex) and 1 or v27.initialIndex
	local v30 = React.useCallback(function() -- line: 57
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v28 (copy), v26 (copy)
		fireAnalyticsEvent(EventNames.ProfileClosePressed, {
			userId = tostring(v28)
		})
		v26.goBack()
	end, {
		v26.goBack,
		v28
	})
	local v31 = useScreenSize()

	return React.createElement(View, {
		tag = "bg-surface-0",
		Size = UDim2.fromOffset(v31.X, v31.Y)
	}, {
		Presentation = React.createElement(MomentsImmersivePresentation, {
			feedKind = "user",
			sessionSource = "profile",
			targetUserId = v28,
			initialIndex = v29,
			onBack = v30
		})
	})
end
local function MomentsFeedPageLegacy() -- line: 86
	-- upvalues: useNavigation (copy), React (copy), CreateUserMomentsFeedSource (copy), fireAnalyticsEvent (copy), EventNames (copy), useScreenSize (copy), useSelector (copy), useStatusBarHeight (copy), View (copy), FoundationProvider (copy), Theme (copy), Feed (copy), IconButton (copy), ButtonSize (copy)
	local v32 = useNavigation()
	local v33 = v32.getParam("extraProps")
	local v34 = (not v33 or not v33.targetUserId) and 0 or v33.targetUserId
	local v35 = (not v33 or not v33.initialIndex) and 1 or v33.initialIndex
	local v36 = React.useMemo(function() -- line: 93
		-- upvalues: CreateUserMomentsFeedSource (copy), v34 (copy), v35 (copy)
		return CreateUserMomentsFeedSource(v34, {
			initialIndex = v35
		})
	end, {
		v34,
		v35
	})
	local v37 = React.useCallback(function() -- line: 99
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v34 (copy), v32 (copy)
		fireAnalyticsEvent(EventNames.ProfileClosePressed, {
			userId = tostring(v34)
		})
		v32.goBack()
	end, {
		v32.goBack,
		v34
	})
	local v38 = useScreenSize()
	local v39 = useSelector(function(p1) -- line: 109
		return p1.GlobalGuiInset
	end)
	local v40 = useStatusBarHeight()

	return React.createElement(View, {
		tag = "bg-surface-0",
		Size = UDim2.fromOffset(v38.X, v38.Y),
		padding = {
			top = UDim.new(0, v39.top + v40),
			bottom = UDim.new(0, v39.bottom),
			left = UDim.new(0, v39.left),
			right = UDim.new(0, v39.right)
		}
	}, {
		OnVideoUI = React.createElement(FoundationProvider, {
			theme = Theme.Dark
		}, {
			Feed = React.createElement(Feed, {
				active = true,
				playbackActive = true,
				source = v36,
				initialIndex = v35
			}),
			CloseButtonContainer = React.createElement(View, {
				tag = "position-top-left anchor-top-left auto-xy padding-large",
				ZIndex = 100000
			}, {
				CloseButton = React.createElement(IconButton, {
					icon = "icons/navigation/close",
					size = ButtonSize.Medium,
					onActivated = v37
				})
			})
		})
	})
end

if FFlagEnableArgusImmersiveNav then
	return MomentsFeedPageImmersive
end

return MomentsFeedPageLegacy
