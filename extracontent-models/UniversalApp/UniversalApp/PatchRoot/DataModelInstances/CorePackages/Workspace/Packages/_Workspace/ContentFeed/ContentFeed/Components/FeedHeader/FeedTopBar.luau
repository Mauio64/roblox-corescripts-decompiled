local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local Otter = require(ParentParentParent.Otter)
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local FeedHeader = require(ParentParent.Components.FeedHeader.FeedHeader)
local View = Foundation.View
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local EventNames = require(ParentParent.Analytics.EventNames)
local FeedContext = require(ParentParent.App.FeedContext)
local Images = UIBlox.App.ImageSet.Images
local MenuDirection = UIBlox.App.Menu.MenuDirection
local RemovePost = require(ParentParent.Thunks.RemovePost)
local useAnalytics = require(ParentParent.Hooks.useAnalytics)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSafeZoneOffsets = require(ParentParent.Hooks.useSafeZoneOffsets)
local useScreenSize = RobloxAppHooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	motorCallback = Otter.instant,
	open = {
		targetValue = 1
	},
	close = {
		targetValue = 0
	}
}

return function(t2: {[any]: any}) -- line: 58
	-- upvalues: Players (copy), React (copy), FeedContext (copy), useLocalization (copy), useAnalytics (copy), useDispatch (copy), useTokens (copy), useScreenSize (copy), useSafeZoneOffsets (copy), useAnimatedBinding (copy), ReactOtter (copy), EventNames (copy), ContextActionService (copy), RemovePost (copy), Images (copy), View (copy), ContextualMenu (copy), MenuDirection (copy), t1 (copy), FeedHeader (copy)
	local v30 = (not Players or not Players.LocalPlayer) and "" or tostring(Players.LocalPlayer.UserId)
	local v31 = React.useContext(FeedContext)
	local v32 = useLocalization({
		removePost = "Feature.ContentFeed.Action.Delete",
		report = "Feature.ContentFeed.Action.Report"
	})
	local v33 = useAnalytics()
	local v34 = useDispatch()
	local v35 = useTokens()
	local v36 = useScreenSize()
	local v37 = useSafeZoneOffsets()
	local v38, v39 = React.useState(false)
	local v40, v41 = useAnimatedBinding(0)

	React.useEffect(function() -- line: 77
		-- upvalues: v31 (copy), v41 (copy), ReactOtter (copy)
		if v31.isZooming then
			v41(ReactOtter.spring(1, {
				dampingRatio = 1,
				frequency = 4
			}))

			return
		end

		v41(ReactOtter.spring(0, {
			dampingRatio = 1,
			frequency = 4
		}))
	end, { v31.isZooming })

	local v42 = React.useCallback(function() -- line: 91
		-- upvalues: v39 (copy)
		v39(false)
	end, {})
	local v43 = React.useCallback(function() -- line: 95
		-- upvalues: v31 (copy), v33 (copy), EventNames (copy), t2 (copy)
		if v31.isZooming then
			return
		end

		v33.fireEvent(EventNames.ContentFeedExitCtaPressed, {
			postId = t2.postId
		})
		v31.navigateBack(false)
	end, {
		v33.fireEvent,
		v31.isZooming,
		v31.navigateBack
	})
	local v44 = React.useCallback(function() -- line: 106
		-- upvalues: v33 (copy), EventNames (copy), t2 (copy), v31 (copy)
		v33.fireEvent(EventNames.ContentFeedCloseShortcutPressed, {
			postId = t2.postId
		})
		v31.navigateBack(false)
	end, {
		v33.fireEvent,
		v31.navigateBack
	})

	React.useEffect(function() -- line: 113
		-- upvalues: ContextActionService (copy), v44 (copy)
		ContextActionService:BindCoreAction("ContentFeedCloseShortcutAction", function(_, p2) -- line: 114
			-- upvalues: v44 (copy)
			if p2 == Enum.UserInputState.End then
				v44()
			end
		end, false, Enum.KeyCode.Escape)

		return function() -- line: 120
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("ContentFeedCloseShortcutAction")
		end
	end, { v44 })

	local v45 = React.useCallback(function() -- line: 125
		-- upvalues: v31 (copy), v33 (copy), EventNames (copy), t2 (copy), v39 (copy), v38 (copy)
		if v31.isZooming then
			return
		end

		v33.fireEvent(EventNames.ContentFeedMoreMenuButtonPressed, {
			postId = t2.postId
		})
		v39(not v38)
	end, {
		v33.fireEvent,
		v31.isZooming,
		v38,
		t2.postId
	})
	local v46 = React.useCallback(function() -- line: 136
		-- upvalues: v33 (copy), EventNames (copy), t2 (copy), v31 (copy), v39 (copy)
		v33.fireEvent(EventNames.ContentFeedReportCtaPressed, {
			postId = t2.postId
		})
		v31.navigateToReportPage(t2.postId)
		v39(false)
	end, {
		v33.fireEvent,
		v31.navigateToReportPage,
		t2.postId
	})
	local v47 = React.useCallback(function() -- line: 144
		-- upvalues: v33 (copy), EventNames (copy), t2 (copy), v34 (copy), RemovePost (copy), v39 (copy)
		v33.fireEvent(EventNames.ContentFeedDeleteCtaPressed, {
			postId = t2.postId
		})
		v34(RemovePost(t2.postId))
		t2.removePostTransition()
		v39(false)
	end, {
		v33.fireEvent,
		t2.postId,
		t2.removePostTransition
	})
	local t3 = {}

	if v30 ~= t2.creatorId then
		table.insert(t3, {
			icon = Images["icons/actions/feedback"],
			onActivated = v46,
			text = v32.report
		})
	end

	if v30 == t2.creatorId then
		table.insert(t3, {
			icon = Images["icons/actions/edit/delete"],
			onActivated = v47,
			text = v32.removePost
		})
	end

	return React.createElement(View, {
		tag = "bg-action-subtle",
		GroupTransparency = if not v31.isZooming then nil else v40:map(function(p3) -- line: 173
			return p3
		end),
		Position = UDim2.fromOffset(0, v37.top),
		Size = UDim2.new(1, 0, 0, 56),
		ZIndex = t2.ZIndex
	}, {
		GradientBackdrop = React.createElement(View, {
			tag = "col size-full-full bg-contrast",
			ZIndex = 0,
			Position = UDim2.fromOffset(0, -v37.top),
			Size = UDim2.new(1, 0, 1, v37.top)
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v35.Color.OverMedia.OverMedia_0.Color3),
					ColorSequenceKeypoint.new(1, v35.Color.OverMedia.OverMedia_0.Color3)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.5),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ContextualMenu = React.createElement(ContextualMenu, {
			closeBackgroundVisible = false,
			zIndex = 2,
			buttonProps = t3,
			horizontalAlignment = Enum.HorizontalAlignment.Right,
			menuDirection = MenuDirection.Down,
			motorOverrideOptions = t1,
			onDismiss = v42,
			open = v38,
			openPositionX = UDim.new(0, -12),
			openPositionY = UDim.new(0, 56),
			screenSize = v36
		}),
		FeedHeader = React.createElement(FeedHeader, {
			ZIndex = 1,
			isContextualMenuOpen = v38,
			isPlaceholderPost = t2.isPlaceholderPost,
			onBackActivated = v43,
			onMoreActivated = v45
		})
	})
end
