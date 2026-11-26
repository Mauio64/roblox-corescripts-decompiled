local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

local Reaction = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/Reaction")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local abbreviateReactionCount = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/abbreviateReactionCount")
local getTopReactions = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/getTopReactions")

local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailSize = Foundation.Enums.ThumbnailSize
local thumbnailType = Foundation.Enums.ThumbnailType

local function ReactionChip(props)
	local v5 = useTokens()
	local testId = props.testId or "reaction-chip"

	local v6 = React.useMemo(function()
		return getTopReactions(props.reactionCounts, 3)
	end, { props.reactionCounts })

	local v7 = React.useMemo(function()
		return {
			radius = UDim.new(0, v5.Radius.Circle),
			offset = v5.Size.Size_150,
			borderWidth = v5.Stroke.Thicker
		}
	end, { v5 })

	if v6.totalCount <= 0 then
		return nil
	end

	local udim = UDim2.fromOffset(v5.Size.Size_400, v5.Size.Size_400)
	local v8 = not (props.userIds == nil) and #props.userIds > 0
	local children = {}

	for k, reaction in v6.reactions do
		children[reaction] = React.createElement(Reaction, {
			reactionType = reaction,
			Size = udim,
			LayoutOrder = k,
			testId = `{testId}--reaction`
		})
	end

	if v8 then
		local userIds = props.userIds

		for i = 1, math.min(2, #userIds) do
			children[`Avatar{i}`] = React.createElement(image, {
				Image = getRbxThumb(thumbnailType.AvatarHeadShot, userIds[i], thumbnailSize.Small),
				tag = "size-400-400 radius-circle bg-shift-300",
				LayoutOrder = i + 3,
				testId = `{testId}--avatar`
			})
		end
	elseif v6.totalCount > 1 then
		local localizeCount = props.localizeCount or abbreviateReactionCount
		children.Count = React.createElement(text, {
			Text = localizeCount(v6.totalCount),
			tag = "auto-xy text-label-medium content-emphasis",
			LayoutOrder = 4,
			testId = `{testId}--count`
		})
	end

	local createElement = React.createElement
	local v10 = {
		tag = "size-0-800 auto-x padding-xxsmall radius-circle",
		backgroundStyle = props.borderStyle or v5.Color.Surface.Surface_0,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v13 = {
		tag = "row align-y-center gap-xsmall size-0-full auto-x padding-x-small radius-circle bg-surface-300",
		onActivated = props.onActivated,
		cursor = 0,
		testId = 0
	}

	if not props.onActivated then
		v7 = nil
	end

	v13.cursor = v7
	v13.testId = testId
	return createElement(view, v10, {
		Chip = createElement2(view, v13, children)
	})
end

return ReactionChip
