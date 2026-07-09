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
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local EventNames = MomentsCommon.Analytics.EventNames

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), React (copy), Cryo (copy), fireAnalyticsEvent (copy), EventNames (copy), useCallback (copy), CaptureItem (copy), View (copy), FoundationText (copy), Chip (copy), Foundation (copy), IconImage (copy), VideoCamera (copy), ScrollingGridView (copy), Constants (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v26 = useDeviceInsets()
	local v27 = useTokens()
	local v28 = useCreationFlowStrings()
	local v29, v30 = React.useState(nil)
	local v31 = React.useRef(false)
	local v32 = React.useMemo(function() -- line: 70
		-- upvalues: v29 (copy), t1 (copy), Cryo (copy)
		if not v29 then
			return t1.captures
		end

		return Cryo.List.filter(t1.captures, function(p1) -- line: 75
			-- upvalues: v29 (copy)
			return p1.CaptureType == v29
		end)
	end, {
		t1.captures,
		v29
	})

	React.useEffect(function() -- line: 80
		-- upvalues: t1 (copy), v31 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if #t1.captures == 0 and v31.current == false then
			v31.current = true
			fireAnalyticsEvent(EventNames.EditingFlowGalleryNoCapturesAvailable)
		end
	end, { t1.captures })

	local v33 = useCallback(function(p2) -- line: 87
		-- upvalues: t1 (copy)
		t1.onCaptureSelected(p2)
	end, { t1.onCaptureSelected })
	local v34 = useCallback(function(p3, _: number) -- line: 91
		-- upvalues: React (copy), CaptureItem (copy), v33 (copy), t1 (copy)
		return React.createElement(CaptureItem, {
			zIndex = 1,
			capture = p3,
			onActivated = v33,
			selected = p3 == t1.selectedCapture
		})
	end, {
		t1.selectedCapture,
		v33
	})
	local v35 = useCallback(function() -- line: 100
		-- upvalues: React (copy), View (copy), FoundationText (copy), v28 (copy)
		return React.createElement(View, {
			tag = "shrink size-full-full"
		}, {
			EmptyState = React.createElement(FoundationText, {
				tag = "position-top-center anchor-top-center auto-xy padding-large text-body-medium text-align-x-center text-align-y-center content-action-emphasis",
				Text = v28.GeneralEmptyStateText
			})
		})
	end, { v28 })
	local v36 = useCallback(function() -- line: 111
		-- upvalues: v30 (copy)
		v30(nil)
	end, {})
	local v37 = useCallback(function() -- line: 115
		-- upvalues: v30 (copy)
		v30(Enum.CaptureType.Screenshot)
	end, {})
	local v38 = useCallback(function() -- line: 119
		-- upvalues: v30 (copy)
		v30(Enum.CaptureType.Video)
	end, {})
	local v39 = useCallback(function() -- line: 123
		-- upvalues: t1 (copy)
		if t1.onShowMore then
			t1.onShowMore()
		end
	end, { t1.onShowMore })

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom shrink gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v27.Padding.Large),
			bottom = UDim.new(0, (math.max(v26.bottom, v27.Padding.Large)))
		}
	}, {
		FilterButtons = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small position-top-center anchor-top-center size-full-0 auto-y",
			padding = {
				left = UDim.new(0, (math.max(v26.left, v27.Padding.XLarge))),
				right = UDim.new(0, (math.max(v26.right, v27.Padding.XLarge)))
			}
		}, {
			AllChip = React.createElement(Chip, {
				LayoutOrder = 1,
				isChecked = v29 == nil,
				onActivated = v36,
				size = Foundation.Enums.ChipSize.Small,
				text = v28.GeneralAllChipLabel
			}),
			PhotosChip = React.createElement(Chip, {
				LayoutOrder = 2,
				isChecked = v29 == Enum.CaptureType.Screenshot,
				leading = IconImage,
				onActivated = v37,
				size = Foundation.Enums.ChipSize.Small,
				text = v28.GeneralPhotosChipLabel
			}),
			VideosChip = React.createElement(Chip, {
				LayoutOrder = 3,
				isChecked = v29 == Enum.CaptureType.Video,
				leading = VideoCamera,
				onActivated = v38,
				size = Foundation.Enums.ChipSize.Small,
				text = v28.GeneralVideosChipLabel
			})
		}),
		CaptureGrid = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row shrink gap-small position-top-center anchor-top-center size-full-full",
			padding = {
				left = UDim.new(0, v26.left),
				right = UDim.new(0, v26.right)
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
				items = v32,
				onShowMoreCallback = v39,
				padding = {
					bottom = UDim.new(0, v27.Padding.Large)
				},
				renderEmptyState = v35,
				renderItem = v34,
				shouldShowShowMoreButton = t1.hasMoreCaptures == true,
				showMoreButtonText = v28.GeneralCtaShowMore
			})
		}),
		ButtonContainer = React.createElement(View, {
			LayoutOrder = 3,
			tag = "align-x-center size-full-0 auto-y",
			padding = {
				left = UDim.new(0, (math.max(v26.left, v27.Padding.XLarge))),
				right = UDim.new(0, (math.max(v26.right, v27.Padding.XLarge)))
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
					text = v28.PublishingCtaContinue,
					variant = ButtonVariant.Emphasis
				})
			})
		})
	})
end
