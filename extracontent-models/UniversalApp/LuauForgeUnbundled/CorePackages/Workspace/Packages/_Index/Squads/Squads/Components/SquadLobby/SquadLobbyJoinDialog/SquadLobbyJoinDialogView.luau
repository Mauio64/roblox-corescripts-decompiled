local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/Constants")

local dialog = Foundation.Dialog
local avatarSize = Foundation.Enums.AvatarSize
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local function SquadLobbyJoinDialogView(props)
	local v5 = {
		text = props.joinText,
		variant = buttonVariant.Emphasis,
		onActivated = props.onJoin
	}

	local createElement = React.createElement
	local overlayProvider = Foundation.OverlayProvider
	local v6 = { DisplayOrder = Constants.SQUAD_LOBBY_MODAL_DISPLAY_ORDER }

	local createElement2 = React.createElement
	local root = dialog.Root
	local v8 = {
		ref = props.dialogRef,
		size = dialogSize.Small,
		disablePortal = props.disablePortal ~= nil and props.disablePortal,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onClose,
		testId = props.testId
	}

	local v10 = if props.gameImage then React.createElement(dialog.HeroMedia, {
		media = props.gameImage,
		aspectRatio = 16 / 9,
		scaleType = Enum.ScaleType.Crop
	}) else nil

	local createElement3 = React.createElement
	local content = dialog.Content

	local createElement4 = React.createElement
	local view = Foundation.View

	local createElement5 = React.createElement
	local view2 = Foundation.View

	local v16 = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = props.userId,
			size = avatarSize.Medium,
			LayoutOrder = 1,
			testId = `{props.testId}--avatar`
		}),
		TextColumn = 0
	}

	local createElement6 = React.createElement
	local view3 = Foundation.View

	local v19 = if props.playerName then React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
		Text = props.playerName,
		LayoutOrder = 1,
		testId = `{props.testId}--player-name`
	}) else nil
	v16.TextColumn = createElement6(
		view3,
		{ tag = "col shrink gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
		{
			PlayerName = v19,
			PlayingRow = React.createElement(
				Foundation.View,
				{
					tag = "row align-y-center gap-xsmall size-full-0 auto-y",
					LayoutOrder = 2
				},
				{
					IsPlaying = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-medium text-no-wrap content-default",
						Text = props.isPlayingText,
						LayoutOrder = 1
					}),
					ExperienceName = React.createElement(Foundation.Text, {
						tag = "shrink auto-xy text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
						Text = props.experienceName,
						LayoutOrder = 2,
						testId = `{props.testId}--experience-name`
					})
				}
			)
		}
	)
	local v14 = {
		PlayerRow = createElement5(
			view2,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				LayoutOrder = 1
			},
			v16
		),
		Rating = 0
	}

	local v20 = if props.rating then React.createElement(
		Foundation.View,
		{ tag = "auto-xy", LayoutOrder = 2, testId = `{props.testId}--rating` },
		props.rating
	) else nil
	v14.Rating = v20
	return createElement(overlayProvider, v6, {
		Dialog = createElement2(root, v8, {
			HeroMedia = v10,
			Content = createElement3(content, { LayoutOrder = 2 }, {
				Details = createElement4(view, {
					tag = "col gap-medium size-full-0 auto-y"
				}, v14)
			}),
			Actions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				orientation = orientation.Vertical,
				actions = props.viewProfileText and props.onViewProfile and {
					v5,
					{
						text = props.viewProfileText,
						variant = buttonVariant.Standard,
						onActivated = props.onViewProfile
					}
				} or { v5 }
			})
		})
	})
end

return SquadLobbyJoinDialogView
