local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Foundation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoactUtils")

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/UserList")
local verticalUserList = module4.VerticalUserList.VerticalUserList
local entityType = module4.Enums.EntityType

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateDown
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppEnums").AppPage

local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").useNavigationProps

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Dash")

local v5 = { 0.7 }

local function SocialProofVerticalUserListSheet()
	local v6 = useDispatch()
	local v7 = useNavigationProps(function(p2, p3)
		return { userIds = p3.userIds, title = p3.title }
	end)

	local v8 = useTokens()

	local title = v7.title

	local v9 = React.useMemo(function()
		return Dash.map(v7.userIds, function(p2)
			return { id = tostring(p2), type = entityType.User }
		end)
	end, { v7.userIds })

	local v10 = React.useCallback(function(p2, p3)
		local v11 = {
			name = appPage.ProfilePlatform,
			detail = p2,
			extraProps = { profileType = entityType.User }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
			navigationCommands.down(navigationCommands.fromLegacyPage(v11), true)
		else
			v6(navigateBack(true))
			v6(navigateDown(v11, true))
		end
	end, { v6, navigateBack, navigateDown })

	local v11 = React.useCallback(function(p2)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(p2)
		else
			v6(navigateBack(p2))
		end
	end, { v6, navigateBack })

	return React.createElement(sheet.Root, {
		preferCenterSheet = true,
		onClose = v11,
		snapPoints = v5
	}, {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(view, {
				tag = "size-full auto-xy align-x-center"
			}, {
				TitleText = React.createElement(text, {
					tag = "auto-xy text-align-x-left",
					Text = title,
					fontStyle = v8.Typography.HeadingSmall,
					textStyle = v8.Color.Content.Emphasis,
					RichText = true
				})
			})
		}),
		Content = React.createElement(sheet.Content, nil, {
			UserListContainer = React.createElement(view, { tag = "size-full auto-y" }, {
				UserList = React.createElement(verticalUserList, {
					entities = v9,
					onRowSelected = v10,
					initialRowCount = #v7.userIds
				})
			})
		})
	})
end

return SocialProofVerticalUserListSheet
