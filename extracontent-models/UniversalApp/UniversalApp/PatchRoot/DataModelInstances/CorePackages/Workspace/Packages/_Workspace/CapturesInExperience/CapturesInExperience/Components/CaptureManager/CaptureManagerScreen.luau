local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local GridView = UIBlox.App.Grid.GridView
local useStyle = UIBlox.Core.Style.useStyle
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useTopbarInsetHeight = require(ParentParent.Hooks.useTopbarInsetHeight)
local CaptureManagerClosed = require(ParentParent.Actions.CaptureManagerClosed)
local CaptureManagerItem = require(ParentParent.Components.CaptureManager.CaptureManagerItem)
local CaptureManagerCTAContainer = require(ParentParent.Components.CaptureManager.CaptureManagerCTAContainer)
local Constants = require(ParentParent.Constants)
local DeleteCaptures = require(ParentParent.Thunks.DeleteCaptures)
local DeleteWarningModal = require(ParentParent.Components.Common.DeleteWarningModal)
local EventNames = require(ParentParent.Analytics.EventNames)
local PermissionModal = require(ParentParent.Components.Common.PermissionModal)
local ShowMoreButton = require(ParentParent.Components.Common.ShowMoreButton)
local ToastContainer = require(ParentParent.Components.Common.ToastContainer)

require(ParentParent.Types)

local UpdateSelectedCaptures = require(ParentParent.Actions.UpdateSelectedCaptures)
local uDim2 = UDim2.fromOffset(32, 32)

local function getItemsPerRow(n1: number) -- line: 66
	return (math.clamp(math.floor(n1 / 90), 1, 3))
end
local function getGalleryItemSize(n2: number, n3: number) -- line: 70
	local v44 = math.clamp(math.floor(n3 / 90), 1, 3)
	local v45 = (n3 - (v44 - 1) * 4) / v44
	local v46 = v45 * n2

	return Vector2.new(math.floor(v45), (math.floor(v46)))
end
local function renderItem(p1, n4: number) -- line: 80
	-- upvalues: React (copy), CaptureManagerItem (copy)
	return React.createElement(CaptureManagerItem, {
		capture = p1,
		captureIndex = n4
	})
end

