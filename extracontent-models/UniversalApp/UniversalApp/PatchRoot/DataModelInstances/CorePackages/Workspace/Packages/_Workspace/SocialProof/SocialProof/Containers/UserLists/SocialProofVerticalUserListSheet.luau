local Parent = script:FindFirstAncestor("SocialProof").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local RoactUtils = require(Parent.RoactUtils)
local UserList = require(Parent.UserList)
local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local EntityType = UserList.Enums.EntityType
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local useNavigationProps = require(Parent.RobloxAppNavigation).useNavigationProps
local Dash = require(Parent.Dash)
local t1 = { 0.7 }

local function SocialProofVerticalUserListSheet() -- line: 39
	-- upvalues: useDispatch (copy), useNavigationProps (copy), useTokens (copy), React (copy), Dash (copy), EntityType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateBack (copy), NavigateDown (copy), Sheet (copy), t1 (copy), View (copy), FoundationText (copy), VerticalUserList (copy)
	local v22 = useDispatch()
	local v23 = useNavigationProps(function(_, p2) -- line: 41
		return {
			userIds = p2.userIds,
			title = p2.title
		}
	end)
	local v24 = useTokens()
	local title = v23.title
	local v26 = React.useMemo(function() -- line: 53
		-- upvalues: Dash (copy), v23 (copy), EntityType (copy)
		return Dash.map(v23.userIds, function(p3) -- line: 54
			-- upvalues: EntityType (copy)
			return {
				id = tostring(p3),
				type = EntityType.User
			}
		end)
	end, { v23.userIds })
	local v27 = React.useCallback(function(s1: string, _) -- line: 63
		-- upvalues: AppPage (copy), EntityType (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v22 (copy), NavigateBack (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.ProfilePlatform,
			detail = s1,
			extraProps = {
				profileType = EntityType.User
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v11.back(true)
			v11.down(v11.fromLegacyPage(t2), true)

			return
		end

		v22(NavigateBack(true))
		v22(NavigateDown(t2, true))
	end, {
		v22,
		NavigateBack,
		NavigateDown
	})
	local v28 = React.useCallback(function(p5) -- line: 80
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), v22 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v11.back(p5)

			return
		end

		v22(NavigateBack(p5))
	end, {
		v22,
		NavigateBack
	})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = v28,
		snapPoints = t1
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			Title = React.createElement(View, {
				tag = "size-full auto-xy align-x-center"
			}, {
				TitleText = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left",
					RichText = true,
					Text = title,
					fontStyle = v24.Typography.HeadingSmall,
					textStyle = v24.Color.Content.Emphasis
				})
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			UserListContainer = React.createElement(View, {
				tag = "size-full auto-y"
			}, {
				UserList = React.createElement(VerticalUserList, {
					entities = v26,
					onRowSelected = v27,
					initialRowCount = #v23.userIds
				})
			})
		})
	})
end

return SocialProofVerticalUserListSheet
