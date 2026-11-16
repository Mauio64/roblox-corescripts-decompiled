local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local useSystemMenuDetection = require(parent.Hooks.useSystemMenuDetection)

local CaptureGridView = CapturesCommon.Components.CaptureGridView
local CaptureItem = CapturesCommon.Components.CaptureItem
local CarouselOpened = require(parent.Actions.CarouselOpened)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local GalleryActionContainer = require(parent.Components.CapturesGallery.GalleryActionContainer)
local GalleryGridView = require(parent.Components.CapturesGallery.GalleryGridView)

local FFlagUseCaptureCommonComponents = require(parent.Flags.FFlagUseCaptureCommonComponents)

local FFlagCapturesGalleryDespawnOnMenuClose = require(parent.Flags.FFlagCapturesGalleryDespawnOnMenuClose)

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()
	local v4 = useSystemMenuDetection()

	local captures = useSelector(function(p2)
		return p2[Constants.RoduxKey].Captures
	end)

	local nothingHereYet = next(captures) == nil

	local v5 = useLocalization({
		nothingHereYet = "Feature.Captures.Label.NothingHereYet",
		title = "Feature.Captures.Title.Gallery"
	})

	local v6 = React.useCallback(function(p2)
		return function()
			v.fireEvent(EventNames.CapturesCarouselOpened)
			v2(CarouselOpened(p2))
		end
	end, {})

	local size = p.Size or UDim2.fromScale(1, 1)

	local color = v3.Theme.BackgroundDefault.Color
	local transparency = v3.Theme.BackgroundDefault.Transparency

	local color2 = v3.Theme.TextMuted.Color
	local font = v3.Font.CaptionBody.Font
	local textSize = v3.Font.BaseSize * v3.Font.CaptionBody.RelativeSize
	local transparency2 = v3.Theme.TextMuted.Transparency
	local v7

	if FFlagCapturesGalleryDespawnOnMenuClose then
		v7 = v4 and not nothingHereYet
	else
		v7 = not nothingHereYet
	end

	local createElement = React.createElement
	local v8 = {
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		LayoutOrder = p.LayoutOrder,
		Size = size
	}

	local v9 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		NothingHereYet = 0,
		GalleryGridView = 0
	}

	if nothingHereYet then
		local createElement2 = React.createElement

		if FoundationFontFaceMigration then
			font = nil
		end

		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v3.Tokens.Typography.BodySmall.Font)
		end

		nothingHereYet = createElement2("TextLabel", {
			BackgroundTransparency = 1,
			Font = font,
			FontFace = fontFace,
			Size = UDim2.new(1, -12, 1, 12),
			Text = v5.nothingHereYet,
			TextColor3 = color2,
			TextSize = textSize,
			TextTransparency = transparency2,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center
		}, {
			MaxSize = React.createElement("UISizeConstraint", { MaxSize = Vector2.new(312, 1e999) })
		})
	end

	v9.NothingHereYet = nothingHereYet
	local galleryGridView

	if v7 then
		if FFlagUseCaptureCommonComponents then
			galleryGridView = React.createElement(CaptureGridView, {
				captures = captures,
				header = React.createElement(GalleryActionContainer, {
					isDisabled = false,
					itemCount = #captures,
					LayoutOrder = 1
				}),
				renderItem = function(capture, p2)
					return React.createElement(CaptureItem, {
						capture = capture,
						onActivated = v6(p2)
					})
				end,
				shouldShowShowMoreButton = true
			})
		else
			galleryGridView = React.createElement(GalleryGridView, {
				captures = captures,
				Size = UDim2.new(1, -12, 1, -12)
			})
		end
	end

	v9.GalleryGridView = galleryGridView
	return createElement("Frame", v8, v9)
end
