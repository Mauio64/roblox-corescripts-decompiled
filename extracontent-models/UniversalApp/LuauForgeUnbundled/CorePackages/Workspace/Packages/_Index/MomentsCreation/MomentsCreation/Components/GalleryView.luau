local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local chip = Foundation.Chip
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local view = Foundation.View

local image = BuilderIcons.Icon.Image
local videoCamera = BuilderIcons.Icon.VideoCamera

local CaptureItem = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CaptureItem")
local scrollingGridView = MomentsCommon.ScrollingGridView

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames

return function(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)

	local v8 = React.useMemo(function()
		if state then
			return Cryo.List.filter(props.captures, function(p2): boolean
				return p2.CaptureType == state
			end)
		end

		return props.captures
	end, { props.captures, state })

	React.useEffect(function()
		if #props.captures == 0 and ref.current == false then
			ref.current = true

			local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				eventNames.EditingFlowGalleryNoCapturesAvailable,
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)
		end
	end, { props.captures })

	local v9 = useCallback(function(p2)
		props.onCaptureSelected(p2)
	end, { props.onCaptureSelected })

	local v10 = useCallback(function(p2, p3)
		return React.createElement(CaptureItem, {
			capture = p2,
			onActivated = v9,
			selected = props.selectedCapture == p2,
			zIndex = 1
		})
	end, { props.selectedCapture, v9 })

	local v11 = useCallback(function()
		return React.createElement(view, { tag = "shrink size-full-full" }, {
			EmptyState = React.createElement(text, {
				tag = "position-top-center anchor-top-center auto-xy padding-large text-body-medium text-align-x-center text-align-y-center content-action-emphasis",
				Text = v7.GeneralEmptyStateText
			})
		})
	end, { v7 })

	local v12 = useCallback(function()
		setState(nil)
	end, {})

	local v13 = useCallback(function()
		setState(Enum.CaptureType.Screenshot)
	end, {})

	local v14 = useCallback(function()
		setState(Enum.CaptureType.Video)
	end, {})

	local v15 = useCallback(function()
		if props.onShowMore then
			props.onShowMore()
		end
	end, { props.onShowMore })

	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		padding = {
			top = UDim.new(0, v6.Padding.Large),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Large)))
		},
		tag = "col align-x-center align-y-bottom shrink gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y"
	}, {
		FilterButtons = React.createElement(view, {
			LayoutOrder = 1,
			padding = {
				left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
				right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
			},
			tag = "row gap-small position-top-center anchor-top-center size-full-0 auto-y"
		}, {
			AllChip = React.createElement(chip, {
				isChecked = state == nil,
				LayoutOrder = 1,
				onActivated = v12,
				size = Foundation.Enums.ChipSize.Small,
				text = v7.GeneralAllChipLabel
			}),
			PhotosChip = React.createElement(chip, {
				isChecked = state == Enum.CaptureType.Screenshot,
				LayoutOrder = 2,
				leading = image,
				onActivated = v13,
				size = Foundation.Enums.ChipSize.Small,
				text = v7.GeneralPhotosChipLabel
			}),
			VideosChip = React.createElement(chip, {
				isChecked = state == Enum.CaptureType.Video,
				LayoutOrder = 3,
				leading = videoCamera,
				onActivated = v14,
				size = Foundation.Enums.ChipSize.Small,
				text = v7.GeneralVideosChipLabel
			})
		}),
		CaptureGrid = React.createElement(view, {
			LayoutOrder = 2,
			padding = { left = UDim.new(0, v5.left), right = UDim.new(0, v5.right) },
			tag = "row shrink gap-small position-top-center anchor-top-center size-full-full"
		}, {
			CaptureGrid = React.createElement(scrollingGridView, {
				aspectRatio = 1,
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 5,
					minItemsPerPage = 6,
					minItemWidth = 100
				},
				items = v8,
				layoutOrder = 1,
				onShowMoreCallback = v15,
				padding = { bottom = UDim.new(0, v6.Padding.Large) },
				renderEmptyState = v11,
				renderItem = v10,
				shouldShowShowMoreButton = props.hasMoreCaptures == true,
				showMoreButtonText = v7.GeneralCtaShowMore
			})
		}),
		ButtonContainer = React.createElement(view, {
			LayoutOrder = 3,
			padding = {
				left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
				right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
			},
			tag = "align-x-center size-full-0 auto-y"
		}, {
			ButtonConstraint = React.createElement(view, {
				sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
				tag = "size-full-0 auto-y"
			}, {
				NextButton = React.createElement(button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					isDisabled = not props.selectedCapture,
					LayoutOrder = 1,
					onActivated = props.onNextCallback,
					size = inputSize.Medium,
					text = v7.PublishingCtaContinue,
					variant = buttonVariant.Emphasis
				})
			})
		})
	})
end
