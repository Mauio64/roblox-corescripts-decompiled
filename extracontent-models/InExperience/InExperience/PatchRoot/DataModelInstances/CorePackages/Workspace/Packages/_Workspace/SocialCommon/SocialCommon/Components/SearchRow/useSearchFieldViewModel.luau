local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(parent.React)
require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAllowNilHookDepsCleanup = SharedFlags.FFlagLuaAppAllowNilHookDepsCleanup

local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(script.Parent.SearchFieldView)

local function useSearchFieldViewModel(data)
	local ref = React.useRef(nil)
	local onExit = data.onExit
	local onChanged = data.onChanged

	local ref2 = React.useRef(Enum.KeyCode.None)

	local ref3 = React.useRef(false)

	local onFocusLost = React.useCallback(function(p)
		local current = if p then p.KeyCode else Enum.KeyCode.None
		ref2.current = current

		ref3.current = false
	end, {})

	local v = React.useCallback(InputHandlers.onRelease(function(object)
		local current = ref2.current
		local v

		if current == Enum.KeyCode.None or object.eventData == nil then
			v = false
		else
			v = object.eventData.KeyCode == current
		end

		if not v and onExit == nil then
			return
		end

		object:cancel()

		if v then
			ref2.current = Enum.KeyCode.None
		else
			onExit()
		end
	end), { onExit or false })

	local ref4 = React.useRef(nil)
	local containerRef = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v, nil, ref4)

	local v2 = React.useCallback(function(): boolean
		local focusedTextBox = UserInputService:GetFocusedTextBox()
		local current = ref4.current

		if focusedTextBox and current and not focusedTextBox:IsDescendantOf(current) then
			focusedTextBox:ReleaseFocus()
			return true
		end

		return false
	end, {})

	React.useEffect(function()
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local current = ref4.current
			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
				or not current
				or not focusedTextBox
				or focusedTextBox:IsDescendantOf(current)
			then
				return
			end

			local basePlayerGui = current:FindFirstAncestorWhichIsA("BasePlayerGui")

			if not basePlayerGui then
				return
			end

			for _, v3 in basePlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y) do
				if v3.Active then
					if v3:IsDescendantOf(current) and v2() and ref.current then
						ref.current.focus()
					end

					break
				end
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v2 })

	local v3 = ReactFocusNavigation.useFocusGuiObject()
	local v4 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	local useCallback = React.useCallback
	local function fn()
		if ref4.current and v4 and v4.focusedGuiObject:getValue() ~= nil then
			v3(ref4.current)
		end
	end

	local v5

	if FFlagLuaAppAllowNilHookDepsCleanup then
		v5 = v4
	else
		v5 = v4 or false
	end

	local v6 = useCallback(fn, { v3, v5 })

	local onChanged2 = React.useCallback(function(p: string)
		if p == "" then
			ref3.current = true
			v6()

			if ref.current then
				ref.current.focus()
			end
		end

		onChanged(p)
	end, { onChanged, v6 })

	local onFocusGained = data.onFocusGained
	local onFocusGained2 = React.useCallback(function()
		if ref3.current then
			ref3.current = false
		elseif onFocusGained then
			onFocusGained()
		end
	end, { onFocusGained })

	local shouldAutoFocus = data.shouldAutoFocus or false
	React.useEffect(function()
		if shouldAutoFocus then
			v6()
			v2()

			if ref.current then
				ref.current.focus()
			end
		end
	end, { shouldAutoFocus, v6, v2 })

	local v7 = {
		text = data.text,
		placeholder = data.placeholder,
		onChanged = onChanged2,
		onFocusGained = 0,
		onFocusLost = 0,
		inputRef = 0,
		containerRef = 0,
		testId = 0,
		LayoutOrder = 0
	}

	if not onFocusGained then
		onFocusGained2 = nil
	end

	v7.onFocusGained = onFocusGained2
	v7.onFocusLost = onFocusLost
	v7.inputRef = ref

	v7.containerRef = containerRef
	v7.testId = data.testId
	v7.LayoutOrder = data.LayoutOrder
	return v7
end

return useSearchFieldViewModel
