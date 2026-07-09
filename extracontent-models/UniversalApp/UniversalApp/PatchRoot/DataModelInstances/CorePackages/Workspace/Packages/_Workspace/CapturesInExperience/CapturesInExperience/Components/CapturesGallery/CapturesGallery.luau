local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local UIBlox = require(ParentParentParent.UIBlox)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local useSystemMenuDetection = require(ParentParent.Hooks.useSystemMenuDetection)
local CaptureGridView = CapturesCommon.Components.CaptureGridView
local CaptureItem = CapturesCommon.Components.CaptureItem
local CarouselOpened = require(ParentParent.Actions.CarouselOpened)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local GalleryActionContainer = require(ParentParent.Components.CapturesGallery.GalleryActionContainer)
local GalleryGridView = require(ParentParent.Components.CapturesGallery.GalleryGridView)
local FFlagUseCaptureCommonComponents = require(ParentParent.Flags.FFlagUseCaptureCommonComponents)
local FFlagCapturesGalleryDespawnOnMenuClose = require(ParentParent.Flags.FFlagCapturesGalleryDespawnOnMenuClose)

return function(t1: {[any]: any}) -- line: 38
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), useSystemMenuDetection (copy), useSelector (copy), Constants (copy), useLocalization (copy), React (copy), EventNames (copy), CarouselOpened (copy), FFlagCapturesGalleryDespawnOnMenuClose (copy), FFlagUseCaptureCommonComponents (copy), CaptureGridView (copy), GalleryActionContainer (copy), CaptureItem (copy), GalleryGridView (copy)
	local v24 = useAnalytics()
	local v25 = useDispatch()
	local v26 = useStyle()
	local v27 = useSystemMenuDetection()
	local v28 = useSelector(function(p1) -- line: 44
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].Captures
	end)
	local v29 = next(v28) == nil
	local v30 = useLocalization({
		nothingHereYet = "Feature.Captures.Label.NothingHereYet",
		title = "Feature.Captures.Title.Gallery"
	})
	local v31 = React.useCallback(function(p2) -- line: 55
		-- upvalues: v24 (copy), EventNames (copy), v25 (copy), CarouselOpened (copy)
		return function() -- line: 56
			-- upvalues: v24 (copy), EventNames (copy), v25 (copy), CarouselOpened (copy), p2 (copy)
			v24.fireEvent(EventNames.CapturesCarouselOpened)
			v25(CarouselOpened(p2))
		end
	end, {})
	local v32 = t1.Size or UDim2.fromScale(1, 1)
	local BackgroundDefaultColor = v26.Theme.BackgroundDefault.Color
	local BackgroundDefaultTransparency = v26.Theme.BackgroundDefault.Transparency
	local TextMutedColor = v26.Theme.TextMuted.Color
	local CaptionBodyFont = v26.Font.CaptionBody.Font
	local v37 = v26.Font.BaseSize * v26.Font.CaptionBody.RelativeSize
	local TextMutedTransparency = v26.Theme.TextMuted.Transparency
	local v39 = if not FFlagCapturesGalleryDespawnOnMenuClose then not v29 else v27 and not v29

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = BackgroundDefaultColor,
		BackgroundTransparency = BackgroundDefaultTransparency,
		LayoutOrder = t1.LayoutOrder,
		Size = v32
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		NothingHereYet = v29 and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			Font = CaptionBodyFont,
			Size = UDim2.new(1, -12, 1, 12),
			Text = v30.nothingHereYet,
			TextColor3 = TextMutedColor,
			TextSize = v37,
			TextTransparency = TextMutedTransparency,
			TextXAlignment = Enum.TextXAlignment.Center
		}, {
			MaxSize = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(312, 1e999)
			})
		}),
		GalleryGridView = if not v39 then nil else if not FFlagUseCaptureCommonComponents then React.createElement(GalleryGridView, {
			captures = v28,
			Size = UDim2.new(1, -12, 1, -12)
		}) else React.createElement(CaptureGridView, {
			shouldShowShowMoreButton = true,
			captures = v28,
			header = React.createElement(GalleryActionContainer, {
				isDisabled = false,
				LayoutOrder = 1,
				itemCount = #v28
			}),
			renderItem = function(p3, p4) -- line: 119
				-- upvalues: React (copy), CaptureItem (copy), v31 (copy)
				return React.createElement(CaptureItem, {
					capture = p3,
					onActivated = v31(p4)
				})
			end
		})
	})
end
