local parent = script:FindFirstAncestor("UserSearch").Parent

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images

local AppHeaderBar = require(parent.AppHeaderBar)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UserSearchHeaderInput = require(script.Parent.UserSearchHeaderInput)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserSearchGoBackOnCancel = SharedFlags.FFlagUserSearchGoBackOnCancel

local function UserSearchHeaderBar(props)
	local searchKeyword = props.searchKeyword
	local onSubmitSearch = props.onSubmitSearch
	local onBackClick = props.onBackClick
	local focusOnSearchInput = props.focusOnSearchInput
	local headerHeight = props.headerHeight

	local v = useLocalization({
		titleText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization",
		placeholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(focusOnSearchInput)
	local state3, setState3 = React.useState(searchKeyword)

	local onActivated = React.useCallback(function()
		setState(true)
		setState2(true)
	end, {})

	local useCallback = React.useCallback
	local function fn()
		if FFlagUserSearchGoBackOnCancel then
			setState3("")
			onBackClick()
		else
			setState(false)
			setState3("")
		end
	end

	local v2

	if FFlagUserSearchGoBackOnCancel then
		v2 = onBackClick
	end

	local onCancel = useCallback(fn, { v2 })

	local renderLeft = React.useMemo(function()
		if state then
			return function() end
		end

		return AppHeaderBar.makeBackButton(function()
			onBackClick()
		end)
	end, { state, onBackClick })

	local renderCenter = React.useCallback(function()
		if state then
			return React.createElement(UserSearchHeaderInput, {
				initialInputText = state3,
				searchPlaceholderText = v.placeholderText,
				cancelText = v.cancelText,
				captureFocusOnMount = state2,
				onSubmit = onSubmitSearch,
				onCancel = onCancel
			})
		end

		return nil
	end, { state, searchKeyword, state2, onSubmitSearch, onCancel, v.placeholderText, v.cancelText })

	local renderRight = React.useCallback(function()
		if state then
			return nil
		end

		return React.createElement(IconButton, {
			size = UDim2.fromOffset(0, 0),
			icon = Images["icons/common/search"],
			onActivated = onActivated
		})
	end, { state, onActivated })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, headerHeight)
	}, {
		headerBar = React.createElement(HeaderBar, {
			title = v.titleText,
			renderLeft = renderLeft,
			renderCenter = renderCenter,
			renderRight = renderRight,
			shouldHideSecondaryLeftItem = state,
			barHeight = headerHeight,
			isSecondary = true,
			paddingTop = UDim.new(0, 0),
			paddingBottom = UDim.new(0, 0)
		})
	})
end

return UserSearchHeaderBar
