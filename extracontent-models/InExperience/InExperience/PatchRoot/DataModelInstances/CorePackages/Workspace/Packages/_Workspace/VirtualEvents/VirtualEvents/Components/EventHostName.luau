local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
require(VirtualEvents.Parent.VirtualEventsState)

local useStyle = UIBlox.Core.Style.useStyle
local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji

local function EventHostName(p)
	local v = useStyle()
	local verified

	if p.host.hasVerifiedBadge then
		verified = Emoji.Verified
	end

	local state, setState = React.useState(0)

	local v2 = React.useCallback(function(p2)
		setState(p2.TextSize)
	end, { setState })

	local createElement = React.createElement
	local v3 = { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY }
	local children = {
		Layout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UserImage = 0,
		EmojiName = 0,
		EmojiToArrowMargin = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		BackgroundColor3 = v.Theme.Badge.Color,
		BackgroundTransparency = v.Theme.Badge.Transparency,
		Image = string.format(
			"rbxthumb://type=%s&id=%i&w=150&h=150",
			p.host.hostType == "group" and "GroupIcon" or "AvatarHeadShot",
			p.host.hostId
		),
		Size = 0
	}
	local size

	if p.changeHostImageSize then
		size = UDim2.fromOffset(32, 32)
	else
		size = UDim2.fromOffset(state, state)
	end

	v4.Size = size
	children.UserImage = createElement2("ImageLabel", v4, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})

	children.EmojiName = React.createElement(EmojiTextLabel, {
		Text = p.host.hostName,
		LayoutOrder = 2,
		emoji = verified,
		fontStyle = v.Font.Header2,
		colorStyle = v.Theme.TextEmphasis,
		[React.Change.AbsoluteSize] = v2
	})
	local emojiToArrowMargin

	if verified then
		emojiToArrowMargin = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(state - 4, 0)
		})
	end

	children.EmojiToArrowMargin = emojiToArrowMargin
	return createElement("Frame", v3, children)
end

return EventHostName
