local parent = script:FindFirstAncestor("UserSearch").Parent

local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)
local UserSearchBar = SocialCommon.Components.UserSearchBar.UserSearchBar

local function UserSearchHeaderInput(props)
	local initialInputText = props.initialInputText
	local searchPlaceholderText = props.searchPlaceholderText
	local cancelText = props.cancelText
	local onCancel = props.onCancel
	local onSubmit = props.onSubmit
	local captureFocusOnMount = props.captureFocusOnMount

	local ref = React.useRef("")
	local ref2 = React.useRef("")

	local textChangedCallback = React.useCallback(function(current: string)
		ref2.current = ref.current
		ref.current = current
	end, {})

	local v = React.useCallback(function()
		if ref.current ~= ref2.current then
			ref2.current = ref.current
			onSubmit(ref.current)
		end
	end, { onSubmit })

	local focusChangedCallback = React.useCallback(function(p, p2)
		if p == false and p2 then
			v()
		end
	end, { v })

	local returnPressedFromOnScreenKeyboardCallback = React.useCallback(function()
		v()
	end, { v })

	return React.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, {
		maxSize = React.createElement("UISizeConstraint", { MaxSize = Vector2.new(400, 1e999) }),
		userSearchBar = React.createElement(UserSearchBar, {
			initialInputText = initialInputText,
			cancelText = cancelText,
			searchPlaceholderText = searchPlaceholderText,
			captureFocusOnMount = captureFocusOnMount,
			cancelCallback = onCancel,
			textChangedCallback = textChangedCallback,
			focusChangedCallback = focusChangedCallback,
			returnPressedFromOnScreenKeyboardCallback = returnPressedFromOnScreenKeyboardCallback
		})
	})
end

return UserSearchHeaderInput
