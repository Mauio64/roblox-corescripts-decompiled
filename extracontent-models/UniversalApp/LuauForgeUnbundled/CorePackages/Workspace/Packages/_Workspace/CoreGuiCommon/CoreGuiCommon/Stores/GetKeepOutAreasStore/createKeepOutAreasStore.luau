local GuiService = game:GetService("GuiService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Cryo")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Display")
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

return function()
	local signal, v5 = createSignal({}, Cryo.Dictionary.equals)

	local function fn(vector2, vector2_2, list)
		local x = vector2.X
		local y = vector2.Y
		local x2 = vector2_2.X
		local v6 = vector2_2.Y - y
		local v7 = 0
		local result = {}

		for i, item in ipairs(list) do
			local v8 = x + v7
			table.insert(result, {
				Position = { X = v8, Y = y },
				Size = {
					X = item.position.X - v8,
					Y = v6
				}
			})

			x = item.position.X
			v7 = item.size.X
		end

		local v8 = x + v7
		table.insert(result, {
			Position = { X = v8, Y = y },
			Size = {
				X = x2 - v8,
				Y = v6
			}
		})

		return result
	end

	local function fn2(items)
		local v6 = {}

		for k, item in pairs(items) do
			table.insert(v6, {
				id = item.id,
				size = item.size,
				position = item.position
			})
		end

		table.sort(v6, function(a, b): boolean
			return a.position.X < b.position.X and a.position.X + a.size.X < b.size.X + b.position.X
		end)

		local guiInset, v7 = GuiService:GetGuiInset()
		local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)

		local v8 = fn(Vector2.new(0, 0), Vector2.new(viewportSize.X, guiInset.Y), v6)
		local rect = nil

		for i, v9 in ipairs(v8) do
			if not rect or v9.Size.X > rect.Width then
				rect = Rect.new(
					v9.Position.X,
					v9.Position.Y,
					v9.Position.X + v9.Size.X,
					v9.Position.Y + v9.Size.Y
				)
			end
		end

		return rect
	end

	local effect = createEffect(function(p2)
		Display.GetDisplayStore(p2).getViewportSize(p2)
		local v6 = fn2(signal(p2))

		if v6 then
			GuiService:SetTopbarInset(v6)
		end
	end)
	return {
		getKeepOutAreas = signal,
		setKeepOutArea = function(p2, p3, p4)
			local v6 = {}
			v6[p2] = { id = p2, position = p3, size = p4 }

			v5(Cryo.Dictionary.join(signal(false), v6))
		end,
		removeKeepOutArea = function(p2)
			local v6 = signal(false)
			v6[p2] = nil
			v5(v6)
		end,
		cleanup = function()
			effect()
		end
	}
end
