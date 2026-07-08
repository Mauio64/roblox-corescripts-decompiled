local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Cryo = require(MomentsCreationFlowParent.Cryo)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Chip = Foundation.Chip
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local IconImage = BuilderIcons.Icon.Image
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

return function(t1: {[any]: any}) -- line: 50
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useContext (copy), CreationFlowContext (copy), React (copy), Cryo (copy), EventNames (copy), useCallback (copy), CaptureItem (copy), View (copy), FoundationText (copy), CreationFlowLocalization (copy), Chip (copy), Foundation (copy), IconImage (copy), VideoCamera (copy), ScrollingGridView (copy), Constants (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v27 = useDeviceInsets()
	local v28 = useTokens()
	local v29 = useContext(CreationFlowContext)
	local v30, v31 = React.useState(nil)
	local v32 = React.useRef(false)
	local v33 = React.useMemo(function() -- line: 57
		-- upvalues: v30 (copy), t1 (copy), Cryo (copy)
		if not v30 then
			return t1.captures
		end

		return Cryo.List.filter(t1.captures, function(p1) -- line: 62
			-- upvalues: v30 (copy)
			return p1.CaptureType == v30
		end)
	end, {
		t1.captures,
		v30
	})

	React.useEffect(function() -- line: 67
		-- upvalues: t1 (copy), v32 (copy), v29 (copy), EventNames (copy)
		if #t1.captures == 0 and v32.current == false then
			v32.current = true
			v29.fireEvent(EventNames.EditingFlowGalleryNoCapturesAvailable)
		end
	end, { t1.captures })

	local v34 = useCallback(function(p2, _: number) -- line: 74
		-- upvalues: React (copy), CaptureItem (copy), t1 (copy)
		return React.createElement(CaptureItem, {
			zIndex = 1,
			capture = p2,
			onActivated = t1.onCaptureSelected,
			selected = p2 == t1.selectedCapture
		})
	end, {
		t1.selectedCapture,
		t1.onCaptureSelected
	})
	local v35 = useCallback(function() -- line: 83
		-- upvalues: React (copy), View (copy), FoundationText (copy), v29 (copy), CreationFlowLocalization (copy)
		return React.createElement(View, {
			tag = "shrink size-full-full"
		}, {
			EmptyState = React.createElement(FoundationText, {
				tag = "anchor-top-center auto-xy content-action-emphasis padding-large position-top-center text-align-x-center text-align-y-center text-body-medium",
				Text = v29.getLocalization(CreationFlowLocalization.GeneralEmptyStateText)
			})
		})
	end, { v29 })
	local v36 = useCallback(function() -- line: 94
		-- upvalues: v31 (copy)
		v31(nil)
	end, {})
	local v37 = useCallback(function() -- line: 98
		-- upvalues: v31 (copy)
		v31(Enum.CaptureType.Screenshot)
	end, {})
	local v38 = useCallback(function() -- line: 102
		-- upvalues: v31 (copy)
		v31(Enum.CaptureType.Video)
	end, {})
	local v39 = useCallback(function() -- line: 106
		-- upvalues: v29 (copy)
		v29.fetchAdditionalCaptures()
	end, { v29 })

	return React.createElement(View, {
		tag = "align-x-center auto-y align-y-bottom anchor-bottom-center gap-large position-bottom-center col shrink size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v28.Padding.Large),
			PaddingBottom = UDim.new(0, (math.max(v27.bottom, v28.Padding.Large)))
		}),
		FilterButtons = React.createElement(View, {
			LayoutOrder = 1,
			tag = "auto-y anchor-top-center gap-small position-top-center row size-full-0"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, (math.max(v27.left, v28.Padding.XLarge))),
				PaddingRight = UDim.new(0, (math.max(v27.right, v28.Padding.XLarge)))
			}),
			AllChip = React.createElement(Chip, {
				LayoutOrder = 1,
				isChecked = v30 == nil,
				onActivated = v36,
				size = Foundation.Enums.ChipSize.Small,
				text = v29.getLocalization(CreationFlowLocalization.GeneralAllChipLabel)
			}),
			PhotosChip = React.createElement(Chip, {
				LayoutOrder = 2,
				isChecked = v30 == Enum.CaptureType.Screenshot,
				leading = IconImage,
				onActivated = v37,
				size = Foundation.Enums.ChipSize.Small,
				text = v29.getLocalization(CreationFlowLocalization.GeneralPhotosChipLabel)
			}),
			VideosChip = React.createElement(Chip, {
				LayoutOrder = 3,
				isChecked = v30 == Enum.CaptureType.Video,
				leading = VideoCamera,
				onActivated = v38,
				size = Foundation.Enums.ChipSize.Small,
				text = v29.getLocalization(CreationFlowLocalization.GeneralVideosChipLabel)
			})
		}),
		CaptureGrid = React.createElement(View, {
			LayoutOrder = 2,
			tag = "anchor-top-center gap-small position-top-center row shrink size-full-full"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v27.left),
				PaddingRight = UDim.new(0, v27.right)
			}),
			CaptureGrid = React.createElement(ScrollingGridView, {
				aspectRatio = 1,
				layoutOrder = 1,
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 5,
					minItemsPerPage = 6,
					minItemWidth = 100
				},
				items = v33,
				onShowMoreCallback = v39,
				padding = {
					bottom = UDim.new(0, v28.Padding.Large)
				},
				renderEmptyState = v35,
				renderItem = v34,
				shouldShowShowMoreButton = not v29.capturesPagesIsFinished(),
				showMoreButtonText = v29.getLocalization(CreationFlowLocalization.GeneralCtaShowMore)
			})
		}),
		ButtonContainer = React.createElement(View, {
			LayoutOrder = 3,
			tag = "align-x-center auto-y size-full-0"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, (math.max(v27.left, v28.Padding.XLarge))),
				PaddingRight = UDim.new(0, (math.max(v27.right, v28.Padding.XLarge)))
			}),
			ButtonConstraint = React.createElement(View, {
				tag = "auto-y size-full-0",
				sizeConstraint = {
					MaxSize = Constants.BottomBarSizeConstraint
				}
			}, {
				NextButton = React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					isDisabled = not t1.selectedCapture,
					onActivated = t1.onNextCallback,
					size = InputSize.Medium,
					text = v29.getLocalization(CreationFlowLocalization.PublishingCtaContinue),
					variant = ButtonVariant.Emphasis
				})
			})
		})
	})
end
