local Parent = script:FindFirstAncestor("ConnectionsHub").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Sources = require(Parent.SocialLuaAnalytics).Analytics.Enums.Sources
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local getPageMargin = require(Parent.UIBlox).App.Container.getPageMargin
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local AppHeaderBar = require(Parent.AppHeaderBar)
local UserSearchBarButton = require(Parent.SocialCommon).Components.UserSearchBar.UserSearchBarButton
local useNavigation = require(Parent.Navigation).useNavigation

local function ConnectionsHubHeader() -- line: 23
	-- upvalues: useTokens (copy), useScreenSize (copy), useNavigation (copy), getPageMargin (copy), React (copy), AppHeaderBar (copy), View (copy), AppPage (copy), Sources (copy), UserSearchBarButton (copy)
	local v14 = useTokens()
	local v15 = useScreenSize()
	local v16 = useNavigation()
	local v17 = getPageMargin(v15.X)
	local Size_1200 = v14.Size.Size_1200
	local v19 = React.useCallback(function() -- line: 32
		-- upvalues: v16 (copy)
		v16.goBack()
	end, { v16 })
	local v20 = React.useMemo(function() -- line: 36
		-- upvalues: AppHeaderBar (copy), v19 (copy)
		return AppHeaderBar.makeBackButton(v19)
	end, { v19 })
	local v21 = React.useMemo(function() -- line: 40
		-- upvalues: React (copy), View (copy), v20 (copy)
		return React.createElement(View, {
			tag = "size-0 auto-xy align-x-left",
			LayoutOrder = 1
		}, {
			button = v20()
		})
	end, { v20 })
	local v22 = React.useCallback(function() -- line: 49
		-- upvalues: v16 (copy), AppPage (copy), Sources (copy)
		v16.navigate(AppPage.UserSearch, {
			shouldShowUserSearchLandingPage = true,
			entryPoint = Sources.ConnectionsHub
		})
	end, { v16 })
	local v23 = React.useMemo(function() -- line: 56
		-- upvalues: React (copy), View (copy), UserSearchBarButton (copy), v22 (copy)
		return React.createElement(View, {
			tag = "size-full-0 auto-y fill align-x-center",
			LayoutOrder = 2
		}, {
			bar = React.createElement(UserSearchBarButton, {
				onActivated = v22
			})
		})
	end, { v22 })

	return React.createElement(View, {
		tag = "row fill align-y-center gap-medium",
		Size = UDim2.new(1, 0, 0, Size_1200)
	}, {
		pageMargins = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v17),
			PaddingRight = UDim.new(0, v17)
		}),
		backButton = v21,
		searchBar = v23
	})
end

return ConnectionsHubHeader
