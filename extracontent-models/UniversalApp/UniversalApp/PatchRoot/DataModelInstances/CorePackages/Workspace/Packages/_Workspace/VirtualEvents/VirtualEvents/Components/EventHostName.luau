local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)

require(VirtualEvents.Parent.VirtualEventsState)

local useStyle = UIBlox.Core.Style.useStyle
local EmojiTextLabel = UIBlox.Core.Text.EmojiTextLabel
local Emoji = UIBlox.App.Emoji.Enum.Emoji

local function EventHostName(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), Emoji (copy), React (copy), EmojiTextLabel (copy)
	local v9 = useStyle()
	local v10 = if not t1.host.hasVerifiedBadge then nil else Emoji.Verified
	local v11, v12 = React.useState(0)
	local v13 = React.useCallback(function(p1) -- line: 25
		-- upvalues: v12 (copy)
		v12(p1.TextSize)
	end, { v12 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UserImage = React.createElement("ImageLabel", {
			LayoutOrder = 1,
			BackgroundColor3 = v9.Theme.Badge.Color,
			BackgroundTransparency = v9.Theme.Badge.Transparency,
			Image = string.format("rbxthumb://type=%s&id=%i&w=150&h=150", t1.host.hostType ~= "group" and "AvatarHeadShot" or "GroupIcon", t1.host.hostId),
			Size = if not t1.changeHostImageSize then UDim2.fromOffset(v11, v11) else UDim2.fromOffset(32, 32)
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		EmojiName = React.createElement(EmojiTextLabel, {
			Text = t1.host.hostName,
			LayoutOrder = 2,
			emoji = v10,
			fontStyle = v9.Font.Header2,
			colorStyle = v9.Theme.TextEmphasis,
			[React.Change.AbsoluteSize] = v13
		}),
		EmojiToArrowMargin = if not v10 then nil else React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v11 - 4, 0)
		})
	})
end

return EventHostName
