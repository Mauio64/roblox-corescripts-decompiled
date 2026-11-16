local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RoactGamepad = require(parent.RoactGamepad)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local useTokens = Foundation.Hooks.useTokens
local debounce = AvatarExperienceCommon.Utils.debounce

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXFixVRControlBarFlicker = AvatarExperienceFlags.FFlagAXFixVRControlBarFlicker

require(AvatarExperienceControlBar.ControlBarTypes)

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
	local v = useTokens()

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local menuItemsRefCache = RoactGamepad.useRefCache()

	local v2 = React.useCallback(function()
		local result = {}
		local childrenById = {}

		if not data.config then
			return result, childrenById
		end

		for _, v2 in data.config do
			if v2.children then
				childrenById[v2.id] = v2.children
			end

			v2.ref = menuItemsRefCache[v2.id]
			table.insert(result, v2)
		end

		return result, childrenById
	end, { data.config })

	local v3, v4 = v2()
	local state, setState = React.useState(v3)
	local state2, setState2 = React.useState(v4)
	local state3, setState3 = React.useState("")

	React.useEffect(function()
		local v5, v6 = v2()
		setState(v5)
		setState2(v6)
	end, { v2 })

	React.useEffect(function()
		if data.onActiveMenuItemChanged then
			data.onActiveMenuItemChanged(state3, state2[state3] ~= nil)
		end
	end, { state3, state2 })

	local submenuItems = React.useMemo(function()
		return state2[state3]
	end, { state3, state2 })

	local submenuPosition = React.useMemo(function()
		local v5 = menuItemsRefCache[state3]

		if not (v5 and v5.current and ref2.current and ref3.current) then
			return nil
		end

		local absolutePosition = v5.current.AbsolutePosition
		local absolutePosition2 = ref2.current.AbsolutePosition
		local absoluteSize = ref3.current.AbsoluteSize

		local v6 = absolutePosition - absolutePosition2 + Vector2.new(absoluteSize.X + v.Size.Size_50, 0)
		return UDim2.new(0, v6.X, 0, v6.Y)
	end, { state3 })

	local v5 = React.useCallback(debounce(function()
		ref.current = false
	end, 0.1), {})

	return {
		activeMenuItemId = state3,
		menus = state,
		submenus = state2,
		submenuItems = submenuItems,
		submenuPosition = submenuPosition,
		onMenuItemActivated = React.useCallback(function(p: string)
			setState3(p == state3 and "" or p)
			ref.current = true
			v5()
		end, { state3 }),
		onSubmenuItemActivated = React.useCallback(function(_: string)
			setState3("")
			ref.current = true
			v5()
		end, {}),
		onInputEnded = React.useCallback(function(p)
			if state3 ~= "" and not (ref.current or set[p.KeyCode]) then
				setState3("")
			end

			if not FFlagAXFixVRControlBarFlicker then
				ref.current = false
			end
		end, { state3 }),
		containerRef = ref2,
		iconMenuRef = ref3,
		menuItemsRefCache = menuItemsRefCache,
		LayoutOrder = data.LayoutOrder
	}
end

return useBaseControlBarProps
