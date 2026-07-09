local Parent = script:FindFirstAncestor("AppDebug").Parent
local React = require(Parent.React)

local function isAncestorVisible(p1) -- line: 20
	while p1 do
		if p1:IsA("GuiObject") and not p1.Visible then
			return false
		end

		p1 = p1.Parent
	end

	return true
end
local function useInstanceTracking(p2) -- line: 34
	-- upvalues: React (copy), isAncestorVisible (copy)
	local v7, v8 = React.useState(if not p2 or not p2:IsA("GuiObject") then Vector2.zero else p2.AbsolutePosition)
	local v9, v10 = React.useState(if not p2 or not p2:IsA("GuiObject") then Vector2.zero else p2.AbsoluteSize)
	local v11, v12 = React.useState(function() -- line: 41
		-- upvalues: p2 (copy), isAncestorVisible (copy)
		if not p2 or not p2.Parent then
			return false
		end

		return (isAncestorVisible(p2))
	end)

	React.useEffect(function() -- line: 48
		-- upvalues: p2 (copy), v12 (copy), isAncestorVisible (copy), v8 (copy), v10 (copy)
		if not p2 then
			v12(false)

			return
		end

		if p2.Parent == nil then
			v12(false)

			return
		end

		if not p2:IsA("GuiObject") then
			v12(false)

			return
		end

		local v13 = p2
		local t1 = {}

		local function updateVisibility() -- line: 67
			-- upvalues: v13 (copy), v12 (copy), isAncestorVisible (copy)
			if v13.Parent then
				v12((isAncestorVisible(v13)))

				return
			end

			v12(false)
		end

		v8(v13.AbsolutePosition)
		v10(v13.AbsoluteSize)

		if v13.Parent then
			v12((isAncestorVisible(v13)))
		else
			v12(false)
		end

		table.insert(t1, v13:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 81
			-- upvalues: v13 (copy), v8 (copy)
			if v13.Parent then
				v8(v13.AbsolutePosition)
			end
		end))
		table.insert(t1, v13:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 90
			-- upvalues: v13 (copy), v10 (copy)
			if v13.Parent then
				v10(v13.AbsoluteSize)
			end
		end))
		table.insert(t1, v13:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 99
			-- upvalues: v13 (copy), v12 (copy), isAncestorVisible (copy)
			if v13.Parent then
				v12((isAncestorVisible(v13)))

				return
			end

			v12(false)
		end))
		table.insert(t1, v13.AncestryChanged:Connect(function(_, parent) -- line: 106
			-- upvalues: v12 (copy), updateVisibility (copy)
			if parent == nil then
				v12(false)

				return
			end

			task.defer(updateVisibility)
		end))

		local Parent2 = v13.Parent

		while Parent2 do
			if Parent2:IsA("GuiObject") then
				table.insert(t1, Parent2:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 122
					-- upvalues: v13 (copy), v12 (copy), isAncestorVisible (copy)
					if v13.Parent then
						v12((isAncestorVisible(v13)))

						return
					end

					v12(false)
				end))
			end

			Parent2 = Parent2.Parent
		end

		return function() -- line: 130
			-- upvalues: t1 (copy)
			for _, v20 in t1 do
				v20:Disconnect()
			end
		end
	end, { p2 })

	return {
		position = v7,
		size = v9,
		isVisible = v11
	}
end

return useInstanceTracking
