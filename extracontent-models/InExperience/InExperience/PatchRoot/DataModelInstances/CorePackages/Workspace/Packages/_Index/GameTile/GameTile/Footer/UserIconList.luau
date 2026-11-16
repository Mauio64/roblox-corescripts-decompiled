local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local FriendIcon = require(GameTile.Footer.FriendIcon)

local SourceSans = Enum.Font.SourceSans
local color = Color3.fromRGB(117, 117, 117)

local function NumberedIcon(props)
	local size = props.size
	local layoutOrder = props.layoutOrder
	local count = props.count

	return Roact.createElement(ImageSetLabel, {
		Size = UDim2.new(0, size, 0, size),
		LayoutOrder = layoutOrder,
		Image = GetImageData("LuaApp/graphic/gr-counter-slot-32x32") or "LuaApp/graphic/gr-counter-slot-32x32",
		BackgroundTransparency = 1
	}, {
		Count = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Font = SourceSans,
			TextSize = 15,
			Text = "+" .. count,
			TextColor3 = color,
			BackgroundTransparency = 1
		})
	})
end

local extended = Roact.PureComponent:extend("UserIconList")

extended.defaultProps = { users = {} }

function extended.render(p)
	local width = p.props.width
	local height = p.props.height
	local layoutOrder = p.props.layoutOrder
	local users = p.props.users
	local count = #users
	local count2 = 0
	local maskColor = p.props.maskColor

	if count <= 0 then
		return nil
	end

	local function GetMaxNumberOfIconsInWidth(p2, width2) -- 2 equivalent calls inferred from this helper
		return (math.floor((width2 + 3) / (p2 + 3)))
	end

	local v = height >= 32 and GetMaxNumberOfIconsInWidth(32, width) >= 3 and 32 or height >= 24 and 24 or height -- inferred equivalent call
	local children = {}
	local layoutOrder2 = GetMaxNumberOfIconsInWidth(v, width) -- inferred equivalent call

	if layoutOrder2 > 0 then
		if layoutOrder2 < count then
			count2 = count - (layoutOrder2 - 1)
		end

		children.ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 3)
		})

		for i = 1, count2 > 0 and layoutOrder2 - 1 or math.min(layoutOrder2, count) do
			local user = users[i]
			children["UserIcon" .. i] = Roact.createElement(FriendIcon, {
				user = user,
				itemSize = v,
				layoutOrder = i,
				maskColor = maskColor
			})
		end

		children.NumberedIcon = count2 > 0
			and Roact.createElement(NumberedIcon, {
				size = v,
				layoutOrder = layoutOrder2,
				count = count2
			})
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, width, 0, height),
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1
		},
		children
	)
end

return extended
