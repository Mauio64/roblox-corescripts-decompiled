local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CoreGui = game:GetService("CoreGui")
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local UIBlox = require(ParentParentParent.UIBlox)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
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
local CaptureManagerOpened = require(ParentParent.Actions.CaptureManagerOpened)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getCaptureStorageUsage = require(ParentParent.Utils.getCaptureStorageUsage)
local usePingLazyRenderResizing = require(ParentParent.Hooks.usePingLazyRenderResizing)

return (CapturesPolicy.connect(function(p1) -- line: 200
	return {
		enableCapturesBulkManagement = p1.enableCapturesBulkManagement()
	}
end)(function(t1: {[any]: any}) -- line: 44
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), React (copy), useLocalization (copy), useSelector (copy), Constants (copy), EventNames (copy), CaptureManagerOpened (copy), getCaptureStorageUsage (copy), usePingLazyRenderResizing (copy), IconButton (copy), Images (copy), IconSize (copy), withTooltip (copy), TooltipOrientation (copy), CoreGui (copy), Interactable (copy), ImageSetLabel (copy)
	local v27 = useAnalytics()
	local v28 = useStyle()
	local v29 = useDispatch()
	local TextDefaultColor = v28.Theme.TextDefault.Color
	local CaptionBodyFont = v28.Font.CaptionBody.Font
	local v32 = v28.Font.BaseSize * v28.Font.CaptionBody.RelativeSize
	local v33, v34 = React.useState(false)
	local v35 = useLocalization({
		oneCaptureLabel = "Feature.Captures.Label.OneCapture",
		tooltipTitle = "Feature.Captures.Title.CaptureStorageTooltipTitle",
		tooltipBody = "Feature.Captures.Label.CaptureStorageTooltipLabel",
		multipleCapturesLabel = {
			"Feature.Captures.Label.CaptureCounts",
			numberOfCaptures = t1.itemCount
		}
	})
	local v36 = useSelector(function(p2) -- line: 65
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].Captures
	end)
	local v37 = useSelector(function(p3) -- line: 69
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].Carousel.IsOpen
	end)

	React.useEffect(function() -- line: 73
		-- upvalues: v37 (copy), v34 (copy)
		if v37 then
			v34(false)
		end
	end, { v37 })

	local v38 = React.useCallback(function() -- line: 79
		-- upvalues: v34 (copy), v27 (copy), EventNames (copy), v29 (copy), CaptureManagerOpened (copy)
		v34(false)
		v27.fireEvent(EventNames.CapturesManagerOpened)
		v29(CaptureManagerOpened())
	end, {})
	local v39 = React.useCallback(function(_) -- line: 85
		-- upvalues: v34 (copy), v33 (copy)
		v34(not v33)
	end, { v33 })
	local v40 = React.useMemo(function() -- line: 89
		-- upvalues: getCaptureStorageUsage (copy), v36 (copy)
		return getCaptureStorageUsage(v36)
	end, { v36 })
	local v41 = if t1.itemCount ~= 1 then v35.multipleCapturesLabel else v35.oneCaptureLabel

	if not t1.enableCapturesBulkManagement then
		return nil
	end

	local v42 = `{ v41 }{ v40 == "" and "" or ", " }{ v40 }`
	local v43 = React.useRef(nil)

	usePingLazyRenderResizing(v43, v42)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = v28.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v28.Theme.BackgroundDefault.Transparency,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 36)
	}, {
		GridLayout = React.createElement("UIGridLayout", {
			FillDirectionMaxCells = 2,
			CellSize = UDim2.new(0.5, -4, 0, 36),
			FillDirection = Enum.FillDirection.Horizontal,
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
				showBackground = false,
				icon = Images["icons/common/settings"],
				iconSize = IconSize.Medium,
				onActivated = v38,
				size = UDim2.fromOffset(36, 36)
			})
		}),
		TextFrame = React.createElement("Frame", {
			BackgroundTransparency = 1
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ItemCountAndStorageSpaceLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextWrapped = false,
				AutomaticSize = Enum.AutomaticSize.X,
				Font = CaptionBodyFont,
				Size = UDim2.fromOffset(0, 20),
				Text = v42,
				TextColor3 = TextDefaultColor,
				TextSize = v32,
				TextXAlignment = Enum.TextXAlignment.Left,
				ref = v43
			}),
			InfoIconWithTooltip = withTooltip({
				headerText = v35.tooltipTitle,
				bodyText = v35.tooltipBody
			}, {
				DisplayOrder = 100,
				preferredOrientation = TooltipOrientation.Bottom,
				guiTarget = CoreGui,
				active = v33
			}, function(p5) -- line: 174
				-- upvalues: v34 (copy), React (copy), Interactable (copy), v39 (copy), ImageSetLabel (copy), Images (copy)
				local function v49(p6) -- line: 175
					-- upvalues: v34 (copy), p5 (copy)
					v34(false)
					p5(p6)
				end

				return React.createElement(Interactable, {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromOffset(16, 16),
					[React.Change.AbsolutePosition] = v49,
					[React.Change.AbsoluteSize] = v49,
					[React.Event.Activated] = v39
				}, {
					InfoIcon = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Image = Images["icons/actions/info_small"]
					})
				})
			end)
		})
	})
end))