return function(_: {[any]: any}) -- line: 87
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), useTopbarInsetHeight (copy), useSelector (copy), Constants (copy), useLocalization (copy), React (copy), useState (copy), useScreenSize (copy), useCallback (copy), CaptureManagerClosed (copy), DeleteCaptures (copy), UpdateSelectedCaptures (copy), EventNames (copy), Dash (copy), View (copy), ImageSetButton (copy), Images (copy), uDim2 (copy), FoundationText (copy), ScrollView (copy), ScrollBarVisibility (copy), GridView (copy), renderItem (copy), ShowMoreButton (copy), CaptureManagerCTAContainer (copy), DeleteWarningModal (copy), PermissionModal (copy), ToastContainer (copy)
	local v50 = useAnalytics()
	local v51 = useDispatch()
	local v52 = useStyle()
	local v53 = useTopbarInsetHeight()
	local v54 = useSelector(function(p2) -- line: 94
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].Captures
	end)
	local v55 = useSelector(function(p3) -- line: 98
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)
	local v56 = useSelector(function(p4) -- line: 102
		-- upvalues: Constants (copy)
		return p4[Constants.RoduxKey].CaptureManager.IsOpen
	end)
	local v57 = useLocalization({
		cancelSelectAllAction = "Feature.Captures.Action.CancelSelectAllCaptures",
		selectAllAction = "Feature.Captures.Action.SelectAllCaptures"
	})
	local v58 = React.useRef(nil)
	local v59, v60 = useState(Vector2.new(0, 0))
	local v61, v62 = useState(false)
	local v63, v64 = useState(false)
	local v65, v66 = React.useState(24)
	local v67 = if #v55 ~= 0 then v57.cancelSelectAllAction else v57.selectAllAction
	local v68 = useScreenSize()

	React.useEffect(function() -- line: 121
		-- upvalues: v58 (copy), v60 (copy)
		if v58.current then
			v60(v58.current.AbsoluteSize)
		end
	end, {})

	local v69 = useCallback(function(p5) -- line: 127
		-- upvalues: v60 (copy)
		v60(p5.AbsoluteSize)
	end, {})
	local v70 = useCallback(function() -- line: 131
		-- upvalues: v62 (copy), v51 (copy), CaptureManagerClosed (copy)
		v62(false)
		v51(CaptureManagerClosed())
	end, {})
	local v71 = useCallback(function() -- line: 136
		-- upvalues: v64 (copy)
		v64(true)
	end, {})
	local v72 = useCallback(function() -- line: 140
		-- upvalues: v64 (copy)
		v64(false)
	end, {})
	local v73 = useCallback(function() -- line: 144
		-- upvalues: v51 (copy), DeleteCaptures (copy), v55 (copy)
		v51(DeleteCaptures(v55))
	end, { v55 })
	local v74 = useCallback(function() -- line: 148
		-- upvalues: v55 (copy), v51 (copy), UpdateSelectedCaptures (copy), v54 (copy), v50 (copy), EventNames (copy)
		if #v55 == 0 then
			v51(UpdateSelectedCaptures(v54))
			v50.fireEvent(EventNames.CapturesManagerSelectAllActivated)

			return
		end

		v51(UpdateSelectedCaptures({}))
	end, {
		v55,
		v54
	})
	local v75 = React.useCallback(function() -- line: 157
		-- upvalues: v66 (copy), v65 (copy)
		v66(v65 + 24)
	end, { v65 })
	local v76 = React.useMemo(function() -- line: 161
		-- upvalues: v54 (copy), v65 (copy), Dash (copy)
		local v92 = math.min(#v54, v65)

		return Dash.slice(v54, 1, v92)
	end, {
		v54,
		v65
	})

	if not v56 then
		return nil
	end

	local v77 = v59.X > 0 and v59.Y > 0
	local v78 = math.clamp(v68.Y / v68.X, 0.42857142857142855, 1)
	local Y = v59.Y
	local v80 = v59.X - 41
	local v81 = math.clamp(math.floor(v80 / 90), 1, 3)
	local v82 = (v80 - (v81 - 1) * 4) / v81
	local v83 = v82 * v78
	local vector2 = Vector2.new(math.floor(v82), (math.floor(v83)))
	local v85 = Y < v80
	local v86 = not v85 and 82 or 44
	local v87 = (vector2.Y + 4) * math.ceil(#v54 / math.clamp(math.floor(v80 / 90), 1, 3))

	return React.createElement(View, {
		BorderSizePixel = 0,
		tag = "bg-surface-100",
		onAbsoluteSizeChanged = v69,
		Position = UDim2.fromOffset(0, -v53),
		ref = v58,
		Size = UDim2.new(1, 0, 1, v53)
	}, {
		CaptureManagerContainer = React.createElement(View, {
			tag = "bg-action-subtle size-full padding-bottom-small padding-right-small padding-left-xxlarge padding-top-xxlarge gap-xsmall col align-x-center align-y-top"
		}, {
			TitleFrame = React.createElement(View, {
				LayoutOrder = 1,
				tag = "bg-action-subtle",
				ZIndex = 2,
				Size = UDim2.new(1, 0, 0, 32)
			}, {
				CloseButton = React.createElement(ImageSetButton, {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Image = Images["icons/navigation/close"],
					ImageColor3 = v52.Theme.IconEmphasis.Color,
					ImageTransparency = v52.Theme.IconEmphasis.Transparency,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = uDim2,
					[React.Event.Activated] = v70
				}),
				SelectOrDeselectAllButton = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-x anchor-center-right bg-action-subtle size-0-full text-defaults text-align-x-center text-align-y-center text-title-large",
					ZIndex = 2,
					onActivated = v74,
					Position = UDim2.new(1, -16, 0.5, 2),
					Text = v67
				})
			}),
			ScrollingFrame = React.createElement(ScrollView, {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				tag = "bg-action-subtle gap-xsmall col align-x-center align-y-top",
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = ScrollBarVisibility.None
				},
				Size = UDim2.new(1, 0, 1, -(v86 + 40))
			}, {
				GridView = v77 and React.createElement(GridView, {
					LayoutOrder = 1,
					itemPadding = Vector2.new(4, 4),
					items = v76,
					itemSize = vector2,
					maxHeight = v87,
					renderItem = renderItem,
					Size = UDim2.fromScale(1, 0.9)
				}),
				ShowMoreButton = v65 < #v54 and React.createElement(ShowMoreButton, {
					buttonHeight = 40,
					LayoutOrder = 2,
					onActivated = v75
				})
			}),
			CTAContainer = React.createElement(CaptureManagerCTAContainer, {
				LayoutOrder = 3,
				ZIndex = 2,
				deleteItem = v73,
				height = v86,
				isDisabled = v61,
				isHorizontal = v85,
				openPermissionModal = v71,
				width = v80
			})
		}),
		DeleteWarningModal = React.createElement(DeleteWarningModal, {
			zIndex = 3,
			deleteItem = v73
		}),
		PermissionModal = React.createElement(PermissionModal, {
			zIndex = 3,
			closeModal = v72,
			visible = v63
		}),
		ToastsFrame = React.createElement(View, {
			tag = "bg-action-subtle size-full",
			ZIndex = Constants.ZIndex.Toasts
		}, {
			ToastContainer = React.createElement(ToastContainer)
		})
	})
end
