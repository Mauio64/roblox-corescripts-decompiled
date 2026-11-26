local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local useStyle = UIBlox.Core.Style.useStyle
local emojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local emoji = UIBlox.App.Emoji.Enum.Emoji

local function EventHostName(p2)
	local v5 = useStyle()
	local verified = if p2.host.hasVerifiedBadge then emoji.Verified else nil

	local state, setState = React.useState(0)

	local v6 = React.useCallback(function(p3)
		setState(p3.TextSize)
	end, { setState })

	local createElement = React.createElement
	local v8 = { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY }
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
	local v10 = {
		LayoutOrder = 1,
		BackgroundColor3 = v5.Theme.Badge.Color,
		BackgroundTransparency = v5.Theme.Badge.Transparency,
		Image = string.format(
			"rbxthumb://type=%s&id=%i&w=150&h=150",
			p2.host.hostType == "group" and "GroupIcon" or "AvatarHeadShot",
			p2.host.hostId
		),
		Size = 0
	}

	local v11 = if p2.changeHostImageSize then UDim2.fromOffset(32, 32) else UDim2.fromOffset(state, state)
	v10.Size = v11
	children.UserImage = createElement2("ImageLabel", v10, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})

	children.EmojiName = React.createElement(emojiTextLabel, {
		Text = p2.host.hostName,
		LayoutOrder = 2,
		emoji = verified,
		fontStyle = v5.Font.Header2,
		colorStyle = v5.Theme.TextEmphasis,
		[React.Change.AbsoluteSize] = v6
	})

	local v14 = if verified then React.createElement("Frame", {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(state - 4, 0)
	}) else nil
	children.EmojiToArrowMargin = v14
	return createElement("Frame", v8, children)
end

return EventHostName
