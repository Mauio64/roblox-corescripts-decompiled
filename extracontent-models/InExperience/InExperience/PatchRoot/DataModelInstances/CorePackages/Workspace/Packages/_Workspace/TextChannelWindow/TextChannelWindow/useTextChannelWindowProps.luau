local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection

local function resolveTarget(p1) -- line: 19
	local p1Target = p1.Target

	if p1Target and p1Target:IsA("TextChannel") then
		return p1Target
	end

	return nil
end
local function useTextChannelWindowProps(p2) -- line: 27
	-- upvalues: React (copy), useEventConnection (copy)
	local v9, v10 = React.useState(function() -- line: 28
		-- upvalues: p2 (copy)
		local p2Target = p2.Target

		if p2Target and p2Target:IsA("TextChannel") then
			return p2Target
		end

		return nil
	end)
	local v11, v12 = React.useState(function() -- line: 32
		-- upvalues: p2 (copy)
		return p2.BackgroundColor3
	end)
	local v13 = React.useRef(v9)

	useEventConnection(p2:GetPropertyChangedSignal("Target"), function() -- line: 38
		-- upvalues: p2 (copy), v13 (copy), v10 (copy)
		local p2Target = p2.Target
		local v16 = if not p2Target or not p2Target:IsA("TextChannel") then nil else p2Target

		v13.current = v16
		v10(v16)
	end, { p2 })
	useEventConnection(p2:GetPropertyChangedSignal("BackgroundColor3"), function() -- line: 45
		-- upvalues: v12 (copy), p2 (copy)
		v12(p2.BackgroundColor3)
	end, { p2 })

	return {
		target = v9,
		backgroundColor = v11
	}
end

return useTextChannelWindowProps
