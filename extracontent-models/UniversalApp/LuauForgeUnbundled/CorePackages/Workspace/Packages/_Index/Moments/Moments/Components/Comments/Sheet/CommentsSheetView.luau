local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")

local dialogSize = Foundation.Enums.DialogSize
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local useComposedRef = ReactUtils.useComposedRef
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local CommentsComposerContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/CommentsComposerContainer")

local CommentsPanelBodyContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/CommentsPanelBodyContainer")
local SheetShim = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim")
local CommentsSheetSnapPoints = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/CommentsSheetSnapPoints")
local FFlagMomentsCommentsSheetFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsSheetFocusNavigation")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")

local function sizeContentForList(p2)
	if p2 ~= nil then
		p2.AutomaticSize = Enum.AutomaticSize.None
	end
end

local function sizeContentToFit(p2)
	if p2 ~= nil then
		p2.AutomaticSize = Enum.AutomaticSize.Y
	end
end

local function useTopSnapPointReporter(onSnapPointChanged)
	local ref = React.useRef(nil)
	return React.useCallback(function(instance)
		if ref.current ~= nil then
			ref.current:Disconnect()
			ref.current = nil
		end

		if instance ~= nil then
			ref.current = instance:GetPropertyChangedSignal("ScrollingEnabled"):Connect(function()
				if instance.ScrollingEnabled then
					local count = #CommentsSheetSnapPoints
					onSnapPointChanged(CommentsSheetSnapPoints[count], count)
				end
			end)
		end
	end, { onSnapPointChanged })
end

local function CommentsSheetView(props)
	local v5 = useTopSnapPointReporter(props.onSnapPointChanged)

	local v6 = useComposedRef(props.scrollingFrameRef, v5)
	local v8

	if FFlagMomentsCommentsAttachSheetScroller then
		v8 = props.onScrollingFrameChanged
	else
		v8 = if props.isListDisplayed then sizeContentForList else sizeContentToFit
	end

	local v9 = useComposedRef(v6, v8)
	local v10

	if FFlagMomentsCommentsSheetFocusNavigation then
		v10 = useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isFocusable = props.isOpen
		})
	end

	local createElement = React.createElement
	local root = SheetShim.Root
	local v11 = {
		isOpen = props.isOpen,
		onClose = props.onClose,
		onSnapPointChanged = props.onSnapPointChanged,
		onContentInsetChanged = props.onContentInsetChanged,
		hideBackdrop = true,
		size = dialogSize.Medium,
		snapPoints = CommentsSheetSnapPoints,
		testId = "moments-comments-sheet",
		ref = v10
	}

	local children = {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(text, {
				Text = props.title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local v13 = if FFlagMomentsCommentsAttachSheetScroller then props.isListDisplayed else nil
	children.Content = createElement2(content, {
		scrollingFrameRef = v9,
		isContentFullBleed = v13
	}, {
		ContentSlot = React.createElement(view, {
			tag = {
				["size-full"] = not FFlagMomentsCommentsAttachSheetScroller and props.isListDisplayed,
				["size-full-0 auto-y"] = FFlagMomentsCommentsAttachSheetScroller or not props.isListDisplayed
			},
			testId = "moments-comments-content-slot"
		}, {
			PanelBody = React.createElement(CommentsPanelBodyContainer, props.panelBodyProps)
		})
	})

	local createElement3 = React.createElement
	local actions = sheet.Actions
	local v14 = { ref = props.actionsRef }

	local createElement4 = React.createElement

	local v19 = if props.composerProps ~= nil then React.createElement(CommentsComposerContainer, props.composerProps) else nil
	children.Actions = createElement3(actions, v14, {
		ComposerSlot = createElement4(
			view,
			{ tag = "size-full-0 auto-y", testId = "moments-comments-composer-slot" },
			{ Composer = v19 }
		)
	})
	return createElement(root, v11, children)
end

return CommentsSheetView
