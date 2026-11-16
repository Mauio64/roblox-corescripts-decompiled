local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function fn(vector2: Vector2, vector2_2: Vector2, list)
	local x = vector2.X
	local y = vector2.Y
	local x2 = vector2_2.X
	local v = vector2_2.Y - y
	local v2 = 0
	local result = {}

	for _, item in ipairs(list) do
		local v3 = x + v2
		table.insert(result, {
			Position = { X = v3, Y = y },
			Size = {
				X = item.position.X - v3,
				Y = v
			}
		})

		x = item.position.X
		v2 = item.size.X
	end

	local v3 = x + v2
	table.insert(result, {
		Position = { X = v3, Y = y },
		Size = {
			X = x2 - v3,
			Y = v
		}
	})

	return result
end

local function fn2(vector2: Vector2, items)
	local v = {}

	for _, item in pairs(items) do
		table.insert(v, { id = item.id, size = item.size, position = item.position })
	end

	table.sort(v, function(a, b): boolean
		return a.position.X < b.position.X and a.position.X + a.size.X < b.size.X + b.position.X
	end)

	local guiInset, _ = GuiService:GetGuiInset()

	local v2 = fn(Vector2.new(0, 0), Vector2.new(vector2.X, guiInset.Y), v)
	local rect = nil

	for _, v3 in ipairs(v2) do
		if not rect or v3.Size.X > rect.Width then
			rect = Rect.new(v3.Position.X, v3.Position.Y, v3.Position.X + v3.Size.X, v3.Position.Y + v3.Size.Y)
		end
	end

	return rect
end

local function fn3(vector2: Vector2, p) -- 1 equivalent call inferred from this helper
	local v = fn2(vector2, p)

	if v then
		GuiService:SetTopbarInset(v)
	end
end

function KeepOutAreasHandler(_)
	local v = useSelector(function(p)
		return p.displayOptions.screenSize
	end)

	local v2 = useSelector(function(p)
		return p.displayOptions.keepOutAreas
	end)

	React.useEffect(function()
		fn3(v, v2) -- inferred equivalent call
	end, { v, v2 })
end

return KeepOutAreasHandler
