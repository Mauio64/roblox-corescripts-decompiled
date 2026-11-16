local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")

local module = require("@luauforge/deferred/dWM")
local module2 = require("@luauforge/deferred/dWX")
local module3 = require("@luauforge/deferred/dXC")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module5 = require("@luauforge/deferred/dXy")
local module6 = require("@luauforge/deferred/dVP")
local module7 = require("@luauforge/deferred/dWO")
local module8 = require("@luauforge/deferred/dWU")

local module9 = require("@luauforge/deferred/dXD")
local view = module.View

local contextualMenu = module8.App.Menu.ContextualMenu
local module10 = require("@luauforge/deferred/dWP")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local images = module8.App.ImageSet.Images
local menuDirection = module8.App.Menu.MenuDirection
local module12 = require("@luauforge/deferred/dXE")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useAnimatedBinding = module5.useAnimatedBinding
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useLocalization = module2.Hooks.useLocalization
local module14 = require("@luauforge/deferred/dXc")
local useScreenSize = module7.useScreenSize
local useTokens = module.Hooks.useTokens

local v5 = {
	motorCallback = module3.instant,
	open = { targetValue = 1 },
	close = { targetValue = 0 }
}

return function(props)
	local v6 = not (Players and Players.LocalPlayer) and "" or tostring(Players.LocalPlayer.UserId)
	local v7 = React.useContext(CapturesContext)
	local v8 = useLocalization({
		removePost = "Feature.ContentFeed.Action.Delete",
		report = "Feature.ContentFeed.Action.Report"
	})

	local v9 = useAnalytics()
	local v10 = useDispatch()
	local v11 = useTokens()

	local v12 = useScreenSize()
	local v13 = module14()

	local state, setState = React.useState(false)

	local v14, v15 = useAnimatedBinding(0)

	React.useEffect(function()
		if v7.isZooming then
			v15(module5.spring(1, { dampingRatio = 1, frequency = 4 }))
		else
			v15(module5.spring(0, { dampingRatio = 1, frequency = 4 }))
		end
	end, { v7.isZooming })

	local v16 = React.useCallback(function()
		setState(false)
	end, {})

	local v17 = React.useCallback(function()
		if v7.isZooming then
			return
		end

		v9.fireEvent(module10.ContentFeedExitCtaPressed, { postId = props.postId })

		v7.navigateBack(false)
	end, { v9.fireEvent, v7.isZooming, v7.navigateBack })

	local v18 = React.useCallback(function()
		v9.fireEvent(module10.ContentFeedCloseShortcutPressed, { postId = props.postId })

		v7.navigateBack(false)
	end, { v9.fireEvent, v7.navigateBack })

	React.useEffect(function()
		ContextActionService:BindCoreAction("ContentFeedCloseShortcutAction", function(p2, p3)
			if p3 == Enum.UserInputState.End then
				v18()
			end
		end, false, Enum.KeyCode.Escape)

		return function()
			ContextActionService:UnbindCoreAction("ContentFeedCloseShortcutAction")
		end
	end, { v18 })

	local v19 = React.useCallback(function()
		if v7.isZooming then
			return
		end

		v9.fireEvent(module10.ContentFeedMoreMenuButtonPressed, {
			postId = props.postId
		})

		setState(not state)
	end, { v9.fireEvent, v7.isZooming, state, props.postId })

	local v20 = React.useCallback(function()
		v9.fireEvent(module10.ContentFeedReportCtaPressed, { postId = props.postId })

		v7.navigateToReportPage(props.postId)
		setState(false)
	end, { v9.fireEvent, v7.navigateToReportPage, props.postId })

	local v21 = React.useCallback(function()
		v9.fireEvent(module10.ContentFeedDeleteCtaPressed, { postId = props.postId })

		v10(module12(props.postId))
		props.removePostTransition()
		setState(false)
	end, { v9.fireEvent, props.postId, props.removePostTransition })

	local v22 = {}

	if props.creatorId ~= v6 then
		table.insert(v22, {
			icon = images["icons/actions/feedback"],
			onActivated = v20,
			text = v8.report
		})
	end

	if props.creatorId == v6 then
		table.insert(v22, {
			icon = images["icons/actions/edit/delete"],
			onActivated = v21,
			text = v8.removePost
		})
	end

	local createElement = React.createElement
	local v25

	if v7.isZooming then
		v25 = v14:map(function(p2)
			return p2
		end)
	end

	return createElement(view, {
		GroupTransparency = v25,
		Position = UDim2.fromOffset(0, v13.top),
		Size = UDim2.new(1, 0, 0, 56),
		tag = "bg-action-subtle",
		ZIndex = props.ZIndex
	}, {
		GradientBackdrop = React.createElement(view, {
			Position = UDim2.fromOffset(0, -v13.top),
			Size = UDim2.new(1, 0, 1, v13.top),
			tag = "col size-full-full bg-contrast",
			ZIndex = 0
		}, {
			UIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v11.Color.OverMedia.OverMedia_0.Color3),
					ColorSequenceKeypoint.new(1, v11.Color.OverMedia.OverMedia_0.Color3)
				}),
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.5),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ContextualMenu = React.createElement(contextualMenu, {
			buttonProps = v22,
			closeBackgroundVisible = false,
			horizontalAlignment = Enum.HorizontalAlignment.Right,
			menuDirection = menuDirection.Down,
			motorOverrideOptions = v5,
			onDismiss = v16,
			open = state,
			openPositionX = UDim.new(0, -12),
			openPositionY = UDim.new(0, 56),
			screenSize = v12,
			zIndex = 2
		}),
		FeedHeader = React.createElement(module9, {
			isContextualMenuOpen = state,
			isPlaceholderPost = props.isPlaceholderPost,
			onBackActivated = v17,
			onMoreActivated = v19,
			ZIndex = 1
		})
	})
end
