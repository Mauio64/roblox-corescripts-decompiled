local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local useComposedRef = ReactUtils.useComposedRef
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local CommentsComposerContainer = require(Moments.Components.Comments.Composer.CommentsComposerContainer)

local CommentsPanelBodyContainer = require(Moments.Components.Comments.Panel.CommentsPanelBody.CommentsPanelBodyContainer)
local SheetShim = require(Moments.Components.SheetShim)
local CommentsSheetSnapPoints = require(script.Parent.CommentsSheetSnapPoints)
local FFlagMomentsCommentsSheetFocusNavigation = require(Moments.Flags.FFlagMomentsCommentsSheetFocusNavigation)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)

local function sizeContentForList(p)
	if p ~= nil then
		p.AutomaticSize = Enum.AutomaticSize.None
	end
end

local function sizeContentToFit(p)
	if p ~= nil then
		p.AutomaticSize = Enum.AutomaticSize.Y
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
	local v = useTopSnapPointReporter(props.onSnapPointChanged)

	local v2 = useComposedRef(props.scrollingFrameRef, v)
	local v3

	if FFlagMomentsCommentsAttachSheetScroller then
		v3 = props.onScrollingFrameChanged
	elseif props.isListDisplayed then
		v3 = sizeContentForList
	else
		v3 = sizeContentToFit
	end

	local scrollingFrameRef = useComposedRef(v2, v3)
	local ref

	if FFlagMomentsCommentsSheetFocusNavigation then
		ref = useFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			isFocusable = props.isOpen
		})
	end

	local createElement = React.createElement
	local root = SheetShim.Root
	local v4 = {
		isOpen = props.isOpen,
		onClose = props.onClose,
		onSnapPointChanged = props.onSnapPointChanged,
		onContentInsetChanged = props.onContentInsetChanged,
		hideBackdrop = true,
		size = DialogSize.Medium,
		snapPoints = CommentsSheetSnapPoints,
		testId = "moments-comments-sheet",
		ref = ref
	}

	local children = {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(Text, {
				Text = props.title,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local isContentFullBleed

	if FFlagMomentsCommentsAttachSheetScroller then
		isContentFullBleed = props.isListDisplayed
	end

	children.Content = createElement2(
		content,
		{ scrollingFrameRef = scrollingFrameRef, isContentFullBleed = isContentFullBleed },
		{
			ContentSlot = React.createElement(View, {
				tag = {
					["size-full"] = not FFlagMomentsCommentsAttachSheetScroller and props.isListDisplayed,
					["size-full-0 auto-y"] = FFlagMomentsCommentsAttachSheetScroller or not props.isListDisplayed
				},
				testId = "moments-comments-content-slot"
			}, {
				PanelBody = React.createElement(CommentsPanelBodyContainer, props.panelBodyProps)
			})
		}
	)

	local createElement3 = React.createElement
	local actions = Sheet.Actions
	local v5 = { ref = props.actionsRef }

	local createElement4 = React.createElement
	local composer

	if props.composerProps ~= nil then
		composer = React.createElement(CommentsComposerContainer, props.composerProps)
	end

	children.Actions = createElement3(actions, v5, {
		ComposerSlot = createElement4(View, {
			tag = "size-full-0 auto-y",
			testId = "moments-comments-composer-slot"
		}, {
			Composer = composer
		})
	})
	return createElement(root, v4, children)
end

return CommentsSheetView
