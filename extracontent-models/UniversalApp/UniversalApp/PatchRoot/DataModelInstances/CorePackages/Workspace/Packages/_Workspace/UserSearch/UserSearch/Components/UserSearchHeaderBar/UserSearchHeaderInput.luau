local Parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(Parent.React)
local UserSearchBar = require(Parent.SocialCommon).Components.UserSearchBar.UserSearchBar
local v4 = game:DefineFastFlag("FixDoubleSubmit", false)
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole

local function UserSearchHeaderInput(t1: {[any]: any}) -- line: 21
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), React (copy), v4 (copy), UserSearchBar (copy)
	local initialInputText = t1.initialInputText
	local searchPlaceholderText = t1.searchPlaceholderText
	local cancelText = t1.cancelText
	local onCancel = t1.onCancel
	local onSubmit = t1.onSubmit
	local captureFocusOnMount = t1.captureFocusOnMount
	local u14 = nil
	local u15 = nil
	local u16 = nil
	local u17 = nil
	local u18 = nil
	local u19 = nil

	if FFlagEnableLeftNavOnConsole then
		u18 = React.useRef("")
		u19 = React.useRef("")
	else
		local v20, v21 = React.useState(initialInputText)

		u14 = v20
		u15 = v21

		local v22, v23 = React.useState("")

		u16 = v22
		u17 = v23
	end

	local v24 = React.useCallback(function(s1: string) -- line: 42
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), u19 (ref), u18 (ref), u15 (ref)
		if FFlagEnableLeftNavOnConsole then
			u19.current = u18.current
			u18.current = s1

			return
		end

		u15(s1)
	end, {})
	local v25 = React.useCallback(function() -- line: 52
		-- upvalues: FFlagEnableLeftNavOnConsole (copy), u18 (ref), u19 (ref), onSubmit (copy), u14 (ref), u16 (ref), u17 (ref)
		if FFlagEnableLeftNavOnConsole then
			if u18.current ~= u19.current then
				u19.current = u18.current
				onSubmit(u18.current)

				return
			end
		elseif u14 ~= u16 then
			u17(u14)
			onSubmit(u14)
		end
	end, {
		onSubmit,
		if not FFlagEnableLeftNavOnConsole then u14 else nil,
		if not FFlagEnableLeftNavOnConsole then u16 else nil
	})
	local v26 = React.useCallback(function(p1, p2) -- line: 72
		-- upvalues: v4 (copy), v25 (copy), onSubmit (copy), u14 (ref)
		if p1 == false and p2 then
			if v4 then
				v25()

				return
			end

			onSubmit(u14)
		end
	end, {
		u14,
		onSubmit
	})
	local v27 = React.useCallback(function() -- line: 82
		-- upvalues: v4 (copy), v25 (copy), onSubmit (copy), u14 (ref)
		if v4 then
			v25()

			return
		end

		onSubmit(u14)
	end, {
		u14,
		onSubmit
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		maxSize = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(400, 1e999)
		}),
		userSearchBar = React.createElement(UserSearchBar, {
			initialInputText = initialInputText,
			cancelText = cancelText,
			searchPlaceholderText = searchPlaceholderText,
			captureFocusOnMount = captureFocusOnMount,
			cancelCallback = onCancel,
			textChangedCallback = v24,
			focusChangedCallback = v26,
			returnPressedFromOnScreenKeyboardCallback = v27
		})
	})
end

return UserSearchHeaderInput
