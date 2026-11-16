local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local withStyle = UIBlox.Style.withStyle

local vector2 = Vector2.new(375, 70)

local module2 = require("@luauforge/deferred/fAr")

local extended = Roact.PureComponent:extend("DevSubGameList")

local function sortedGames(games, subsByGameId)
	local v5 = {}
	local v6 = {}

	for k, item in pairs(games) do
		if item.activeSubs > 0 then
			table.insert(v5, item)
		else
			table.insert(v6, item)
		end
	end

	local result = {}

	for k, v7 in pairs(v5) do
		table.insert(result, v7)
	end

	for k, v7 in pairs(v6) do
		table.insert(result, v7)
	end

	return result
end

function extended.render(p2)
	return withStyle(function(p3)
		local props = p2.props
		local games = props.games
		local subsByGameId = props.subsByGameId
		local onGameActivated = props.onGameActivated

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0)
			})
		}

		local v5 = sortedGames(games, subsByGameId)

		for k, v6 in pairs(v5) do
			local names = {}

			for k2, v7 in pairs(subsByGameId[v6.id]) do
				table.insert(names, v7.name)
			end

			table.insert(children, Roact.createElement(module2, {
				game = v6,
				subNames = names,
				activeSubs = v6.activeSubs,
				active = v6.activeSubs > 0,
				dividerDisabled = k == #v5,
				onActivated = function()
					onGameActivated(v6)
				end,
				maxSize = vector2,
				layoutOrder = k
			}))
		end

		return Roact.createElement(FitChildren.FitFrame, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			fitFields = { Size = FitChildren.FitAxis.Height }
		}, children)
	end)
end

return extended
