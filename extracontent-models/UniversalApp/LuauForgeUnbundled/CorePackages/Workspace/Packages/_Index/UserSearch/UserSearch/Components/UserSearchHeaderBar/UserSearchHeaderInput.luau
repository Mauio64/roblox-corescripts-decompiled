local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local userSearchBar = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialCommon").Components.UserSearchBar.UserSearchBar

local function UserSearchHeaderInput(props)
	local initialInputText = props.initialInputText
	local searchPlaceholderText = props.searchPlaceholderText
	local cancelText = props.cancelText
	local onCancel = props.onCancel
	local onSubmit = props.onSubmit
	local captureFocusOnMount = props.captureFocusOnMount

	local ref = React.useRef("")
	local ref2 = React.useRef("")

	local v5 = React.useCallback(function(current)
		ref2.current = ref.current
		ref.current = current
	end, {})

	local v6 = React.useCallback(function()
		if ref.current ~= ref2.current then
			ref2.current = ref.current
			onSubmit(ref.current)
		end
	end, { onSubmit })

	local v7 = React.useCallback(function(p2, p3)
		if p2 == false and p3 then
			v6()
		end
	end, { v6 })

	local v8 = React.useCallback(function()
		v6()
	end, { v6 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		maxSize = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(400, 1e999)
		}),
		userSearchBar = React.createElement(userSearchBar, {
			initialInputText = initialInputText,
			cancelText = cancelText,
			searchPlaceholderText = searchPlaceholderText,
			captureFocusOnMount = captureFocusOnMount,
			cancelCallback = onCancel,
			textChangedCallback = v5,
			focusChangedCallback = v7,
			returnPressedFromOnScreenKeyboardCallback = v8
		})
	})
end

return UserSearchHeaderInput
