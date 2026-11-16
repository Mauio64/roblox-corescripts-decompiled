local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local musicNote = BuilderIcons.Icon.MusicNote
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local FFlagMomentsCreationMusicChipRemoveButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicChipRemoveButton")
local useMusicInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useMusicInfo")

local function MusicChip(props)
	local v5 = useMusicInfo(props.musicAssetId)
	local v6 = if FFlagMomentsCreationMusicChipRemoveButton then useTokens() else nil

	local v7 = FFlagMomentsCreationMusicChipRemoveButton and {
		["row align-x-center align-y-center gap-medium size-0-800 auto-x padding-y-xsmall radius-circle bg-over-media-0"] = true,
		["padding-x-medium"] = props.onRemove == nil,
		["padding-left-medium padding-right-small"] = props.onRemove ~= nil
	} or "row align-x-center align-y-center gap-medium size-0-800 auto-x padding-x-medium padding-y-xsmall radius-circle bg-over-media-0"

	local createElement = React.createElement
	local v9 = { tag = v7, LayoutOrder = 1, onActivated = props.onActivated }
	local v10 = {
		Icon = React.createElement(icon, {
			name = musicNote,
			LayoutOrder = 1,
			size = Foundation.Enums.IconSize.Small
		}),
		MusicTitle = React.createElement(text, {
			tag = "auto-xy text-caption-medium text-align-x-left text-align-y-center text-truncate-split content-action-standard",
			sizeConstraint = { MaxSize = Vector2.new(100, 1e999) },
			LayoutOrder = 2,
			Text = v5 and v5.Title or ""
		}),
		RemoveButton = 0
	}

	local v11 = if FFlagMomentsCreationMusicChipRemoveButton and props.onRemove then React.createElement(view, {
		backgroundStyle = { Color3 = Color3.new(0, 0, 0) },
		LayoutOrder = 3,
		onActivated = props.onRemove,
		stroke = {
			Color = v6.Color.Stroke.Default.Color3,
			Transparency = v6.Color.Stroke.Default.Transparency,
			Thickness = v6.Stroke.Standard
		},
		tag = "align-x-center align-y-center size-500-500 radius-circle",
		testId = "music-chip-remove-button"
	}, {
		RemoveIcon = React.createElement(icon, {
			name = iconName.X,
			size = iconSize.XSmall,
			style = v6.Color.Content.Emphasis,
			testId = "music-chip-remove-button-icon"
		})
	}) else nil
	v10.RemoveButton = v11
	return createElement(view, v9, v10)
end

return MusicChip
