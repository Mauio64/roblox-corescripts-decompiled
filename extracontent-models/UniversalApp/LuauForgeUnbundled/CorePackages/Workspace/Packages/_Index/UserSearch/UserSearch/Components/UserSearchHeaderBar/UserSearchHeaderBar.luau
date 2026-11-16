local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox")
local headerBar = UIBlox.App.Bar.HeaderBar
local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images

local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/AppHeaderBar")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Localization").Hooks.useLocalization

local UserSearchHeaderInput = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchHeaderBar/UserSearchHeaderInput")

local fFlagUserSearchGoBackOnCancel = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchGoBackOnCancel

local function UserSearchHeaderBar(props)
	local searchKeyword = props.searchKeyword
	local onSubmitSearch = props.onSubmitSearch
	local onBackClick = props.onBackClick
	local focusOnSearchInput = props.focusOnSearchInput
	local headerHeight = props.headerHeight

	local v5 = useLocalization({
		titleText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization",
		placeholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization",
		cancelText = "Feature.Chat.Action.Cancel"
	})

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(focusOnSearchInput)
	local state3, setState3 = React.useState(searchKeyword)

	local v6 = React.useCallback(function()
		setState(true)
		setState2(true)
	end, {})

	local function fn()
		if fFlagUserSearchGoBackOnCancel then
			setState3("")
			onBackClick()
		else
			setState(false)
			setState3("")
		end
	end

	local v9 = React.useCallback(fn, { if fFlagUserSearchGoBackOnCancel then onBackClick else nil })

	local v10 = React.useMemo(function()
		if state then
			return function() end
		end

		return AppHeaderBar.makeBackButton(function()
			onBackClick()
		end)
	end, { state, onBackClick })

	local v11 = React.useCallback(function()
		if state then
			return React.createElement(UserSearchHeaderInput, {
				initialInputText = state3,
				searchPlaceholderText = v5.placeholderText,
				cancelText = v5.cancelText,
				captureFocusOnMount = state2,
				onSubmit = onSubmitSearch,
				onCancel = v9
			})
		end

		return nil
	end, {
		state,
		searchKeyword,
		state2,
		onSubmitSearch,
		v9,
		v5.placeholderText,
		v5.cancelText
	})

	local v12 = React.useCallback(function()
		if state then
			return nil
		end

		return React.createElement(iconButton, {
			size = UDim2.fromOffset(0, 0),
			icon = images["icons/common/search"],
			onActivated = v6
		})
	end, { state, v6 })

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, headerHeight)
		},
		{
			headerBar = React.createElement(headerBar, {
				title = v5.titleText,
				renderLeft = v10,
				renderCenter = v11,
				renderRight = v12,
				shouldHideSecondaryLeftItem = state,
				barHeight = headerHeight,
				isSecondary = true,
				paddingTop = UDim.new(0, 0),
				paddingBottom = UDim.new(0, 0)
			})
		}
	)
end

return UserSearchHeaderBar
