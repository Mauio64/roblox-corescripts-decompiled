local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/RoactGamepad")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon")

local useTokens = Foundation.Hooks.useTokens
local debounce = AvatarExperienceCommon.Utils.debounce

local fFlagAXFixVRControlBarFlicker = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXFixVRControlBarFlicker

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")

local set = {
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

local function useBaseControlBarProps(data)
	local v5 = useTokens()

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local v6 = RoactGamepad.useRefCache()

	local v7 = React.useCallback(function()
		local result = {}
		local childrenById = {}

		if not data.config then
			return result, childrenById
		end

		for k, v8 in data.config do
			if v8.children then
				childrenById[v8.id] = v8.children
			end

			v8.ref = v6[v8.id]
			table.insert(result, v8)
		end

		return result, childrenById
	end, { data.config })

	local v8, v9 = v7()
	local state, setState = React.useState(v8)
	local state2, setState2 = React.useState(v9)
	local state3, setState3 = React.useState("")

	React.useEffect(function()
		local v10, v11 = v7()
		setState(v10)
		setState2(v11)
	end, { v7 })

	React.useEffect(function()
		if data.onActiveMenuItemChanged then
			data.onActiveMenuItemChanged(state3, state2[state3] ~= nil)
		end
	end, { state3, state2 })

	local v10 = React.useMemo(function()
		return state2[state3]
	end, { state3, state2 })

	local v11 = React.useMemo(function()
		local v12 = v6[state3]

		if not (v12 and v12.current and ref2.current and ref3.current) then
			return nil
		end

		local absolutePosition = v12.current.AbsolutePosition
		local absolutePosition2 = ref2.current.AbsolutePosition
		local absoluteSize = ref3.current.AbsoluteSize

		local v13 = absolutePosition - absolutePosition2 + Vector2.new(absoluteSize.X + v5.Size.Size_50, 0)
		return UDim2.new(0, v13.X, 0, v13.Y)
	end, { state3 })

	local v12 = React.useCallback(debounce(function()
		ref.current = false
	end, 0.1), {})

	return {
		activeMenuItemId = state3,
		menus = state,
		submenus = state2,
		submenuItems = v10,
		submenuPosition = v11,
		onMenuItemActivated = React.useCallback(function(p2)
			setState3(p2 == state3 and "" or p2)
			ref.current = true
			v12()
		end, { state3 }),
		onSubmenuItemActivated = React.useCallback(function(p2)
			setState3("")
			ref.current = true
			v12()
		end, {}),
		onInputEnded = React.useCallback(function(p2)
			if state3 ~= "" and not (ref.current or set[p2.KeyCode]) then
				setState3("")
			end

			if not fFlagAXFixVRControlBarFlicker then
				ref.current = false
			end
		end, { state3 }),
		containerRef = ref2,
		iconMenuRef = ref3,
		menuItemsRefCache = v6,
		LayoutOrder = data.LayoutOrder
	}
end

return useBaseControlBarProps
