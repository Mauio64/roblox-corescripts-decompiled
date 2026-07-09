local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local RoactGamepad = require(AvatarExperienceControlBarParent.RoactGamepad)
local AvatarExperienceCommon = require(AvatarExperienceControlBarParent.AvatarExperienceCommon)
local useTokens = Foundation.Hooks.useTokens
local debounce = AvatarExperienceCommon.Utils.debounce

require(AvatarExperienceControlBar.ControlBarTypes)

local t1 = {
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Right] = true,
	[Enum.KeyCode.DPadDown] = true,
	[Enum.KeyCode.DPadUp] = true,
	[Enum.KeyCode.DPadLeft] = true,
	[Enum.KeyCode.DPadRight] = true,
	[Enum.KeyCode.Thumbstick1] = true
}

local function useBaseControlBarProps(p1) -- line: 37
	-- upvalues: useTokens (copy), React (copy), RoactGamepad (copy), debounce (copy), t1 (copy)
	local v12 = useTokens()
	local v13 = React.useRef(false)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(nil)
	local v16 = RoactGamepad.useRefCache()
	local v17 = React.useCallback(function() -- line: 50
		-- upvalues: p1 (copy), v16 (copy)
		local t2 = {}
		local t3 = {}

		if p1.config then
			for _, v35 in p1.config do
				if v35.children then
					t3[v35.id] = v35.children
				end

				v35.ref = v16[v35.id]
				table.insert(t2, v35)
			end
		end

		return t2, t3
	end, { p1.config })
	local v18, v19 = v17()
	local v20, v21 = React.useState(v18)
	local v22, v23 = React.useState(v19)
	local v24, v25 = React.useState("")

	React.useEffect(function() -- line: 77
		-- upvalues: v17 (copy), v21 (copy), v23 (copy)
		local v36, v37 = v17()

		v21(v36)
		v23(v37)
	end, { v17 })
	React.useEffect(function() -- line: 83
		-- upvalues: p1 (copy), v24 (copy), v22 (copy)
		if p1.onActiveMenuItemChanged then
			p1.onActiveMenuItemChanged(v24, v22[v24] ~= nil)
		end
	end, {
		v24,
		v22
	})

	local v26 = React.useMemo(function() -- line: 89
		-- upvalues: v22 (copy), v24 (copy)
		return v22[v24]
	end, {
		v24,
		v22
	})
	local v27 = React.useMemo(function() -- line: 93
		-- upvalues: v16 (copy), v24 (copy), v14 (copy), v15 (copy), v12 (copy)
		local v38 = v16[v24]

		if v38 and (v38.current and v14.current and v15.current) then
			local AbsolutePosition = v38.current.AbsolutePosition
			local AbsolutePosition2 = v14.current.AbsolutePosition
			local AbsoluteSize = v15.current.AbsoluteSize
			local v42 = AbsolutePosition - AbsolutePosition2 + Vector2.new(AbsoluteSize.X + v12.Size.Size_50, 0)

			return UDim2.new(0, v42.X, 0, v42.Y)
		end

		return nil
	end, { v24 })
	local v28 = React.useCallback(debounce(function() -- line: 110
		-- upvalues: v13 (copy)
		v13.current = false
	end, 0.1), {})
	local v29 = React.useCallback(function(s1: string) -- line: 116
		-- upvalues: v25 (copy), v24 (copy), v13 (copy), v28 (copy)
		v25(if s1 ~= v24 then s1 else "")
		v13.current = true
		v28()
	end, { v24 })
	local v30 = React.useCallback(function(_: string) -- line: 122
		-- upvalues: v25 (copy), v13 (copy), v28 (copy)
		v25("")
		v13.current = true
		v28()
	end, {})
	local v31 = React.useCallback(function(p2) -- line: 132
		-- upvalues: v24 (copy), v13 (copy), t1 (copy), v25 (copy)
		if v24 ~= "" and (not v13.current and not t1[p2.KeyCode]) then
			v25("")
		end

		v13.current = false
	end, { v24 })

	return {
		activeMenuItemId = v24,
		menus = v20,
		submenus = v22,
		submenuItems = v26,
		submenuPosition = v27,
		onMenuItemActivated = v29,
		onSubmenuItemActivated = v30,
		onInputEnded = v31,
		containerRef = v14,
		iconMenuRef = v15,
		menuItemsRefCache = v16,
		LayoutOrder = p1.LayoutOrder
	}
end

return useBaseControlBarProps
