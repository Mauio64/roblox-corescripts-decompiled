local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local memoize = require(Modules.Common.memoize)
local sortFriendsByPresenceAndRecency = require(Modules.LuaApp.sortFriendsByPresenceAndRecency)
local Constants = require(Modules.LuaApp.Constants)
local JoinableFriendEntry = require(Modules.LuaApp.Components.Home.JoinableFriendEntry)
local v8 = Constants.PlacesList.ContextualMenu.HorizontalOuterPadding + Constants.PlacesList.ContextualMenu.AvatarSize + Constants.PlacesList.ContextualMenu.HorizontalInnerPadding
local v9 = Roact.PureComponent:extend("JoinableFriendsList")

local function CreateDivider(p1) -- line: 19
	-- upvalues: Roact (copy), v8 (copy), Constants (copy)
	local layoutOrder = p1.layoutOrder

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = layoutOrder
	}, {
		BottomDivider = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, -v8, 1, 0),
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Constants.Color.GRAY4
		})
	})
end

v9.defaultProps = {
	layoutOrder = 0
}

function v9.init(p2) -- line: 42
	p2.state = {
		friends = p2.props.friends
	}
end
function v9.render(p3) -- line: 52
	-- upvalues: Roact (copy), JoinableFriendEntry (copy), CreateDivider (copy), Constants (copy)
	local propsLayoutOrder = p3.props.LayoutOrder
	local maxHeight = p3.props.maxHeight
	local width = p3.props.width
	local universeId = p3.props.universeId
	local v20 = p3.state.friends or {}
	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for i, v in ipairs(v20) do
		local v24 = i * 2
		local v25 = i < #v20

		t1["Entry_" .. v.id] = Roact.createElement(JoinableFriendEntry, {
			entryHeight = 67,
			user = v,
			layoutOrder = v24,
			entryWidth = width,
			universeId = universeId
		})
		t1["Divider_" .. v.id] = v25 and Roact.createElement(CreateDivider, {
			layoutOrder = v24 + 1
		})
	end

	local v26 = #v20 * 67 + (#v20 - 1) * 1
	local v27 = math.min(maxHeight, v26)

	return Roact.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		LayoutOrder = propsLayoutOrder,
		Size = UDim2.new(1, 0, 0, v27),
		CanvasSize = UDim2.new(1, 0, 0, v26),
		BackgroundColor3 = Constants.Color.WHITE
	}, t1)
end

local v11 = memoize(function(p4, p5) -- line: 98
	-- upvalues: sortFriendsByPresenceAndRecency (copy)
	if not p4 or not p5 then
		return {}
	end

	local t2 = {}

	for _, v in pairs(p5) do
		local v33 = p4[v]

		if v33 and v33.isFriend then
			table.insert(t2, v33)
		end
	end

	table.sort(t2, sortFriendsByPresenceAndRecency)

	return t2
end)

return (RoactRodux.connect(function(p6, p7) -- line: 115
	-- upvalues: v11 (copy)
	return {
		friends = v11(p6.Users, p6.InGameUsersByGame[p7.universeId])
	}
end)(v9))
