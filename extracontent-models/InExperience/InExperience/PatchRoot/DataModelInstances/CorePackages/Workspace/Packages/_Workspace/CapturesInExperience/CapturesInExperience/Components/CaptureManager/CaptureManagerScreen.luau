local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local GridView = UIBlox.App.Grid.GridView
local useStyle = UIBlox.Core.Style.useStyle

local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local useAnalytics = require(parent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useTopbarInsetHeight = require(parent.Hooks.useTopbarInsetHeight)

local CaptureManagerClosed = require(parent.Actions.CaptureManagerClosed)
local CaptureManagerItem = require(parent.Components.CaptureManager.CaptureManagerItem)
local CaptureManagerCTAContainer = require(parent.Components.CaptureManager.CaptureManagerCTAContainer)
local Constants = require(parent.Constants)
local DeleteCaptures = require(parent.Thunks.DeleteCaptures)
local DeleteWarningModal = require(parent.Components.Common.DeleteWarningModal)
local EventNames = require(parent.Analytics.EventNames)
local PermissionModal = require(parent.Components.Common.PermissionModal)
local ShowMoreButton = require(parent.Components.Common.ShowMoreButton)
local ToastContainer = require(parent.Components.Common.ToastContainer)
require(parent.Types)
local UpdateSelectedCaptures = require(parent.Actions.UpdateSelectedCaptures)

local udim = UDim2.fromOffset(32, 32)

local function getItemsPerRow(p: number) -- 2 equivalent calls inferred from this helper
	return (math.clamp(math.floor(p / 90), 1, 3))
end

local function getGalleryItemSize(p: number, p2: number) -- 1 equivalent call inferred from this helper
	local itemsPerRow = getItemsPerRow(p2) -- inferred equivalent call
	local v = (p2 - (itemsPerRow - 1) * 4) / itemsPerRow
	local v2 = v * p

	return Vector2.new(math.floor(v), (math.floor(v2)))
end

local function renderItem(capture, captureIndex: number)
	return React.createElement(CaptureManagerItem, {
		capture = capture,
		captureIndex = captureIndex
	})
end

return function(_)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()

	local v4 = useTopbarInsetHeight()

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].Captures
	end)

	local v6 = useSelector(function(p)
		return p[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)

	local v7 = useSelector(function(p)
		return p[Constants.RoduxKey].CaptureManager.IsOpen
	end)

	local v8 = useLocalization({
		cancelSelectAllAction = "Feature.Captures.Action.CancelSelectAllCaptures",
		selectAllAction = "Feature.Captures.Action.SelectAllCaptures"
	})

	local ref = React.useRef(nil)
	local state, setState = useState(Vector2.new(0, 0))
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)
	local state4, setState4 = React.useState(24)
	local text

	if #v6 == 0 then
		text = v8.selectAllAction
	else
		text = v8.cancelSelectAllAction
	end

	local v9 = useScreenSize()

	React.useEffect(function()
		if ref.current then
			setState(ref.current.AbsoluteSize)
		end
	end, {})

	local onAbsoluteSizeChanged = useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	local v10 = useCallback(function()
		setState2(false)
		v2(CaptureManagerClosed())
	end, {})

	local openPermissionModal = useCallback(function()
		setState3(true)
	end, {})

	local closeModal = useCallback(function()
		setState3(false)
	end, {})

	local deleteItem = useCallback(function()
		v2(DeleteCaptures(v6))
	end, { v6 })

	local onActivated = useCallback(function()
		if #v6 ~= 0 then
			v2(UpdateSelectedCaptures({}))

			return
		end

		v2(UpdateSelectedCaptures(v5))
		v.fireEvent(EventNames.CapturesManagerSelectAllActivated)
	end, { v6, v5 })

	local onActivated2 = React.useCallback(function()
		setState4(state4 + 24)
	end, { state4 })

	local items = React.useMemo(function()
		local v11 = math.min(#v5, state4)
		return Dash.slice(v5, 1, v11)
	end, { v5, state4 })

	if not v7 then
		return nil
	end

	local v11

	if state.X > 0 then
		v11 = state.Y > 0
	else
		v11 = false
	end

	local v12 = math.clamp(v9.Y / v9.X, 3 / 7, 1)
	local y = state.Y
	local width = state.X - 41
	local galleryItemSize = getGalleryItemSize(v12, width) -- inferred equivalent call
	local isHorizontal = y < width
	local height = isHorizontal and 44 or 82
	local maxHeight = (galleryItemSize.Y + 4) * math.ceil(#v5 / getItemsPerRow(width)) -- inferred equivalent call

	return React.createElement(View, {
		BorderSizePixel = 0,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		Position = UDim2.fromOffset(0, -v4),
		ref = ref,
		Size = UDim2.new(1, 0, 1, v4),
		tag = "bg-surface-100"
	}, {
		CaptureManagerContainer = React.createElement(
			View,
			{
				tag = "bg-action-subtle size-full padding-bottom-small padding-right-small padding-left-xxlarge padding-top-xxlarge gap-xsmall col align-x-center align-y-top"
			},
			{
				TitleFrame = React.createElement(
					View,
					{
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 32),
						tag = "bg-action-subtle",
						ZIndex = 2
					},
					{
						CloseButton = React.createElement(ImageSetButton, {
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Image = Images["icons/navigation/close"],
							ImageColor3 = v3.Theme.IconEmphasis.Color,
							ImageTransparency = v3.Theme.IconEmphasis.Transparency,
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = udim,
							[React.Event.Activated] = v10
						}),
						SelectOrDeselectAllButton = React.createElement(Text, {
							LayoutOrder = 1,
							onActivated = onActivated,
							Position = UDim2.new(1, -16, 0.5, 2),
							tag = "auto-x anchor-center-right bg-action-subtle size-0-full text-defaults text-align-x-center text-align-y-center text-title-large",
							Text = text,
							ZIndex = 2
						})
					}
				),
				ScrollingFrame = React.createElement(ScrollView, {
					BorderSizePixel = 0,
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.fromScale(1, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = ScrollBarVisibility.None
					},
					Size = UDim2.new(1, 0, 1, -(height + 40)),
					tag = "bg-action-subtle gap-xsmall col align-x-center align-y-top"
				}, {
					GridView = v11 and React.createElement(GridView, {
						itemPadding = Vector2.new(4, 4),
						items = items,
						itemSize = galleryItemSize,
						LayoutOrder = 1,
						maxHeight = maxHeight,
						renderItem = renderItem,
						Size = UDim2.fromScale(1, 0.9)
					}),
					ShowMoreButton = state4 < #v5 and React.createElement(ShowMoreButton, {
						buttonHeight = 40,
						LayoutOrder = 2,
						onActivated = onActivated2
					})
				}),
				CTAContainer = React.createElement(CaptureManagerCTAContainer, {
					deleteItem = deleteItem,
					height = height,
					isDisabled = state2,
					isHorizontal = isHorizontal,
					LayoutOrder = 3,
					openPermissionModal = openPermissionModal,
					width = width,
					ZIndex = 2
				})
			}
		),
		DeleteWarningModal = React.createElement(DeleteWarningModal, {
			deleteItem = deleteItem,
			zIndex = 3
		}),
		PermissionModal = React.createElement(PermissionModal, {
			closeModal = closeModal,
			visible = state3,
			zIndex = 3
		}),
		ToastsFrame = React.createElement(
			View,
			{ tag = "bg-action-subtle size-full", ZIndex = Constants.ZIndex.Toasts },
			{
				ToastContainer = React.createElement(ToastContainer)
			}
		)
	})
end
