local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local FFlagMomentsCommentRowRedesign = require(Moments.Flags.FFlagMomentsCommentRowRedesign)
local FFlagMomentsCommentsAttachSheetScroller = require(Moments.Flags.FFlagMomentsCommentsAttachSheetScroller)
local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)
local CommentActionsMenu = require(script.Parent.CommentActionsMenu)
local CommentDeleteConfirmationDialog = require(script.Parent.CommentDeleteConfirmationDialog)
local CommentReactionButton = require(script.Parent.CommentReactionButton)
local CommentRowHighlight = require(script.Parent.CommentRowHighlight)
local CommentTranslationToggle = require(script.Parent.CommentTranslationToggle)
local getLineHeights = require(script.Parent.Parent.getLineHeights)

local Radius = Foundation.Enums.Radius
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType
local getRbxThumb = Foundation.Utility.getRbxThumb
local useComposedRef = ReactUtils.useComposedRef
local useTokens = Foundation.Hooks.useTokens

local function noop() end

local function CommentRowView(props)
	local v = useTokens()
	local actionsMenu = props.actionsMenu
	local deleteConfirmation = props.deleteConfirmation
	local translationToggle = props.translationToggle
	local translationToggle2

	if translationToggle ~= nil then
		translationToggle2 = React.createElement(CommentTranslationToggle, {
			commentId = props.commentId,
			isShowingTranslation = translationToggle.isShowingTranslation,
			onToggle = translationToggle.onToggle,
			LayoutOrder = FFlagMomentsCommentRowRedesign and 3 or 5
		})
	end

	local v2

	if actionsMenu == nil then
		v2 = false
	else
		v2 = actionsMenu.anchorRef ~= nil
	end

	local state, setState = React.useState(nil)
	local ref = useComposedRef(props.gestureRef, setState)
	local anchorRef = React.useMemo(function()
		return { current = state }
	end, { state })
	local image

	if props.avatarUserId ~= nil then
		image = getRbxThumb(ThumbnailType.AvatarHeadShot, props.avatarUserId, ThumbnailSize.Medium)
	end

	local v3

	if FFlagMomentsCommentRowRedesign then
		v3 = v.Typography.TitleMedium
	else
		v3 = v.Typography.TitleSmall
	end

	local lineHeights = getLineHeights(v3)
	local udim

	if FFlagMomentsCommentsAttachSheetScroller then
		local v4

		if FFlagMomentsCommentRowRedesign then
			v4 = v.Size.Size_800
		else
			v4 = v.Size.Size_700
		end

		local v5 = v4 + v.Gap.Medium

		if actionsMenu ~= nil and not v2 then
			v5 += v.Size.Size_600 + v.Gap.Medium
		end

		udim = UDim2.new(1, -v5, 0, 0)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		GroupTransparency = props.GroupTransparency,
		testId = `moments-comment-row-{props.commentId}`
	}
	local highlight

	if not (actionsMenu == nil or not v2) then
		highlight = React.createElement(CommentRowHighlight, {
			commentId = props.commentId,
			phase = actionsMenu.isOpen and "Active" or props.isLongPressCharging and "Charging" or "Idle"
		})
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v5 = {
		tag = {
			["row gap-medium size-full-0 auto-y padding-x-small padding-top-small"] = true,
			["padding-bottom-small"] = FFlagMomentsCommentRowRedesign or not props.showReactionControl
		},
		ref = ref,
		onActivated = 0,
		onStateChanged = 0,
		stateLayer = 0,
		selection = 0,
		testId = 0
	}
	local onActivated

	if props.isGestureSurfaceActive then
		onActivated = noop
	end

	v5.onActivated = onActivated
	local onStateChanged

	if props.isGestureSurfaceActive then
		onStateChanged = props.onContentStateChanged
	end

	v5.onStateChanged = onStateChanged
	v5.stateLayer = props.isGestureSurfaceActive and { affordance = StateLayerAffordance.None } or nil
	v5.selection = { Selectable = false }

	v5.testId = `moments-comment-row-content-{props.commentId}`

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v6 = {
		tag = {
			["size-800-800"] = FFlagMomentsCommentRowRedesign,
			["size-700-700"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = 1,
		testId = 0
	}
	local testId

	if props.avatarUserId == nil then
		testId = `moments-comment-avatar-fallback-{props.commentId}`
	else
		testId = `moments-comment-avatar-{props.commentId}`
	end

	v6.testId = testId
	local children = {
		Avatar = createElement3(view3, v6, {
			Image = React.createElement(ImageWithSkeleton, {
				Image = image,
				Size = UDim2.fromScale(1, 1),
				radius = Radius.Circle,
				backgroundStyle = props.avatarBackgroundStyle
			})
		}),
		TextColumn = 0,
		ActionsMenu = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v7 = {
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
	local v8 = {
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
	local v10 = {
		tag = "row align-y-center gap-xsmall size-full-0 auto-y clip",
		LayoutOrder = 1,
		testId = `moments-comment-metadata-{props.commentId}`
	}
	local author

	if props.isAuthorLoading then
		author = React.createElement(
			Foundation.View,
			{
				Size = UDim2.fromOffset(v.Size.Size_2000, lineHeights),
				tag = "row align-y-center",
				LayoutOrder = 1
			},
			{
				Bar = React.createElement(Foundation.Skeleton, {
					Size = UDim2.new(1, 0, 0, v.Size.Size_300),
					radius = Radius.Medium,
					testId = `moments-comment-author-loading-{props.commentId}`
				})
			}
		)
	else
		author = React.createElement(Foundation.Text, {
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

	local separator

	if not (FFlagMomentsCommentRowRedesign or props.metadataLabel == nil) then
		separator = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small content-muted",
			LayoutOrder = 2,
			Text = "·"
		})
	end

	local timestamp

	if not FFlagMomentsCommentRowRedesign then
		timestamp = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-small text-truncate-end content-muted",
			LayoutOrder = 3,
			Text = props.metadataLabel or "",
			testId = `moments-comment-timestamp-{props.commentId}`
		})
	end

	local headerAction

	if not (FFlagMomentsCommentRowRedesign or props.headerAction == nil) then
		headerAction = React.createElement(Foundation.View, { tag = "auto-xy", LayoutOrder = 4 }, {
			Action = props.headerAction
		})
	end

	local translationToggle3

	if not FFlagMomentsCommentRowRedesign then
		translationToggle3 = translationToggle2
	end

	local children2 = {
		Header = createElement6(view6, v10, {
			Author = author,
			Separator = separator,
			Timestamp = timestamp,
			HeaderAction = headerAction,
			TranslationToggle = translationToggle3
		}),
		Body = 0,
		BodyMeasure = 0
	}

	local createElement7 = React.createElement
	local text = Foundation.Text
	local v11 = {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
		LayoutOrder = 2,
		Text = props.bodyText or props.text,
		RichText = props.bodyText ~= nil,
		textStyle = 0,
		ref = 0,
		onAbsoluteSizeChanged = 0,
		testId = 0
	}
	local textStyle = props.bodyTextStyle

	if not textStyle then
		if FFlagMomentsCommentRowRedesign then
			textStyle = v.Color.Content.Default
		else
			textStyle = v.Color.Content.Emphasis
		end
	end

	v11.textStyle = textStyle

	v11.ref = props.bodyRef
	v11.onAbsoluteSizeChanged = props.onBodyAbsoluteSizeChanged
	v11.testId = `moments-comment-body-{props.commentId}`
	children2.Body = createElement7(text, v11)
	local bodyMeasure

	if props.bodyMeasureRef ~= nil then
		bodyMeasure = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			LayoutOrder = 3,
			RichText = true,
			Visible = false,
			ref = props.bodyMeasureRef,
			testId = `moments-comment-body-measure-{props.commentId}`
		})
	end

	children2.BodyMeasure = bodyMeasure
	local v12 = {
		MainContent = createElement5(view5, v8, children2),
		Reaction = 0,
		Footer = 0
	}
	local reaction

	if not (FFlagMomentsCommentRowRedesign or not props.showReactionControl) then
		reaction = React.createElement(CommentReactionButton, {
			commentId = props.commentId,
			isReactionSelected = props.isReactionSelected == true,
			isReactionDisabled = props.isReactionDisabled == true,
			reactionCountLabel = props.reactionCountLabel or "0",
			isReactionCountHidden = props.isReactionCountHidden,
			onReactionActivated = props.onReactionActivated or noop,
			LayoutOrder = 2
		})
	end

	v12.Reaction = reaction
	local footer

	if
		FFlagMomentsCommentRowRedesign
		and (props.metadataLabel ~= nil or props.headerAction ~= nil or props.showReactionControl or translationToggle ~= nil)
	then
		local createElement8 = React.createElement
		local view7 = Foundation.View
		local v9 = {
			tag = "row align-y-center gap-small size-full-0 auto-y",
			LayoutOrder = 2,
			testId = `moments-comment-footer-{props.commentId}`
		}

		local createElement9 = React.createElement
		local view8 = Foundation.View
		local v13 = {
			tag = {
				["row align-y-center fill gap-small auto-y clip"] = true,
				wrap = translationToggle ~= nil
			},
			LayoutOrder = 1,
			testId = `moments-comment-footer-metadata-{props.commentId}`
		}
		local timestamp2

		if props.metadataLabel ~= nil then
			timestamp2 = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-small text-truncate-end content-muted",
				LayoutOrder = 1,
				Text = props.metadataLabel,
				testId = `moments-comment-timestamp-{props.commentId}`
			})
		end

		local headerAction2

		if props.headerAction ~= nil then
			headerAction2 = React.createElement(Foundation.View, {
				tag = "auto-xy",
				LayoutOrder = 2
			}, {
				Action = props.headerAction
			})
		end

		local v14 = {
			Metadata = createElement9(view8, v13, {
				Timestamp = timestamp2,
				HeaderAction = headerAction2,
				TranslationToggle = translationToggle2
			}),
			Reaction = 0
		}
		local reaction2

		if props.showReactionControl then
			reaction2 = React.createElement(CommentReactionButton, {
				commentId = props.commentId,
				isReactionSelected = props.isReactionSelected == true,
				isReactionDisabled = props.isReactionDisabled == true,
				reactionCountLabel = props.reactionCountLabel or "0",
				isReactionCountHidden = props.isReactionCountHidden,
				onReactionActivated = props.onReactionActivated or noop,
				LayoutOrder = 2
			})
		end

		v14.Reaction = reaction2
		footer = createElement8(view7, v9, v14)
	end

	v12.Footer = footer
	children.TextColumn = createElement4(view4, v7, v12)
	local actionsMenu2

	if not (actionsMenu == nil or v2) then
		actionsMenu2 = React.createElement(CommentActionsMenu, {
			commentId = props.commentId,
			items = actionsMenu.items,
			isOpen = actionsMenu.isOpen,
			onButtonActivated = actionsMenu.onButtonActivated,
			onClose = actionsMenu.onClose,
			LayoutOrder = 3
		})
	end

	children.ActionsMenu = actionsMenu2
	local v9 = {
		Highlight = highlight,
		Content = createElement2(view2, v5, children),
		RowActionsMenu = 0,
		DeleteConfirmation = 0
	}
	local rowActionsMenu

	if not (actionsMenu == nil or not v2 or state == nil) then
		rowActionsMenu = React.createElement(CommentActionsMenu, {
			commentId = props.commentId,
			items = actionsMenu.items,
			isOpen = actionsMenu.isOpen,
			anchorRef = anchorRef,
			onButtonActivated = actionsMenu.onButtonActivated,
			onClose = actionsMenu.onClose
		})
	end

	v9.RowActionsMenu = rowActionsMenu
	local deleteConfirmation2

	if deleteConfirmation ~= nil then
		deleteConfirmation2 = React.createElement(CommentDeleteConfirmationDialog, {
			commentId = props.commentId,
			onConfirm = deleteConfirmation.onConfirm,
			onCancel = deleteConfirmation.onCancel
		})
	end

	v9.DeleteConfirmation = deleteConfirmation2
	return createElement(view, v4, v9)
end

return CommentRowView
