local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local MusicNote = BuilderIcons.Icon.MusicNote
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local FFlagMomentsCreationMusicChipRemoveButton = require(MomentsCreation.Flags.FFlagMomentsCreationMusicChipRemoveButton)
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)

local function MusicChip(props)
	local v = useMusicInfo(props.musicAssetId)
	local v2

	if FFlagMomentsCreationMusicChipRemoveButton then
		v2 = useTokens()
	end

	local tag = FFlagMomentsCreationMusicChipRemoveButton and {
		["row align-x-center align-y-center gap-medium size-0-800 auto-x padding-y-xsmall radius-circle bg-over-media-0"] = true,
		["padding-x-medium"] = props.onRemove == nil,
		["padding-left-medium padding-right-small"] = props.onRemove ~= nil
	} or "row align-x-center align-y-center gap-medium size-0-800 auto-x padding-x-medium padding-y-xsmall radius-circle bg-over-media-0"

	local createElement = React.createElement
	local v3 = { tag = tag, LayoutOrder = 1, onActivated = props.onActivated }
	local v4 = {
		Icon = React.createElement(Icon, {
			name = MusicNote,
			LayoutOrder = 1,
			size = Foundation.Enums.IconSize.Small
		}),
		MusicTitle = React.createElement(Text, {
			tag = "auto-xy text-caption-medium text-align-x-left text-align-y-center text-truncate-split content-action-standard",
			sizeConstraint = { MaxSize = Vector2.new(100, 1e999) },
			LayoutOrder = 2,
			Text = v and v.Title or ""
		}),
		RemoveButton = 0
	}
	local removeButton

	if FFlagMomentsCreationMusicChipRemoveButton and props.onRemove then
		removeButton = React.createElement(View, {
			backgroundStyle = { Color3 = Color3.new(0, 0, 0) },
			LayoutOrder = 3,
			onActivated = props.onRemove,
			stroke = {
				Color = v2.Color.Stroke.Default.Color3,
				Transparency = v2.Color.Stroke.Default.Transparency,
				Thickness = v2.Stroke.Standard
			},
			tag = "align-x-center align-y-center size-500-500 radius-circle",
			testId = "music-chip-remove-button"
		}, {
			RemoveIcon = React.createElement(Icon, {
				name = IconName.X,
				size = IconSize.XSmall,
				style = v2.Color.Content.Emphasis,
				testId = "music-chip-remove-button-icon"
			})
		})
	end

	v4.RemoveButton = removeButton
	return createElement(View, v3, v4)
end

return MusicChip
