local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")

local FFlagMomentsCommentRowRedesign = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentRowRedesign")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")
local ImageWithSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ImageWithSkeleton")
local CommentActionsMenu = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentActionsMenu")
local CommentDeleteConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentDeleteConfirmationDialog")
local CommentReactionButton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentReactionButton")
local CommentRowHighlight = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowHighlight")
local CommentTranslationToggle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentTranslationToggle")
local getLineHeights = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/getLineHeights")

local radius = Foundation.Enums.Radius
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local thumbnailSize = Foundation.Enums.ThumbnailSize
local thumbnailType = Foundation.Enums.ThumbnailType
local getRbxThumb = Foundation.Utility.getRbxThumb
local useComposedRef = ReactUtils.useComposedRef
local useTokens = Foundation.Hooks.useTokens

local function noop() end

local function CommentRowView(props)
	local v5 = useTokens()
	local actionsMenu = props.actionsMenu
	local deleteConfirmation = props.deleteConfirmation
	local translationToggle = props.translationToggle
	local v6

	if translationToggle ~= nil then
		v6 = React.createElement(CommentTranslationToggle, {
			commentId = props.commentId,
			isShowingTranslation = translationToggle.isShowingTranslation,
			onToggle = translationToggle.onToggle,
			LayoutOrder = FFlagMomentsCommentRowRedesign and 3 or 5
		})
	end

	local v7 = not (actionsMenu == nil) and actionsMenu.anchorRef ~= nil

	local state, setState = React.useState(nil)
	local v8 = useComposedRef(props.gestureRef, setState)
	local v9 = React.useMemo(function()
		return { current = state }
	end, { state })
	local v10

	if props.avatarUserId ~= nil then
		v10 = getRbxThumb(thumbnailType.AvatarHeadShot, props.avatarUserId, thumbnailSize.Medium)
	end

	local v12 = if FFlagMomentsCommentRowRedesign then v5.Typography.TitleMedium else v5.Typography.TitleSmall
	local v13 = getLineHeights(v12)
	local udim

	if FFlagMomentsCommentsAttachSheetScroller then
		local v15 = (if FFlagMomentsCommentRowRedesign then v5.Size.Size_800 else v5.Size.Size_700) + v5.Gap.Medium

		if actionsMenu ~= nil and not v7 then
			v15 += v5.Size.Size_600 + v5.Gap.Medium
		end

		udim = UDim2.new(1, -v15, 0, 0)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v14 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		GroupTransparency = props.GroupTransparency,
		testId = `moments-comment-row-{props.commentId}`
	}

	local v16 = if actionsMenu ~= nil and not not v7 then React.createElement(CommentRowHighlight, {
		commentId = props.commentId,
		phase = actionsMenu.isOpen and "Active" or props.isLongPressCharging and "Charging" or "Idle"
	}) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v17 = {
		tag = {
			["row gap-medium size-full-0 auto-y padding-x-small padding-top-small"] = true,
			["padding-bottom-small"] = FFlagMomentsCommentRowRedesign or not props.showReactionControl
		},
		ref = v8,
		onActivated = 0,
		onStateChanged = 0,
		stateLayer = 0,
		selection = 0,
		testId = 0
	}

	local v18 = if props.isGestureSurfaceActive then noop else nil
	v17.onActivated = v18
	local v19 = if props.isGestureSurfaceActive then props.onContentStateChanged else nil
	v17.onStateChanged = v19
	v17.stateLayer = props.isGestureSurfaceActive and {
		affordance = stateLayerAffordance.None
	} or nil
	v17.selection = { Selectable = false }

	v17.testId = `moments-comment-row-content-{props.commentId}`

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v20 = {
		tag = {
			["size-800-800"] = FFlagMomentsCommentRowRedesign,
			["size-700-700"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = 1,
		testId = 0
	}

	local v21 = if props.avatarUserId == nil then `moments-comment-avatar-fallback-{props.commentId}` else `moments-comment-avatar-{props.commentId}`
	v20.testId = v21
	local children = {
		Avatar = createElement3(view3, v20, {
			Image = React.createElement(ImageWithSkeleton, {
				Image = v10,
				Size = UDim2.fromScale(1, 1),
				radius = radius.Circle,
				backgroundStyle = props.avatarBackgroundStyle
			})
		}),
		TextColumn = 0,
		ActionsMenu = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v22 = {
		tag = {
			["col auto-y"] = true,
			fill = not FFlagMomentsCommentsAttachSheetScroller,
			["gap-xsmall"] = FFlagMomentsCommentRowRedesign,
			["gap-small"] = not FFlagMomentsCommentRowRedesign
		},
		Size = udim,
		LayoutOrder = 2,
		testId = `moments-comment-content-{props.commentId}`
	}

	local createElement5 = React.createElement
	local view5 = Foundation.View
	local v24 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			["gap-xxsmall"] = FFlagMomentsCommentRowRedesign,
			["gap-xsmall"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = 1,
		testId = `moments-comment-main-content-{props.commentId}`
	}

	local createElement6 = React.createElement
	local view6 = Foundation.View
	local v25 = {
		tag = "row align-y-center gap-xsmall size-full-0 auto-y clip",
		LayoutOrder = 1,
		testId = `moments-comment-metadata-{props.commentId}`
	}
	local v27

	if props.isAuthorLoading then
		v27 = React.createElement(
			Foundation.View,
			{
				Size = UDim2.fromOffset(v5.Size.Size_2000, v13),
				tag = "row align-y-center",
				LayoutOrder = 1
			},
			{
				Bar = React.createElement(Foundation.Skeleton, {
					Size = UDim2.new(1, 0, 0, v5.Size.Size_300),
					radius = radius.Medium,
					testId = `moments-comment-author-loading-{props.commentId}`
				})
			}
		)
	else
		v27 = React.createElement(Foundation.Text, {
			tag = {
				["shrink auto-xy text-truncate-end"] = true,
				["text-title-medium content-emphasis"] = FFlagMomentsCommentRowRedesign,
				["text-title-small content-default"] = not FFlagMomentsCommentRowRedesign
			},
			LayoutOrder = 1,
			Text = props.authorLabel,
			testId = `moments-comment-author-{props.commentId}`
		})
	end

	local v28 = if not FFlagMomentsCommentRowRedesign and props.metadataLabel ~= nil then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-small content-muted",
		LayoutOrder = 2,
		Text = "·"
	}) else nil

	local v29 = if not FFlagMomentsCommentRowRedesign then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-small text-truncate-end content-muted",
		LayoutOrder = 3,
		Text = props.metadataLabel or "",
		testId = `moments-comment-timestamp-{props.commentId}`
	}) else nil

	local v30 = if not FFlagMomentsCommentRowRedesign and props.headerAction ~= nil then React.createElement(
		Foundation.View,
		{ tag = "auto-xy", LayoutOrder = 4 },
		{ Action = props.headerAction }
	) else nil
	local children2 = {
		Header = createElement6(view6, v25, {
			Author = v27,
			Separator = v28,
			Timestamp = v29,
			HeaderAction = v30,
			TranslationToggle = if not FFlagMomentsCommentRowRedesign then v6 else nil
		}),
		Body = 0,
		BodyMeasure = 0
	}

	local createElement7 = React.createElement
	local text = Foundation.Text
	local v32 = {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
		LayoutOrder = 2,
		Text = props.bodyText or props.text,
		RichText = props.bodyText ~= nil,
		textStyle = 0,
		ref = 0,
		onAbsoluteSizeChanged = 0,
		testId = 0
	}
	local v33 = props.bodyTextStyle

	if not v33 then
		v33 = if FFlagMomentsCommentRowRedesign then v5.Color.Content.Default else v5.Color.Content.Emphasis
	end

	v32.textStyle = v33

	v32.ref = props.bodyRef
	v32.onAbsoluteSizeChanged = props.onBodyAbsoluteSizeChanged
	v32.testId = `moments-comment-body-{props.commentId}`
	children2.Body = createElement7(text, v32)

	local v34 = if props.bodyMeasureRef ~= nil then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
		LayoutOrder = 3,
		RichText = true,
		Visible = false,
		ref = props.bodyMeasureRef,
		testId = `moments-comment-body-measure-{props.commentId}`
	}) else nil
	children2.BodyMeasure = v34
	local v23 = {
		MainContent = createElement5(view5, v24, children2),
		Reaction = 0,
		Footer = 0
	}

	local v35 = if not (FFlagMomentsCommentRowRedesign or not props.showReactionControl) then React.createElement(CommentReactionButton, {
		commentId = props.commentId,
		isReactionSelected = props.isReactionSelected == true,
		isReactionDisabled = props.isReactionDisabled == true,
		reactionCountLabel = props.reactionCountLabel or "0",
		isReactionCountHidden = props.isReactionCountHidden,
		onReactionActivated = props.onReactionActivated or noop,
		LayoutOrder = 2
	}) else nil
	v23.Reaction = v35
	local v36

	if
		FFlagMomentsCommentRowRedesign
		and (props.metadataLabel ~= nil or props.headerAction ~= nil or props.showReactionControl or translationToggle ~= nil)
	then
		local createElement8 = React.createElement
		local view7 = Foundation.View
		local v37 = {
			tag = "row align-y-center gap-small size-full-0 auto-y",
			LayoutOrder = 2,
			testId = `moments-comment-footer-{props.commentId}`
		}

		local createElement9 = React.createElement
		local view8 = Foundation.View
		local v39 = {
			tag = {
				["row align-y-center fill gap-small auto-y clip"] = true,
				wrap = translationToggle ~= nil
			},
			LayoutOrder = 1,
			testId = `moments-comment-footer-metadata-{props.commentId}`
		}

		local v41 = if props.metadataLabel ~= nil then React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small text-truncate-end content-muted",
			LayoutOrder = 1,
			Text = props.metadataLabel,
			testId = `moments-comment-timestamp-{props.commentId}`
		}) else nil

		local v42 = if props.headerAction ~= nil then React.createElement(
			Foundation.View,
			{ tag = "auto-xy", LayoutOrder = 2 },
			{ Action = props.headerAction }
		) else nil
		local v38 = {
			Metadata = createElement9(view8, v39, {
				Timestamp = v41,
				HeaderAction = v42,
				TranslationToggle = v6
			}),
			Reaction = 0
		}

		local v43 = if props.showReactionControl then React.createElement(CommentReactionButton, {
			commentId = props.commentId,
			isReactionSelected = props.isReactionSelected == true,
			isReactionDisabled = props.isReactionDisabled == true,
			reactionCountLabel = props.reactionCountLabel or "0",
			isReactionCountHidden = props.isReactionCountHidden,
			onReactionActivated = props.onReactionActivated or noop,
			LayoutOrder = 2
		}) else nil
		v38.Reaction = v43
		v36 = createElement8(view7, v37, v38)
	end

	v23.Footer = v36
	children.TextColumn = createElement4(view4, v22, v23)

	local v37 = if actionsMenu ~= nil and not v7 then React.createElement(CommentActionsMenu, {
		commentId = props.commentId,
		items = actionsMenu.items,
		isOpen = actionsMenu.isOpen,
		onButtonActivated = actionsMenu.onButtonActivated,
		onClose = actionsMenu.onClose,
		LayoutOrder = 3
	}) else nil
	children.ActionsMenu = v37
	local v15 = {
		Highlight = v16,
		Content = createElement2(view2, v17, children),
		RowActionsMenu = 0,
		DeleteConfirmation = 0
	}

	local v38 = if actionsMenu ~= nil and not not v7 and state ~= nil then React.createElement(CommentActionsMenu, {
		commentId = props.commentId,
		items = actionsMenu.items,
		isOpen = actionsMenu.isOpen,
		anchorRef = v9,
		onButtonActivated = actionsMenu.onButtonActivated,
		onClose = actionsMenu.onClose
	}) else nil
	v15.RowActionsMenu = v38

	local v39 = if deleteConfirmation ~= nil then React.createElement(CommentDeleteConfirmationDialog, {
		commentId = props.commentId,
		onConfirm = deleteConfirmation.onConfirm,
		onCancel = deleteConfirmation.onCancel
	}) else nil
	v15.DeleteConfirmation = v39
	return createElement(view, v14, v15)
end

return CommentRowView
