local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")
local fFlagLuaAppAllowNilHookDepsCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagLuaAppAllowNilHookDepsCleanup

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/InputHandlers")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/ReactFocusNavigation")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/FocusNavigationUtils").FocusNavigationEventNameEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/SearchRow/SearchFieldView")

local function useSearchFieldViewModel(data)
	local ref = React.useRef(nil)
	local onExit = data.onExit
	local onChanged = data.onChanged

	local ref2 = React.useRef(Enum.KeyCode.None)

	local ref3 = React.useRef(false)

	local v5 = React.useCallback(function(p2)
		local v6 = ref2
		local v7 = if p2 then p2.KeyCode else Enum.KeyCode.None
		v6.current = v7

		ref3.current = false
	end, {})

	local v6 = React.useCallback(InputHandlers.onRelease(function(object)
		local current = ref2.current
		local v7

		if current == Enum.KeyCode.None or object.eventData == nil then
			v7 = false
		else
			v7 = object.eventData.KeyCode == current
		end

		if not v7 and onExit == nil then
			return
		end

		object:cancel()

		if v7 then
			ref2.current = Enum.KeyCode.None
		else
			onExit()
		end
	end), { onExit or false })

	local ref4 = React.useRef(nil)
	local v7 = ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v6, nil, ref4)

	local v8 = React.useCallback(function(): boolean
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

			for k, v9 in basePlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y) do
				if v9.Active then
					if v9:IsDescendantOf(current) and v8() and ref.current then
						ref.current.focus()
					end

					break
				end
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v8 })

	local v9 = ReactFocusNavigation.useFocusGuiObject()
	local v10 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	local function fn()
		if ref4.current and v10 and v10.focusedGuiObject:getValue() ~= nil then
			v9(ref4.current)
		end
	end

	local v12 = if fFlagLuaAppAllowNilHookDepsCleanup then v10 else v10 or false
	local v13 = React.useCallback(fn, { v9, v12 })

	local v14 = React.useCallback(function(p2)
		if p2 == "" then
			ref3.current = true
			v13()

			if ref.current then
				ref.current.focus()
			end
		end

		onChanged(p2)
	end, { onChanged, v13 })

	local onFocusGained = data.onFocusGained
	local v15 = React.useCallback(function()
		if ref3.current then
			ref3.current = false
		elseif onFocusGained then
			onFocusGained()
		end
	end, { onFocusGained })

	local shouldAutoFocus = data.shouldAutoFocus or false
	React.useEffect(function()
		if shouldAutoFocus then
			v13()
			v8()

			if ref.current then
				ref.current.focus()
			end
		end
	end, { shouldAutoFocus, v13, v8 })

	local v16 = {
		text = data.text,
		placeholder = data.placeholder,
		onChanged = v14,
		onFocusGained = 0,
		onFocusLost = 0,
		inputRef = 0,
		containerRef = 0,
		testId = 0,
		LayoutOrder = 0
	}

	if not onFocusGained then
		v15 = nil
	end

	v16.onFocusGained = v15
	v16.onFocusLost = v5
	v16.inputRef = ref

	v16.containerRef = v7
	v16.testId = data.testId
	v16.LayoutOrder = data.LayoutOrder
	return v16
end

return useSearchFieldViewModel
