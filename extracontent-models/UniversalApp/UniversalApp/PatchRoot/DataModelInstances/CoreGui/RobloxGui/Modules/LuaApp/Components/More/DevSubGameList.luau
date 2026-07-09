local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitChildren = require(Modules.LuaApp.FitChildren)
local withStyle = UIBlox.Style.withStyle
local vector2 = Vector2.new(375, 70)
local DevSubGame = require(Modules.LuaApp.Components.More.DevSubGame)
local v9 = Roact.PureComponent:extend("DevSubGameList")

local function sortedGames(p1, _) -- line: 18
	local t1 = {}
	local t2 = {}

	for _, v in pairs(p1) do
		if v.activeSubs > 0 then
			table.insert(t1, v)
		else
			table.insert(t2, v)
		end
	end

	local t3 = {}

	for _, v in pairs(t1) do
		table.insert(t3, v)
	end

	for _, v in pairs(t2) do
		table.insert(t3, v)
	end

	return t3
end

function v9.render(p3) -- line: 40
	-- upvalues: withStyle (copy), Roact (copy), sortedGames (copy), DevSubGame (copy), vector2 (copy), FitChildren (copy)
	return withStyle(function(_) -- line: 41
		-- upvalues: p3 (copy), Roact (copy), sortedGames (copy), DevSubGame (copy), vector2 (copy), FitChildren (copy)
		local props = p3.props
		local games = props.games
		local subsByGameId = props.subsByGameId
		local onGameActivated = props.onGameActivated
		local t4 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0)
			})
		}
		local v29 = sortedGames(games, subsByGameId)

		for k, v in pairs(v29) do
			local t5 = {}

			for _, v2 in pairs(subsByGameId[v.id]) do
				table.insert(t5, v2.name)
			end

			table.insert(t4, Roact.createElement(DevSubGame, {
				game = v,
				subNames = t5,
				activeSubs = v.activeSubs,
				active = v.activeSubs > 0,
				dividerDisabled = k == #v29,
				onActivated = function() -- line: 71
					-- upvalues: onGameActivated (copy), v (copy)
					onGameActivated(v)
				end,
				maxSize = vector2,
				layoutOrder = k
			}))
		end

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			fitFields = {
				Size = FitChildren.FitAxis.Height
			}
		}, t4)
	end)
end

return v9
