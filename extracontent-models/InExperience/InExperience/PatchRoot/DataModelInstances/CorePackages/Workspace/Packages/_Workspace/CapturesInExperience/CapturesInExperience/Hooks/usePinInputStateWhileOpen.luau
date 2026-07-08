local _select = select

local function v27(tbl, idx, ...)
	local va = { ... }

	for i = 1, _select("#", ...) do
		tbl[idx + i - 1] = va[i]
	end
end

local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Default = Enum.MouseBehavior.Default

return function(b1: boolean?, p1) -- line: 30
	-- upvalues: React (copy), UserInputService (copy), Default (copy)
	React.useEffect(function() -- line: 31
		-- upvalues: b1 (copy), p1 (copy), UserInputService (copy), Default (copy)
		if not b1 then
			return
		end

		local v7 = if p1 == nil then UserInputService else p1
		local t1 = {
			MouseBehavior = v7.MouseBehavior,
			MouseIconEnabled = v7.MouseIconEnabled,
			MouseIcon = v7.MouseIcon
		}

		local function pin(s1: string, p2) -- line: 44
			-- upvalues: v7 (copy)
			v7[s1] = p2
		end

		v7.MouseBehavior = Default
		v7.MouseIconEnabled = true
		v7.MouseIcon = ""

		local function watch(s2: string, p3) -- line: 52
			-- upvalues: v7 (copy), t1 (copy)
			return v7:GetPropertyChangedSignal(s2):Connect(function() -- line: 53
				-- upvalues: v7 (copy), s2 (copy), p3 (copy), t1 (copy)
				local v26 = v7[s2]

				if v26 ~= p3 then
					t1[s2] = v26
					v7[s2] = p3
				end
			end)
		end

		local t2 = {}
		local v12 = Default
		local s3 = "MouseBehavior"
		local connection = v7:GetPropertyChangedSignal("MouseBehavior"):Connect(function() -- line: 53
			-- upvalues: v7 (copy), s3 (copy), v12 (copy), t1 (copy)
			local v22 = v7[s3]

			if v22 ~= v12 then
				t1[s3] = v22
				v7[s3] = v12
			end
		end)
		local s4 = "MouseIconEnabled"
		local v16 = true
		local connection2 = v7:GetPropertyChangedSignal("MouseIconEnabled"):Connect(function() -- line: 53
			-- upvalues: v7 (copy), s4 (copy), v16 (copy), t1 (copy)
			local v23 = v7[s4]

			if v23 ~= v16 then
				t1[s4] = v23
				v7[s4] = v16
			end
		end)

		t2[1] = connection
		t2[2] = connection2
		v27(t2, 3, watch("MouseIcon", ""))

		return function() -- line: 68
			-- upvalues: t2 (copy), v7 (copy), t1 (copy)
			for _, v25 in t2 do
				v25:Disconnect()
			end

			v7.MouseBehavior = t1.MouseBehavior
			v7.MouseIconEnabled = t1.MouseIconEnabled
			v7.MouseIcon = t1.MouseIcon
		end
	end, {
		b1,
		p1
	})
end
