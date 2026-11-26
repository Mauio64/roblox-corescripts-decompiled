local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Roact")
local imageSetLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox").Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppAssets").GetImageData
local FriendIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/FriendIcon")

local sourceSans = Enum.Font.SourceSans
local color = Color3.fromRGB(117, 117, 117)

local function NumberedIcon(props)
	local size = props.size
	local layoutOrder = props.layoutOrder
	local count = props.count

	return Roact.createElement(imageSetLabel, {
		Size = UDim2.new(0, size, 0, size),
		LayoutOrder = layoutOrder,
		Image = getImageData("LuaApp/graphic/gr-counter-slot-32x32") or "LuaApp/graphic/gr-counter-slot-32x32",
		BackgroundTransparency = 1
	}, {
		Count = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Font = sourceSans,
			TextSize = 15,
			Text = "+" .. count,
			TextColor3 = color,
			BackgroundTransparency = 1
		})
	})
end

local extended = Roact.PureComponent:extend("UserIconList")

extended.defaultProps = { users = {} }

function extended.render(p2)
	local width = p2.props.width
	local height = p2.props.height
	local layoutOrder = p2.props.layoutOrder
	local users = p2.props.users
	local count = #users
	local v5 = 0
	local maskColor = p2.props.maskColor

	if count <= 0 then
		return nil
	end

	local function GetMaxNumberOfIconsInWidth(p3, p4)
		return (math.floor((p4 + 3) / (p3 + 3)))
	end
	local v6 = height >= 32 and math.floor((width + 3) / 35) >= 3 and 32 or height >= 24 and 24 or height

	local children = {}
	local v7 = math.floor((width + 3) / (v6 + 3))

	if v7 > 0 then
		if v7 < count then
			v5 = count - (v7 - 1)
		end

		children.ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 3)
		})

		for i = 1, v5 > 0 and v7 - 1 or math.min(v7, count) do
			local user = users[i]
			children["UserIcon" .. i] = Roact.createElement(FriendIcon, {
				user = user,
				itemSize = v6,
				layoutOrder = i,
				maskColor = maskColor
			})
		end

		children.NumberedIcon = v5 > 0
			and Roact.createElement(NumberedIcon, {
				size = v6,
				layoutOrder = v7,
				count = v5
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
