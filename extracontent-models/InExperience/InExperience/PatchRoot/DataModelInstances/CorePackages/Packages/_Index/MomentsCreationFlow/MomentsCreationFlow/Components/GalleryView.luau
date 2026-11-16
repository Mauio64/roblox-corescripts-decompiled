local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

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

local CaptureItem = require(MomentsCreationFlow.Components.CaptureItem)
local ScrollingGridView = MomentsCommon.ScrollingGridView

local useCallback = React.useCallback
local useContext = React.useContext
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local EventNames = require(MomentsCreationFlow.Analytics.EventNames)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useContext(CreationFlowContext)
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
			v3.fireEvent(EventNames.EditingFlowGalleryNoCapturesAvailable)
		end
	end, { props.captures })

	local renderItem = useCallback(function(capture, _: number)
		return React.createElement(CaptureItem, {
			capture = capture,
			onActivated = props.onCaptureSelected,
			selected = props.selectedCapture == capture,
			zIndex = 1
		})
	end, { props.selectedCapture, props.onCaptureSelected })

	local renderEmptyState = useCallback(function()
		return React.createElement(View, { tag = "shrink size-full-full" }, {
			EmptyState = React.createElement(Text, {
				tag = "anchor-top-center auto-xy content-action-emphasis padding-large position-top-center text-align-x-center text-align-y-center text-body-medium",
				Text = v3.getLocalization(CreationFlowLocalization.GeneralEmptyStateText)
			})
		})
	end, { v3 })

	local onActivated = useCallback(function()
		setState(nil)
	end, {})

	local onActivated2 = useCallback(function()
		setState(Enum.CaptureType.Screenshot)
	end, {})

	local onActivated3 = useCallback(function()
		setState(Enum.CaptureType.Video)
	end, {})

	local onShowMoreCallback = useCallback(function()
		v3.fetchAdditionalCaptures()
	end, { v3 })

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "align-x-center auto-y align-y-bottom anchor-bottom-center gap-large position-bottom-center col shrink size-full-0"
		},
		{
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v2.Padding.Large),
				PaddingBottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Large)))
			}),
			FilterButtons = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "auto-y anchor-top-center gap-small position-top-center row size-full-0"
				},
				{
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
						PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
					}),
					AllChip = React.createElement(Chip, {
						isChecked = state == nil,
						LayoutOrder = 1,
						onActivated = onActivated,
						size = Foundation.Enums.ChipSize.Small,
						text = v3.getLocalization(CreationFlowLocalization.GeneralAllChipLabel)
					}),
					PhotosChip = React.createElement(Chip, {
						isChecked = state == Enum.CaptureType.Screenshot,
						LayoutOrder = 2,
						leading = Image,
						onActivated = onActivated2,
						size = Foundation.Enums.ChipSize.Small,
						text = v3.getLocalization(CreationFlowLocalization.GeneralPhotosChipLabel)
					}),
					VideosChip = React.createElement(Chip, {
						isChecked = state == Enum.CaptureType.Video,
						LayoutOrder = 3,
						leading = VideoCamera,
						onActivated = onActivated3,
						size = Foundation.Enums.ChipSize.Small,
						text = v3.getLocalization(CreationFlowLocalization.GeneralVideosChipLabel)
					})
				}
			),
			CaptureGrid = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "anchor-top-center gap-small position-top-center row shrink size-full-full"
				},
				{
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v.left),
						PaddingRight = UDim.new(0, v.right)
					}),
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
						shouldShowShowMoreButton = not v3.capturesPagesIsFinished(),
						showMoreButtonText = v3.getLocalization(CreationFlowLocalization.GeneralCtaShowMore)
					})
				}
			),
			ButtonContainer = React.createElement(
				View,
				{ LayoutOrder = 3, tag = "align-x-center auto-y size-full-0" },
				{
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
						PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
					}),
					ButtonConstraint = React.createElement(View, {
						sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
						tag = "auto-y size-full-0"
					}, {
						NextButton = React.createElement(Button, {
							fillBehavior = Foundation.Enums.FillBehavior.Fill,
							isDisabled = not props.selectedCapture,
							LayoutOrder = 1,
							onActivated = props.onNextCallback,
							size = InputSize.Medium,
							text = v3.getLocalization(CreationFlowLocalization.PublishingCtaContinue),
							variant = ButtonVariant.Emphasis
						})
					})
				}
			)
		}
	)
end
