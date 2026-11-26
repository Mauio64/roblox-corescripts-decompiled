local appPage = require("@luauforge/deferred/emP").AppPage
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/SocialLuaAnalytics").Analytics.Enums.Sources
local module = require("@luauforge/deferred/emL")

local module2 = require("@luauforge/deferred/emM")
local useTokens = module2.Hooks.useTokens
local view = module2.View

local getPageMargin = require("@luauforge/deferred/emR").App.Container.getPageMargin

local useScreenSize = require("@luauforge/deferred/emS").useScreenSize

local module3 = require("@luauforge/deferred/emT")
local userSearchBarButton = require("@luauforge/deferred/emU").Components.UserSearchBar.UserSearchBarButton

local useNavigation = require("@luauforge/deferred/emV").useNavigation

local function ConnectionsHubHeader()
	local v5 = useTokens()
	local v6 = useScreenSize()
	local v7 = useNavigation()

	local pageMargin = getPageMargin(v6.X)

	local size_1200 = v5.Size.Size_1200

	local v8 = module.useCallback(function()
		v7.goBack()
	end, { v7 })

	local v9 = module.useMemo(function()
		return module3.makeBackButton(v8)
	end, { v8 })

	local v10 = module.useMemo(function()
		return module.createElement(view, {
			tag = "size-0 auto-xy align-x-left",
			LayoutOrder = 1
		}, {
			button = v9()
		})
	end, { v9 })

	local v11 = module.useCallback(function()
		v7.navigate(appPage.UserSearch, {
			entryPoint = sources.ConnectionsHub,
			shouldShowUserSearchLandingPage = true
		})
	end, { v7 })

	local v12 = module.useMemo(function()
		return module.createElement(
			view,
			{ tag = "size-full-0 auto-y fill align-x-center", LayoutOrder = 2 },
			{
				bar = module.createElement(userSearchBarButton, { onActivated = v11 })
			}
		)
	end, { v11 })

	return module.createElement(
		view,
		{
			tag = "row fill align-y-center gap-medium",
			Size = UDim2.new(1, 0, 0, size_1200)
		},
		{
			pageMargins = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, pageMargin),
				PaddingRight = UDim.new(0, pageMargin)
			}),
			backButton = v10,
			searchBar = v12
		}
	)
end

return ConnectionsHubHeader
