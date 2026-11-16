local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Chip = Foundation.Chip
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local Image = BuilderIcons.Icon.Image
local VideoCamera = BuilderIcons.Icon.VideoCamera

local CaptureItem = require(MomentsCreation.Components.CaptureItem)
local ScrollingGridView = MomentsCommon.ScrollingGridView

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local Constants = require(MomentsCreation.Constants)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)

	local items = React.useMemo(function()
		if state then
			return Cryo.List.filter(props.captures, function(p): boolean
				return p.CaptureType == state
			end)
		end

		return props.captures
	end, { props.captures, state })

	React.useEffect(function()
		if #props.captures == 0 and ref.current == false then
			ref.current = true

			local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				EventNames.EditingFlowGalleryNoCapturesAvailable,
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)
		end
	end, { props.captures })

	local onActivated = useCallback(function(p)
		props.onCaptureSelected(p)
	end, { props.onCaptureSelected })

	local renderItem = useCallback(function(capture, _: number)
		return React.createElement(CaptureItem, {
			capture = capture,
			onActivated = onActivated,
			selected = props.selectedCapture == capture,
			zIndex = 1
		})
	end, { props.selectedCapture, onActivated })

	local renderEmptyState = useCallback(function()
		return React.createElement(View, { tag = "shrink size-full-full" }, {
			EmptyState = React.createElement(Text, {
				tag = "position-top-center anchor-top-center auto-xy padding-large text-body-medium text-align-x-center text-align-y-center content-action-emphasis",
				Text = v3.GeneralEmptyStateText
			})
		})
	end, { v3 })

	local onActivated2 = useCallback(function()
		setState(nil)
	end, {})

	local onActivated3 = useCallback(function()
		setState(Enum.CaptureType.Screenshot)
	end, {})

	local onActivated4 = useCallback(function()
		setState(Enum.CaptureType.Video)
	end, {})

	local onShowMoreCallback = useCallback(function()
		if props.onShowMore then
			props.onShowMore()
		end
	end, { props.onShowMore })

	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		padding = {
			top = UDim.new(0, v2.Padding.Large),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Large)))
		},
		tag = "col align-x-center align-y-bottom shrink gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y"
	}, {
		FilterButtons = React.createElement(View, {
			LayoutOrder = 1,
			padding = {
				left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
				right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
			},
			tag = "row gap-small position-top-center anchor-top-center size-full-0 auto-y"
		}, {
			AllChip = React.createElement(Chip, {
				isChecked = state == nil,
				LayoutOrder = 1,
				onActivated = onActivated2,
				size = Foundation.Enums.ChipSize.Small,
				text = v3.GeneralAllChipLabel
			}),
			PhotosChip = React.createElement(Chip, {
				isChecked = state == Enum.CaptureType.Screenshot,
				LayoutOrder = 2,
				leading = Image,
				onActivated = onActivated3,
				size = Foundation.Enums.ChipSize.Small,
				text = v3.GeneralPhotosChipLabel
			}),
			VideosChip = React.createElement(Chip, {
				isChecked = state == Enum.CaptureType.Video,
				LayoutOrder = 3,
				leading = VideoCamera,
				onActivated = onActivated4,
				size = Foundation.Enums.ChipSize.Small,
				text = v3.GeneralVideosChipLabel
			})
		}),
		CaptureGrid = React.createElement(View, {
			LayoutOrder = 2,
			padding = { left = UDim.new(0, v.left), right = UDim.new(0, v.right) },
			tag = "row shrink gap-small position-top-center anchor-top-center size-full-full"
		}, {
			CaptureGrid = React.createElement(ScrollingGridView, {
				aspectRatio = 1,
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 5,
					minItemsPerPage = 6,
					minItemWidth = 100
				},
				items = items,
				layoutOrder = 1,
				onShowMoreCallback = onShowMoreCallback,
				padding = { bottom = UDim.new(0, v2.Padding.Large) },
				renderEmptyState = renderEmptyState,
				renderItem = renderItem,
				shouldShowShowMoreButton = props.hasMoreCaptures == true,
				showMoreButtonText = v3.GeneralCtaShowMore
			})
		}),
		ButtonContainer = React.createElement(View, {
			LayoutOrder = 3,
			padding = {
				left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
				right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
			},
			tag = "align-x-center size-full-0 auto-y"
		}, {
			ButtonConstraint = React.createElement(View, {
				sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
				tag = "size-full-0 auto-y"
			}, {
				NextButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					isDisabled = not props.selectedCapture,
					LayoutOrder = 1,
					onActivated = props.onNextCallback,
					size = InputSize.Medium,
					text = v3.PublishingCtaContinue,
					variant = ButtonVariant.Emphasis
				})
			})
		})
	})
end
