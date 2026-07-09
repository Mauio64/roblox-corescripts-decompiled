local Parent = script:FindFirstAncestor("System").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}?) -- line: 36
	-- upvalues: t1 (copy), createSignal (copy), createEffect (copy)
	local self = setmetatable({}, t1)
	local v8 = false
	local v9 = false

	if t2 then
		v8 = t2.defaultVisible
		v9 = t2.defaultEnabled
	end

	local v10, v11 = createSignal(v8)
	local v12, v13 = createSignal(v9)

	self.getVisible = v10
	self.setVisible = v11
	self.getEnabled = v12
	self.setEnabled = v13

	local t3 = {}
	local t4 = {}
	local v16 = createEffect(function(p1) -- line: 58
		-- upvalues: v10 (copy), self (copy), t3 (copy), v11 (copy)
		local v19 = v10(p1)

		if self.getEnabled(false) then
			for _, v21 in t3 do
				local v22 = v21(v19)

				if type(v22) == "boolean" and v22 ~= v19 then
					v11(v22)

					return
				end
			end
		end
	end)
	local v17 = createEffect(function(p2) -- line: 71
		-- upvalues: v12 (copy), t4 (copy)
		local v24 = v12(p2)

		for _, v26 in t4 do
			v26(v24)
		end
	end)

	function self.dispose(_) -- line: 78
		-- upvalues: v16 (copy), v17 (copy)
		v16()
		v17()
	end
	function self.onVisibilityChanged(_, p5: ((...any) -> ...any)) -- line: 83
		-- upvalues: t3 (copy)
		table.insert(t3, p5)

		return function() -- line: 86
			-- upvalues: t3 (copy), p5 (copy)
			local v32 = table.find(t3, p5)

			if v32 then
				table.remove(t3, v32)
			end
		end
	end
	function self.onEnabledChanged(_, p7: ((...any) -> ...any)) -- line: 94
		-- upvalues: t4 (copy), v12 (copy)
		table.insert(t4, p7)
		p7(v12(false))

		return function() -- line: 97
			-- upvalues: t4 (copy), p7 (copy)
			local v33 = table.find(t4, p7)

			if v33 then
				table.remove(t4, v33)
			end
		end
	end

	return self
end

return t1
