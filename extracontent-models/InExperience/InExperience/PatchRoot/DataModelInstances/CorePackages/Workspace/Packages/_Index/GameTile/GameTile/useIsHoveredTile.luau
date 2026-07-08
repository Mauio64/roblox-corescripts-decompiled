local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)

require(GameTileParent.AppCommonLib)

local HoverTileCoordinator = require(GameTile.HoverTileCoordinator)

local function useIsHoveredTile(t1: {[any]: any}, s1: string, b1: boolean, p1) -- line: 11
	-- upvalues: HoverTileCoordinator (copy), React (copy)
	local v10 = p1 or HoverTileCoordinator.default
	local v11, v12 = React.useState(false)

	React.useEffect(function() -- line: 25
		-- upvalues: b1 (copy), s1 (copy), v12 (copy), v10 (copy)
		if not b1 then
			return
		end

		local function checkAndUpdateState(s2: string?) -- line: 31
			-- upvalues: s1 (copy), v12 (copy)
			local v19 = s2 ~= nil and s2 == s1

			v12(v19)
		end

		local hoveredKey = v10.hoveredKey
		local v15 = hoveredKey ~= nil and hoveredKey == s1

		v12(v15)

		local u16 = v10.changed:connect(function(p2) -- line: 38
			-- upvalues: s1 (copy), v12 (copy)
			local v21 = p2 ~= nil and p2 == s1

			v12(v21)
		end)

		return function() -- line: 42
			-- upvalues: u16 (ref)
			if u16 ~= nil then
				u16:disconnect()
				u16 = nil
			end
		end
	end, {
		b1,
		s1,
		v10
	})
	React.useEffect(function() -- line: 50
		-- upvalues: b1 (copy), t1 (copy), v10 (copy), s1 (copy)
		if not b1 then
			return
		end

		local t2 = {}

		if t1.current ~= nil then
			table.insert(t2, t1.current.MouseLeave:Connect(function() -- line: 59
				-- upvalues: v10 (copy), s1 (copy)
				v10:cancelHover(s1)
			end))
			table.insert(t2, t1.current.MouseEnter:Connect(function() -- line: 65
				-- upvalues: v10 (copy), s1 (copy)
				v10:requestHover(s1)
			end))
		end

		return function() -- line: 70
			-- upvalues: t2 (copy)
			for _, v23 in t2 do
				v23:Disconnect()
			end
		end
	end, {
		s1,
		t1,
		b1,
		v10
	})
	React.useEffect(function() -- line: 78
		-- upvalues: s1 (copy), v10 (copy)
		return function() -- line: 79
			-- upvalues: s1 (copy), v10 (copy)
			if s1 then
				v10:cancelHover(s1)
			end
		end
	end, {
		s1,
		v10
	})

	return b1 and v11
end

return useIsHoveredTile
