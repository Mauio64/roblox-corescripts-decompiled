local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module3 = require("@luauforge/bundled/eer")
local module4 = require("@luauforge/deferred/hLQ")
local module5 = require("@luauforge/bundled/dwA")
local module6 = require("@luauforge/deferred/hLU")

local useGetOnlineFriendsByUniverseId = require("@luauforge/deferred/hLV").useGetOnlineFriendsByUniverseId

local module7 = require("@luauforge/deferred/hLS")

local v5 = module5.PlacesList.ContextualMenu.HorizontalOuterPadding + module5.PlacesList.ContextualMenu.AvatarSize + module5.PlacesList.ContextualMenu.HorizontalInnerPadding

local extended = module.PureComponent:extend("JoinableFriendsList")

local function CreateDivider(p2)
	local layoutOrder = p2.layoutOrder

	return module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		},
		{
			BottomDivider = module.createElement("Frame", {
				Size = UDim2.new(1, -v5, 1, 0),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = module5.Color.GRAY4,
				BorderSizePixel = 0
			})
		}
	)
end

extended.defaultProps = { layoutOrder = 0 }

function extended:init()
	self.state = { friends = self.props.friends }
end

function extended.render(p2)
	local layoutOrder = p2.props.LayoutOrder
	local maxHeight = p2.props.maxHeight
	local width = p2.props.width
	local universeId = p2.props.universeId
	local friends = p2.state.friends or {}

	local children = {
		ListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for i, friend in ipairs(friends) do
		local v6 = i * 2
		local v7 = i < #friends

		children["Entry_" .. friend.id] = module.createElement(module6, {
			user = friend,
			layoutOrder = v6,
			entryHeight = 67,
			entryWidth = width,
			universeId = universeId
		})

		children["Divider_" .. friend.id] = v7 and module.createElement(CreateDivider, {
			layoutOrder = v6 + 1
		})
	end

	local v6 = #friends * 67 + (#friends - 1) * 1
	local v7 = math.min(maxHeight, v6)

	return module.createElement("ScrollingFrame", {
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, v7),
		CanvasSize = UDim2.new(1, 0, 0, v6),
		BackgroundColor3 = module5.Color.WHITE,
		BorderSizePixel = 0,
		ScrollBarThickness = 0
	}, children)
end

local v6 = module3(function(p2, items)
	if not (p2 and items) then
		return {}
	end

	local result = {}

	for k, item in pairs(items) do
		local v7 = p2[item]

		if v7 and v7.isFriend then
			table.insert(result, v7)
		end
	end

	table.sort(result, module4)
	return result
end)

local function JoinableFriendsListWrapper(p2)
	local v7 = useGetOnlineFriendsByUniverseId((tostring(p2.universeId)))

	return module.createElement(extended, Cryo.Dictionary.union(p2, {
		friends = v7 or {}
	}))
end

local v7 = useSheetNavigation.connect(function(p2, p3)
	return {
		friends = v6(p2.Users, p2.InGameUsersByGame[p3.universeId])
	}
end)(extended)

if module7 then
	return (React.memo(JoinableFriendsListWrapper))
end

return v7
