local ParentParent = script.Parent.Parent.Parent
local GuiService = game:GetService("GuiService")
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local Cryo = require(ParentParentParent.Cryo)
local Display = require(ParentParentParent.Display)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

return function() -- line: 41
	-- upvalues: createSignal (copy), Cryo (copy), GuiService (copy), Display (copy), createEffect (copy)
	local v9, v10 = createSignal({}, Cryo.Dictionary.equals)

	local function v11(vector2: Vector2, vector2_2: Vector2, t1: {[any]: any}) -- line: 44
		local t2 = {}
		local vector2X = vector2.X
		local vector2Y = vector2.Y
		local vector2_2X = vector2_2.X
		local v21 = vector2_2.Y - vector2Y
		local n1 = 0

		for _, v in ipairs(t1) do
			local v25 = vector2X + n1
			local v26 = v.position.X - v25

			table.insert(t2, {
				Position = {
					X = v25,
					Y = vector2Y
				},
				Size = {
					X = v26,
					Y = v21
				}
			})
			vector2X = v.position.X
			n1 = v.size.X
		end

		local v27 = vector2X + n1
		local v28 = vector2_2X - v27

		table.insert(t2, {
			Position = {
				X = v27,
				Y = vector2Y
			},
			Size = {
				X = v28,
				Y = v21
			}
		})

		return t2
	end
	local function v12(t3: {[any]: any}) -- line: 96
		-- upvalues: GuiService (copy), Display (copy), v11 (copy)
		local t4 = {}

		for _, v in pairs(t3) do
			table.insert(t4, {
				id = v.id,
				size = v.size,
				position = v.position
			})
		end

		table.sort(t4, function(p1, p2) -- line: 111
			return p1.position.X < p2.position.X and p1.position.X + p1.size.X < p2.size.X + p2.position.X
		end)

		local v33, _ = GuiService:GetGuiInset()
		local v35 = Display.GetDisplayStore(false).getViewportSize(false)
		local vector2 = Vector2.new(0, 0)
		local vector2_3 = Vector2.new(v35.X, v33.Y)
		local v38 = v11(vector2, vector2_3, t4)
		local rect = nil

		for _, v in ipairs(v38) do
			if not rect or v.Size.X > rect.Width then
				rect = Rect.new(v.Position.X, v.Position.Y, v.Position.X + v.Size.X, v.Position.Y + v.Size.Y)
			end
		end

		return rect
	end

	local v13 = createEffect(function(p3) -- line: 157
		-- upvalues: Display (copy), v12 (copy), v9 (copy), GuiService (copy)
		Display.GetDisplayStore(p3).getViewportSize(p3)

		local v49 = v12(v9(p3))

		if v49 then
			GuiService:SetTopbarInset(v49)
		end
	end)

	return {
		getKeepOutAreas = v9,
		setKeepOutArea = function(s1: string, vector2: Vector2, vector2_4: Vector2) -- line: 140
			-- upvalues: v10 (copy), Cryo (copy), v9 (copy)
			local t5 = {
				[s1] = {
					id = s1,
					position = vector2,
					size = vector2_4
				}
			}

			v10(Cryo.Dictionary.join(v9(false), t5))
		end,
		removeKeepOutArea = function(s2: string) -- line: 151
			-- upvalues: v9 (copy), v10 (copy)
			local v47 = v9(false)

			v47[s2] = nil
			v10(v47)
		end,
		cleanup = function() -- line: 165
			-- upvalues: v13 (copy)
			v13()
		end
	}
end
