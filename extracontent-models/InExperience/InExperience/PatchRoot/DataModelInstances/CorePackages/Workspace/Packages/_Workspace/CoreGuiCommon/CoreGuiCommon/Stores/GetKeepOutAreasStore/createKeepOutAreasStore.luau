local parent = script.Parent.Parent.Parent
local GuiService = game:GetService("GuiService")
local parent2 = parent.Parent
local Signals = require(parent2.Signals)
local Cryo = require(parent2.Cryo)
local Display = require(parent2.Display)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

return function()
	local signal, v = createSignal({}, Cryo.Dictionary.equals)

	local function fn(vector2: Vector2, vector2_2: Vector2, list)
		local x = vector2.X
		local y = vector2.Y
		local x2 = vector2_2.X
		local v2 = vector2_2.Y - y
		local v3 = 0
		local result = {}

		for _, item in ipairs(list) do
			local v4 = x + v3
			table.insert(result, {
				Position = { X = v4, Y = y },
				Size = {
					X = item.position.X - v4,
					Y = v2
				}
			})

			x = item.position.X
			v3 = item.size.X
		end

		local v4 = x + v3
		table.insert(result, {
			Position = { X = v4, Y = y },
			Size = {
				X = x2 - v4,
				Y = v2
			}
		})

		return result
	end

	local function fn2(items)
		local v2 = {}

		for _, item in pairs(items) do
			table.insert(v2, { id = item.id, size = item.size, position = item.position })
		end

		table.sort(v2, function(a, b): boolean
			return a.position.X < b.position.X and a.position.X + a.size.X < b.size.X + b.position.X
		end)

		local guiInset, _ = GuiService:GetGuiInset()
		local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)

		local v3 = fn(Vector2.new(0, 0), Vector2.new(viewportSize.X, guiInset.Y), v2)
		local rect = nil

		for _, v4 in ipairs(v3) do
			if not rect or v4.Size.X > rect.Width then
				rect = Rect.new(v4.Position.X, v4.Position.Y, v4.Position.X + v4.Size.X, v4.Position.Y + v4.Size.Y)
			end
		end

		return rect
	end

	local effect = createEffect(function(p)
		Display.GetDisplayStore(p).getViewportSize(p)
		local v2 = fn2(signal(p))

		if v2 then
			GuiService:SetTopbarInset(v2)
		end
	end)
	return {
		getKeepOutAreas = signal,
		setKeepOutArea = function(id: string, position: Vector2, size: Vector2)
			local v2 = {}
			v2[id] = { id = id, position = position, size = size }

			v(Cryo.Dictionary.join(signal(false), v2))
		end,
		removeKeepOutArea = function(p: string)
			local v2 = signal(false)
			v2[p] = nil
			v(v2)
		end,
		cleanup = function()
			effect()
		end
	}
end
