local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local MusicNote = BuilderIcons.Icon.MusicNote
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)

local function MusicChip(t1: {[any]: any}) -- line: 29
	-- upvalues: useMusicInfo (copy), React (copy), View (copy), Icon (copy), MusicNote (copy), Foundation (copy), FoundationText (copy)
	local v13 = useMusicInfo(t1.musicAssetId)

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-medium size-0-800 auto-x padding-x-medium padding-y-xsmall radius-circle bg-over-media-0",
		LayoutOrder = 1,
		onActivated = t1.onActivated
	}, {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = MusicNote,
			size = Foundation.Enums.IconSize.Small
		}),
		MusicTitle = React.createElement(FoundationText, {
			tag = "auto-xy text-caption-medium text-align-x-left text-align-y-center text-truncate-split content-action-standard",
			LayoutOrder = 2,
			sizeConstraint = {
				MaxSize = Vector2.new(100, 1e999)
			},
			Text = v13 and v13.Title or ""
		})
	})
end

return MusicChip
