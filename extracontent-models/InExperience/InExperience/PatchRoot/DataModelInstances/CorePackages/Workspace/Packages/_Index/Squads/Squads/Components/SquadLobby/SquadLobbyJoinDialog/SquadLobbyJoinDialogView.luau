local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Constants = require(Squads.Common.Constants)

local Dialog = Foundation.Dialog
local AvatarSize = Foundation.Enums.AvatarSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local function SquadLobbyJoinDialogView(props)
	local v = {
		text = props.joinText,
		variant = ButtonVariant.Emphasis,
		onActivated = props.onJoin
	}

	local createElement = React.createElement
	local overlayProvider = Foundation.OverlayProvider
	local v2 = { DisplayOrder = Constants.SQUAD_LOBBY_MODAL_DISPLAY_ORDER }

	local createElement2 = React.createElement
	local root = Dialog.Root
	local v3 = {
		ref = props.dialogRef,
		size = DialogSize.Small,
		disablePortal = props.disablePortal ~= nil and props.disablePortal,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onClose,
		testId = props.testId
	}
	local heroMedia

	if props.gameImage then
		heroMedia = React.createElement(Dialog.HeroMedia, {
			media = props.gameImage,
			aspectRatio = 16 / 9,
			scaleType = Enum.ScaleType.Crop
		})
	end

	local createElement3 = React.createElement
	local content = Dialog.Content

	local createElement4 = React.createElement
	local view = Foundation.View

	local createElement5 = React.createElement
	local view2 = Foundation.View

	local v4 = {
		Avatar = React.createElement(Foundation.Avatar, {
			userId = props.userId,
			size = AvatarSize.Medium,
			LayoutOrder = 1,
			testId = `{props.testId}--avatar`
		}),
		TextColumn = 0
	}

	local createElement6 = React.createElement
	local view3 = Foundation.View
	local playerName

	if props.playerName then
		playerName = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
			Text = props.playerName,
			LayoutOrder = 1,
			testId = `{props.testId}--player-name`
		})
	end

	v4.TextColumn = createElement6(view3, {
		tag = "col shrink gap-xxsmall size-full-0 auto-y",
		LayoutOrder = 2
	}, {
		PlayerName = playerName,
		PlayingRow = React.createElement(
			Foundation.View,
			{ tag = "row align-y-center gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
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
	})
	local v5 = {
		PlayerRow = createElement5(
			view2,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			v4
		),
		Rating = 0
	}
	local rating

	if props.rating then
		rating = React.createElement(
			Foundation.View,
			{ tag = "auto-xy", LayoutOrder = 2, testId = `{props.testId}--rating` },
			props.rating
		)
	end

	v5.Rating = rating
	return createElement(overlayProvider, v2, {
		Dialog = createElement2(root, v3, {
			HeroMedia = heroMedia,
			Content = createElement3(content, { LayoutOrder = 2 }, {
				Details = createElement4(view, { tag = "col gap-medium size-full-0 auto-y" }, v5)
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				orientation = Orientation.Vertical,
				actions = props.viewProfileText and props.onViewProfile and {
					v,
					{
						text = props.viewProfileText,
						variant = ButtonVariant.Standard,
						onActivated = props.onViewProfile
					}
				} or { v }
			})
		})
	})
end

return SquadLobbyJoinDialogView
