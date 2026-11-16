local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CoreGui = game:GetService("CoreGui")

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

local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useStyle = UIBlox.Core.Style.useStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip

local CaptureManagerOpened = require(parent.Actions.CaptureManagerOpened)
local CapturesPolicy = require(parent.App.CapturesPolicy)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getCaptureStorageUsage = require(parent.Utils.getCaptureStorageUsage)
local usePingLazyRenderResizing = require(parent.Hooks.usePingLazyRenderResizing)

return (CapturesPolicy.connect(function(p)
	return {
		enableCapturesBulkManagement = p.enableCapturesBulkManagement()
	}
end)(function(props)
	local v = useAnalytics()
	local v2 = useStyle()
	local v3 = useDispatch()

	local color = v2.Theme.TextDefault.Color
	local font = v2.Font.CaptionBody.Font
	local textSize = v2.Font.BaseSize * v2.Font.CaptionBody.RelativeSize

	local state, setState = React.useState(false)

	local v4 = useLocalization({
		oneCaptureLabel = "Feature.Captures.Label.OneCapture",
		multipleCapturesLabel = {
			"Feature.Captures.Label.CaptureCounts",
			numberOfCaptures = props.itemCount
		},
		tooltipTitle = "Feature.Captures.Title.CaptureStorageTooltipTitle",
		tooltipBody = "Feature.Captures.Label.CaptureStorageTooltipLabel"
	})

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].Captures
	end)

	local v6 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.IsOpen
	end)

	React.useEffect(function()
		if v6 then
			setState(false)
		end
	end, { v6 })

	local onActivated = React.useCallback(function()
		setState(false)
		v.fireEvent(EventNames.CapturesManagerOpened)
		v3(CaptureManagerOpened())
	end, {})

	local v7 = React.useCallback(function(_)
		setState(not state)
	end, { state })

	local v8 = React.useMemo(function()
		return getCaptureStorageUsage(v5)
	end, { v5 })
	local v9

	if props.itemCount == 1 then
		v9 = v4.oneCaptureLabel
	else
		v9 = v4.multipleCapturesLabel
	end

	if not props.enableCapturesBulkManagement then
		return nil
	end

	local formatted = `{v9}{v8 == "" and "" or ", "}{v8}`

	local ref = React.useRef(nil)
	usePingLazyRenderResizing(ref, formatted)

	local createElement = React.createElement
	local v10 = {
		BackgroundColor3 = v2.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v2.Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 36)
	}
	local v11 = {
		GridLayout = React.createElement("UIGridLayout", {
			CellSize = UDim2.new(0.5, -4, 0, 36),
			FillDirection = Enum.FillDirection.Horizontal,
			FillDirectionMaxCells = 2,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		IconFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SettingIcon = React.createElement(IconButton, {
				icon = Images["icons/common/settings"],
				iconSize = IconSize.Medium,
				onActivated = onActivated,
				showBackground = false,
				size = UDim2.fromOffset(36, 36)
			})
		}),
		TextFrame = 0
	}

	local createElement2 = React.createElement

	local v12 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ItemCountAndStorageSpaceLabel = 0,
		InfoIconWithTooltip = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		Size = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextWrapped = false,
		TextXAlignment = 0,
		ref = 0
	}

	if FoundationFontFaceMigration then
		font = nil
	end

	v13.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Tokens.Typography.BodySmall.Font)
	end

	v13.FontFace = fontFace

	v13.Size = UDim2.fromOffset(0, 20)
	v13.Text = formatted
	v13.TextColor3 = color
	v13.TextSize = textSize

	v13.TextXAlignment = Enum.TextXAlignment.Left
	v13.ref = ref
	v12.ItemCountAndStorageSpaceLabel = createElement3("TextLabel", v13)

	v12.InfoIconWithTooltip = withTooltip(
		{ headerText = v4.tooltipTitle, bodyText = v4.tooltipBody },
		{
			preferredOrientation = TooltipOrientation.Bottom,
			guiTarget = CoreGui,
			DisplayOrder = 100,
			active = state
		},
		function(callback)
			local function fn(p)
				setState(false)
				callback(p)
			end
			return React.createElement(Interactable, {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(16, 16),
				[React.Change.AbsolutePosition] = fn,
				[React.Change.AbsoluteSize] = fn,
				[React.Event.Activated] = v7
			}, {
				InfoIcon = React.createElement(ImageSetLabel, {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Image = Images["icons/actions/info_small"]
				})
			})
		end
	)
	v11.TextFrame = createElement2("Frame", { BackgroundTransparency = 1 }, v12)
	return createElement("Frame", v10, v11)
end))
