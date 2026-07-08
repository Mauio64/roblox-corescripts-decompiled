local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

local function v5(vector2: Vector2, vector2_2: Vector2, t1: {[any]: any}) -- line: 27
	local t2 = {}
	local vector2X = vector2.X
	local vector2Y = vector2.Y
	local vector2_2X = vector2_2.X
	local v14 = vector2_2.Y - vector2Y
	local n1 = 0

	for _, v in ipairs(t1) do
		local v18 = vector2X + n1
		local v19 = v.position.X - v18

		table.insert(t2, {
			Position = {
				X = v18,
				Y = vector2Y
			},
			Size = {
				X = v19,
				Y = v14
			}
		})
		vector2X = v.position.X
		n1 = v.size.X
	end

	local v20 = vector2X + n1
	local v21 = vector2_2X - v20

	table.insert(t2, {
		Position = {
			X = v20,
			Y = vector2Y
		},
		Size = {
			X = v21,
			Y = v14
		}
	})

	return t2
end
local function v6(vector2: Vector2, t3: {[any]: any}) -- line: 79
	-- upvalues: GuiService (copy), v5 (copy)
	local t4 = {}

	for _, v in pairs(t3) do
		table.insert(t4, {
			id = v.id,
			size = v.size,
			position = v.position
		})
	end

	table.sort(t4, function(p1, p2) -- line: 94
		return p1.position.X < p2.position.X and p1.position.X + p1.size.X < p2.size.X + p2.position.X
	end)

	local v27, _ = GuiService:GetGuiInset()
	local vector2_3 = Vector2.new(0, 0)
	local vector2_4 = Vector2.new(vector2.X, v27.Y)
	local v31 = v5(vector2_3, vector2_4, t4)
	local rect = nil

	for _, v in ipairs(v31) do
		if not rect or v.Size.X > rect.Width then
			rect = Rect.new(v.Position.X, v.Position.Y, v.Position.X + v.Size.X, v.Position.Y + v.Size.Y)
		end
	end

	return rect
end

function KeepOutAreasHandler(_) -- line: 124
	-- upvalues: useSelector (copy), React (copy), v6 (copy), GuiService (copy)
	local v39 = useSelector(function(p4) -- line: 125
		return p4.displayOptions.screenSize
	end)
	local v40 = useSelector(function(p5) -- line: 129
		return p5.displayOptions.keepOutAreas
	end)

	React.useEffect(function() -- line: 133
		-- upvalues: v39 (copy), v40 (copy), v6 (copy), GuiService (copy)
		local v45 = v39
		local v46 = v40
		local v47 = v6(v45, v46)

		if v47 then
			GuiService:SetTopbarInset(v47)
		end
	end, {
		v39,
		v40
	})
end

return KeepOutAreasHandler
