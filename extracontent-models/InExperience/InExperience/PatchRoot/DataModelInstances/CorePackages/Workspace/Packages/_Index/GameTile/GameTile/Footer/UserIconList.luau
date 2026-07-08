local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local Roact = require(GameTileParent.Roact)
local ImageSetLabel = require(GameTileParent.UIBlox).Core.ImageSet.ImageSetLabel
local GetImageData = require(GameTileParent.RobloxAppAssets).GetImageData
local FriendIcon = require(GameTile.Footer.FriendIcon)
local SourceSans = Enum.Font.SourceSans
local color3 = Color3.fromRGB(117, 117, 117)

local function NumberedIcon(p1) -- line: 22
	-- upvalues: Roact (copy), ImageSetLabel (copy), GetImageData (copy), SourceSans (copy), color3 (copy)
	local size = p1.size
	local layoutOrder = p1.layoutOrder
	local count = p1.count

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, size, 0, size),
		LayoutOrder = layoutOrder,
		Image = GetImageData("LuaApp/graphic/gr-counter-slot-32x32") or "LuaApp/graphic/gr-counter-slot-32x32"
	}, {
		Count = Roact.createElement("TextLabel", {
			TextSize = 15,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Font = SourceSans,
			Text = "+" .. count,
			TextColor3 = color3
		})
	})
end

local v10 = Roact.PureComponent:extend("UserIconList")

v10.defaultProps = {
	users = {}
}

function v10.render(p2) -- line: 52
	-- upvalues: Roact (copy), FriendIcon (copy), NumberedIcon (copy)
	local width = p2.props.width
	local height = p2.props.height
	local layoutOrder = p2.props.layoutOrder
	local users = p2.props.users
	local v20 = #users
	local n1 = 0
	local maskColor = p2.props.maskColor

	if v20 <= 0 then
		return nil
	end

	local function GetMaxNumberOfIconsInWidth(p3, p4) -- line: 65
		return (math.floor((p4 + 3) / (p3 + 3)))
	end

	local v24 = if not (height >= 32) or not (math.floor((width + 3) / 35) >= 3) then if not (height >= 24) then height else 24 else 32
	local t1 = {}
	local v26 = math.floor((width + 3) / (v24 + 3))

	if v26 > 0 then
		if v26 < v20 then
			n1 = v20 - (v26 - 1)
		end

		t1.ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 3)
		})

		for i = 1, n1 > 0 and v26 - 1 or math.min(v26, v20) do
			local v28 = users[i]

			t1["UserIcon" .. i] = Roact.createElement(FriendIcon, {
				user = v28,
				itemSize = v24,
				layoutOrder = i,
				maskColor = maskColor
			})
		end

		t1.NumberedIcon = n1 > 0 and Roact.createElement(NumberedIcon, {
			size = v24,
			layoutOrder = v26,
			count = n1
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, width, 0, height),
		LayoutOrder = layoutOrder
	}, t1)
end

return v10
