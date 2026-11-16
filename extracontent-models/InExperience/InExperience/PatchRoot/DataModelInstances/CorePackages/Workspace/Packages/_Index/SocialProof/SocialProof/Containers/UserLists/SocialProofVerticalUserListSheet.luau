local parent = script:FindFirstAncestor("SocialProof").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RoactUtils = require(parent.RoactUtils)

local UserList = require(parent.UserList)
local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local EntityType = UserList.Enums.EntityType

local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux2.Thunks.NavigateBack
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps

local Dash = require(parent.Dash)

local snapPoints = { 0.7 }

local function SocialProofVerticalUserListSheet()
	local v = useDispatch()
	local v2 = useNavigationProps(function(_, p)
		return { userIds = p.userIds, title = p.title }
	end)

	local v3 = useTokens()

	local title = v2.title

	local entities = React.useMemo(function()
		return Dash.map(v2.userIds, function(p)
			return { id = tostring(p), type = EntityType.User }
		end)
	end, { v2.userIds })

	local onRowSelected = React.useCallback(function(detail: string, _)
		local v4 = {
			name = AppPage.ProfilePlatform,
			detail = detail,
			extraProps = { profileType = EntityType.User }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
			navigationCommands.down(navigationCommands.fromLegacyPage(v4), true)
		else
			v(NavigateBack(true))
			v(NavigateDown(v4, true))
		end
	end, { v, NavigateBack, NavigateDown })

	local onClose = React.useCallback(function(p)
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(p)
		else
			v(NavigateBack(p))
		end
	end, { v, NavigateBack })

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = onClose,
		snapPoints = snapPoints
	}, {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(View, { tag = "size-full auto-xy align-x-center" }, {
				TitleText = React.createElement(Text, {
					tag = "auto-xy text-align-x-left",
					Text = title,
					fontStyle = v3.Typography.HeadingSmall,
					textStyle = v3.Color.Content.Emphasis,
					RichText = true
				})
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			UserListContainer = React.createElement(View, { tag = "size-full auto-y" }, {
				UserList = React.createElement(VerticalUserList, {
					entities = entities,
					onRowSelected = onRowSelected,
					initialRowCount = #v2.userIds
				})
			})
		})
	})
end

return SocialProofVerticalUserListSheet
