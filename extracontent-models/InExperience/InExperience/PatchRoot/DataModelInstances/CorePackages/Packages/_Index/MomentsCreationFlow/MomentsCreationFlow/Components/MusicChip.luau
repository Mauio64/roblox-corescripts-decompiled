local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local MusicNote = BuilderIcons.Icon.MusicNote

local useMusicInfo = require(MomentsCreationFlow.Hooks.useMusicInfo)

local function MusicChip(p)
	local v = useMusicInfo(p.musicAssetId)

	return React.createElement(
		View,
		{
			tag = "align-x-center align-y-center auto-x bg-over-media-0 gap-medium padding-x-medium padding-y-xsmall radius-circle row size-0-800",
			LayoutOrder = 1,
			onActivated = p.onActivated
		},
		{
			Icon = React.createElement(Icon, {
				name = MusicNote,
				LayoutOrder = 1,
				size = Foundation.Enums.IconSize.Small
			}),
			MusicTitle = React.createElement(Text, {
				tag = "auto-xy content-action-standard text-align-x-left text-align-y-center text-caption-medium text-truncate-split",
				sizeConstraint = { MaxSize = Vector2.new(100, 1e999) },
				LayoutOrder = 2,
				Text = v.Title
			})
		}
	)
end

return MusicChip
