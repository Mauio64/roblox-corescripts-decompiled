local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Reaction = require(Reactions.Components.Reaction)
require(Reactions.Enums.ReactionType)
local abbreviateReactionCount = require(Reactions.Utils.abbreviateReactionCount)
local getTopReactions = require(Reactions.Utils.getTopReactions)

local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType

local function ReactionChip(props)
	local v = useTokens()
	local testId = props.testId or "reaction-chip"

	local v2 = React.useMemo(function()
		return getTopReactions(props.reactionCounts, 3)
	end, { props.reactionCounts })

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v.Radius.Circle),
			offset = v.Size.Size_150,
			borderWidth = v.Stroke.Thicker
		}
	end, { v })

	if v2.totalCount <= 0 then
		return nil
	end

	local udim = UDim2.fromOffset(v.Size.Size_400, v.Size.Size_400)
	local v3

	if props.userIds == nil then
		v3 = false
	else
		v3 = #props.userIds > 0
	end

	local children = {}

	for k, reaction in v2.reactions do
		children[reaction] = React.createElement(Reaction, {
			reactionType = reaction,
			Size = udim,
			LayoutOrder = k,
			testId = `{testId}--reaction`
		})
	end

	if v3 then
		local userIds = props.userIds

		for i = 1, math.min(2, #userIds) do
			children[`Avatar{i}`] = React.createElement(Image, {
				Image = getRbxThumb(ThumbnailType.AvatarHeadShot, userIds[i], ThumbnailSize.Small),
				tag = "size-400-400 radius-circle bg-shift-300",
				LayoutOrder = i + 3,
				testId = `{testId}--avatar`
			})
		end
	elseif v2.totalCount > 1 then
		local localizeCount = props.localizeCount or abbreviateReactionCount
		children.Count = React.createElement(Text, {
			Text = localizeCount(v2.totalCount),
			tag = "auto-xy text-label-medium content-emphasis",
			LayoutOrder = 4,
			testId = `{testId}--count`
		})
	end

	local createElement = React.createElement
	local v4 = {
		tag = "size-0-800 auto-x padding-xxsmall radius-circle",
		backgroundStyle = props.borderStyle or v.Color.Surface.Surface_0,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v5 = {
		tag = "row align-y-center gap-xsmall size-0-full auto-x padding-x-small radius-circle bg-surface-300",
		onActivated = props.onActivated,
		cursor = 0,
		testId = 0
	}

	if not props.onActivated then
		cursor = nil
	end

	v5.cursor = cursor
	v5.testId = testId
	return createElement(View, v4, {
		Chip = createElement2(View, v5, children)
	})
end

return ReactionChip
