local Parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local AppHeaderBar = require(Parent.AppHeaderBar)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UserSearchHeaderInput = require(script.Parent.UserSearchHeaderInput)
local FFlagUserSearchGoBackOnCancel = require(Parent.SharedFlags).FFlagUserSearchGoBackOnCancel

local function UserSearchHeaderBar(t1: {[any]: any}) -- line: 28
	-- upvalues: useLocalization (copy), React (copy), FFlagUserSearchGoBackOnCancel (copy), AppHeaderBar (copy), UserSearchHeaderInput (copy), IconButton (copy), Images (copy), HeaderBar (copy)
	local searchKeyword = t1.searchKeyword
	local onSubmitSearch = t1.onSubmitSearch
	local onBackClick = t1.onBackClick
	local focusOnSearchInput = t1.focusOnSearchInput
	local headerHeight = t1.headerHeight
	local v18 = useLocalization({
		titleText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeople",
		placeholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeople",
		cancelText = "Feature.Chat.Action.Cancel"
	})
	local v19, v20 = React.useState(true)
	local v21, v22 = React.useState(focusOnSearchInput)
	local v23, v24 = React.useState(searchKeyword)
	local v25 = React.useCallback(function() -- line: 45
		-- upvalues: v20 (copy), v22 (copy)
		v20(true)
		v22(true)
	end, {})
	local v26 = React.useCallback(function() -- line: 50
		-- upvalues: FFlagUserSearchGoBackOnCancel (copy), v24 (copy), onBackClick (copy), v20 (copy)
		if FFlagUserSearchGoBackOnCancel then
			v24("")
			onBackClick()

			return
		end

		v20(false)
		v24("")
	end, { if not FFlagUserSearchGoBackOnCancel then nil else onBackClick })
	local v27 = React.useMemo(function() -- line: 60
		-- upvalues: v19 (copy), AppHeaderBar (copy), onBackClick (copy)
		if v19 then
			return function() -- line: 62
			end
		end

		return AppHeaderBar.makeBackButton(function() -- line: 64
			-- upvalues: onBackClick (copy)
			onBackClick()
		end)
	end, {
		v19,
		onBackClick
	})
	local v28 = React.useCallback(function() -- line: 70
		-- upvalues: v19 (copy), React (copy), UserSearchHeaderInput (copy), v23 (copy), v18 (copy), v21 (copy), onSubmitSearch (copy), v26 (copy)
		if not v19 then
			return nil
		end

		return React.createElement(UserSearchHeaderInput, {
			initialInputText = v23,
			searchPlaceholderText = v18.placeholderText,
			cancelText = v18.cancelText,
			captureFocusOnMount = v21,
			onSubmit = onSubmitSearch,
			onCancel = v26
		})
	end, {
		v19,
		searchKeyword,
		v21,
		onSubmitSearch,
		v26,
		v18.placeholderText,
		v18.cancelText
	})
	local v29 = React.useCallback(function() -- line: 94
		-- upvalues: v19 (copy), React (copy), IconButton (copy), Images (copy), v25 (copy)
		if v19 then
			return nil
		end

		return React.createElement(IconButton, {
			size = UDim2.fromOffset(0, 0),
			icon = Images["icons/common/search"],
			onActivated = v25
		})
	end, {
		v19,
		v25
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, headerHeight)
	}, {
		headerBar = React.createElement(HeaderBar, {
			isSecondary = true,
			title = v18.titleText,
			renderLeft = v27,
			renderCenter = v28,
			renderRight = v29,
			shouldHideSecondaryLeftItem = v19,
			barHeight = headerHeight,
			paddingTop = UDim.new(0, 0),
			paddingBottom = UDim.new(0, 0)
		})
	})
end

return UserSearchHeaderBar
