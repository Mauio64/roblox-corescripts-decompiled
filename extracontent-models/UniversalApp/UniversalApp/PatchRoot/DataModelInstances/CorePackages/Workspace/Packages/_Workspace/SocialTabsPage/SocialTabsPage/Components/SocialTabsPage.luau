local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local Foundation = require(SocialTabsPageParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local FullscreenPageWithSafeArea = require(SocialTabsPageParent.AppBlox).FullscreenPageWithSafeArea
local useNavigation = require(SocialTabsPageParent.Navigation).useNavigation
local SocialTabsHeader = require(SocialTabsPage.Components.SocialTabsHeader)
local SocialTabBar = require(SocialTabsPage.Components.SocialTabBar)
local SocialTabsContext = require(SocialTabsPage.Contexts.SocialTabsContext)
local useLocalizedTabs = require(SocialTabsPage.Hooks.useLocalizedTabs)

require(SocialTabsPage.Common.Types)

local function SocialTabsPageComponent(p1) -- line: 21
	-- upvalues: React (copy), useLocalizedTabs (copy), useTokens (copy), useNavigation (copy), View (copy), SocialTabsHeader (copy), SocialTabBar (copy), StateLayerAffordance (copy), SocialTabsContext (copy), FullscreenPageWithSafeArea (copy)
	local renderNavigator = p1.renderNavigator
	local renderHeader = p1.renderHeader
	local tabConfig = p1.tabConfig
	local profileId = p1.profileId
	local title = p1.title
	local initialTabId = p1.initialTabId
	local pageWidth = p1.pageWidth
	local v23 = React.useMemo(function() -- line: 30
		-- upvalues: profileId (copy), title (copy)
		return {
			profileId = profileId,
			title = title
		}
	end, {
		profileId,
		title
	})
	local v24 = useLocalizedTabs(tabConfig)
	local v25 = useTokens()
	local v26 = useNavigation()
	local v27 = React.useRef(false)
	local v28 = React.useCallback(function() -- line: 42
		-- upvalues: v26 (copy)
		v26.goBack()
	end, { v26 })

	React.useEffect(function() -- line: 46
		-- upvalues: v27 (copy), initialTabId (copy), tabConfig (copy), v26 (copy)
		if v27.current then
			return
		end

		if not initialTabId or #tabConfig == 0 then
			return
		end

		local v34 = false

		for _, v36 in tabConfig do
			if v36.id == initialTabId then
				v34 = true

				break
			end
		end

		local v37 = if not v34 then tabConfig[1].id else initialTabId

		if v37 ~= v26.state.routes[v26.state.index].routeName then
			v26.navigate(v37)
		end

		v27.current = true
	end, {
		initialTabId,
		tabConfig,
		v26
	})

	local v29 = React.createElement(View, {
		tag = "col size-full"
	}, {
		HeaderSection = React.createElement(View, {
			tag = "col size-full-0 auto-y bg-surface-0",
			LayoutOrder = 1
		}, {
			Header = if not renderHeader then React.createElement(SocialTabsHeader, {
				layoutOrder = 1
			}) else renderHeader(),
			TabBar = React.createElement(SocialTabBar, {
				layoutOrder = 2,
				tabs = v24
			})
		}),
		TabContent = React.createElement(View, {
			tag = "fill size-full-0",
			LayoutOrder = 2
		}, {
			Navigator = renderNavigator()
		})
	})
	local Surface_0Color3, n1, t2

	if pageWidth ~= nil then
		local t1 = {
			affordance = StateLayerAffordance.None
		}

		Surface_0Color3 = v25.Color.Surface.Surface_0.Color3
		n1 = 1
		t2 = {
			ScrimClickHandler = React.createElement(View, {
				tag = "size-full",
				stateLayer = t1,
				onActivated = v28
			}, {
				Panel = React.createElement(View, {
					tag = "col position-top-right anchor-top-right padding-top-xxlarge bg-surface-0",
					Size = UDim2.new(0, pageWidth, 1, 0),
					stateLayer = t1,
					onActivated = function() -- line: 117
					end
				}, {
					Content = v29
				})
			})
		}
	else
		Surface_0Color3 = v25.Color.Surface.Surface_0.Color3
		n1 = v25.Color.Surface.Surface_0.Transparency
		t2 = {
			SocialTabsPageContent = v29
		}
	end

	return React.createElement(SocialTabsContext.Provider, {
		value = v23
	}, {
		Page = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = Surface_0Color3,
			BackgroundTransparency = n1
		}, t2)
	})
end

return SocialTabsPageComponent
