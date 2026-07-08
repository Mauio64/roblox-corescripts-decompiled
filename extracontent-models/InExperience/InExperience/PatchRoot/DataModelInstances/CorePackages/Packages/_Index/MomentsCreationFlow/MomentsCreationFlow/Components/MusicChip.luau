local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local React = require(MomentsCreationFlowParent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local MusicNote = BuilderIcons.Icon.MusicNote
local useMusicInfo = require(MomentsCreationFlow.Hooks.useMusicInfo)

local function MusicChip(t1: {[any]: any}) -- line: 23
	-- upvalues: useMusicInfo (copy), React (copy), View (copy), Icon (copy), MusicNote (copy), Foundation (copy), FoundationText (copy)
	local v13 = useMusicInfo(t1.musicAssetId)

	return React.createElement(View, {
		tag = "align-x-center align-y-center auto-x bg-over-media-0 gap-medium padding-x-medium padding-y-xsmall radius-circle row size-0-800",
		LayoutOrder = 1,
		onActivated = t1.onActivated
	}, {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = MusicNote,
			size = Foundation.Enums.IconSize.Small
		}),
		MusicTitle = React.createElement(FoundationText, {
			tag = "auto-xy content-action-standard text-align-x-left text-align-y-center text-caption-medium text-truncate-split",
			LayoutOrder = 2,
			sizeConstraint = {
				MaxSize = Vector2.new(100, 1e999)
			},
			Text = v13.Title
		})
	})
end

return MusicChip
