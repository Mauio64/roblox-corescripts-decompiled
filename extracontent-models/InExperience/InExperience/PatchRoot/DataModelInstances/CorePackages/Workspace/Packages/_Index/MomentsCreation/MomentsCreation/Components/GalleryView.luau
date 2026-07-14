local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Cryo = require(MomentsCreationParent.Cryo)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Chip = Foundation.Chip
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local IconImage = BuilderIcons.Icon.Image
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

return function(t1: {[any]: any}) -- line: 66
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), React (copy), Cryo (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy), useCallback (copy), CaptureItem (copy), View (copy), FoundationText (copy), Chip (copy), Foundation (copy), IconImage (copy), VideoCamera (copy), ScrollingGridView (copy), Constants (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v29 = useDeviceInsets()
	local v30 = useTokens()
	local v31 = useCreationFlowStrings()
	local v32, v33 = React.useState(nil)
	local v34 = React.useRef(false)
	local v35 = React.useMemo(function() -- line: 73
		-- upvalues: v32 (copy), t1 (copy), Cryo (copy)
		if not v32 then
			return t1.captures
		end

		return Cryo.List.filter(t1.captures, function(p1) -- line: 78
			-- upvalues: v32 (copy)
			return p1.CaptureType == v32
		end)
	end, {
		t1.captures,
		v32
	})

	React.useEffect(function() -- line: 83
		-- upvalues: t1 (copy), v34 (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy)
		if #t1.captures == 0 and v34.current == false then
			v34.current = true

			local v43 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

			fireAnalyticsEvent(EventNames.EditingFlowGalleryNoCapturesAvailable, makeCreationEventFields.makeCreationBaseFields(v43))
		end
	end, { t1.captures })

	local v36 = useCallback(function(p2) -- line: 97
		-- upvalues: t1 (copy)
		t1.onCaptureSelected(p2)
	end, { t1.onCaptureSelected })
	local v37 = useCallback(function(p3, _: number) -- line: 101
		-- upvalues: React (copy), CaptureItem (copy), v36 (copy), t1 (copy)
		return React.createElement(CaptureItem, {
			zIndex = 1,
			capture = p3,
			onActivated = v36,
			selected = p3 == t1.selectedCapture
		})
	end, {
		t1.selectedCapture,
		v36
	})
	local v38 = useCallback(function() -- line: 110
		-- upvalues: React (copy), View (copy), FoundationText (copy), v31 (copy)
		return React.createElement(View, {
			tag = "shrink size-full-full"
		}, {
			EmptyState = React.createElement(FoundationText, {
				tag = "position-top-center anchor-top-center auto-xy padding-large text-body-medium text-align-x-center text-align-y-center content-action-emphasis",
				Text = v31.GeneralEmptyStateText
			})
		})
	end, { v31 })
	local v39 = useCallback(function() -- line: 121
		-- upvalues: v33 (copy)
		v33(nil)
	end, {})
	local v40 = useCallback(function() -- line: 125
		-- upvalues: v33 (copy)
		v33(Enum.CaptureType.Screenshot)
	end, {})
	local v41 = useCallback(function() -- line: 129
		-- upvalues: v33 (copy)
		v33(Enum.CaptureType.Video)
	end, {})
	local v42 = useCallback(function() -- line: 133
		-- upvalues: t1 (copy)
		if t1.onShowMore then
			t1.onShowMore()
		end
	end, { t1.onShowMore })

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom shrink gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v30.Padding.Large),
			bottom = UDim.new(0, (math.max(v29.bottom, v30.Padding.Large)))
		}
	}, {
		FilterButtons = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small position-top-center anchor-top-center size-full-0 auto-y",
			padding = {
				left = UDim.new(0, (math.max(v29.left, v30.Padding.XLarge))),
				right = UDim.new(0, (math.max(v29.right, v30.Padding.XLarge)))
			}
		}, {
			AllChip = React.createElement(Chip, {
				LayoutOrder = 1,
				isChecked = v32 == nil,
				onActivated = v39,
				size = Foundation.Enums.ChipSize.Small,
				text = v31.GeneralAllChipLabel
			}),
			PhotosChip = React.createElement(Chip, {
				LayoutOrder = 2,
				isChecked = v32 == Enum.CaptureType.Screenshot,
				leading = IconImage,
				onActivated = v40,
				size = Foundation.Enums.ChipSize.Small,
				text = v31.GeneralPhotosChipLabel
			}),
			VideosChip = React.createElement(Chip, {
				LayoutOrder = 3,
				isChecked = v32 == Enum.CaptureType.Video,
				leading = VideoCamera,
				onActivated = v41,
				size = Foundation.Enums.ChipSize.Small,
				text = v31.GeneralVideosChipLabel
			})
		}),
		CaptureGrid = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row shrink gap-small position-top-center anchor-top-center size-full-full",
			padding = {
				left = UDim.new(0, v29.left),
				right = UDim.new(0, v29.right)
			}
		}, {
			CaptureGrid = React.createElement(ScrollingGridView, {
				aspectRatio = 1,
				layoutOrder = 1,
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 5,
					minItemsPerPage = 6,
					minItemWidth = 100
				},
				items = v35,
				onShowMoreCallback = v42,
				padding = {
					bottom = UDim.new(0, v30.Padding.Large)
				},
				renderEmptyState = v38,
				renderItem = v37,
				shouldShowShowMoreButton = t1.hasMoreCaptures == true,
				showMoreButtonText = v31.GeneralCtaShowMore
			})
		}),
		ButtonContainer = React.createElement(View, {
			LayoutOrder = 3,
			tag = "align-x-center size-full-0 auto-y",
			padding = {
				left = UDim.new(0, (math.max(v29.left, v30.Padding.XLarge))),
				right = UDim.new(0, (math.max(v29.right, v30.Padding.XLarge)))
			}
		}, {
			ButtonConstraint = React.createElement(View, {
				tag = "size-full-0 auto-y",
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
					text = v31.PublishingCtaContinue,
					variant = ButtonVariant.Emphasis
				})
			})
		})
	})
end
