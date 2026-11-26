local module = require("@luauforge/bundled/fDZ")
local appPage = require("@luauforge/bundled/fEa").AppPage
local module2 = require("@luauforge/bundled/fEb")
require("@luauforge/bundled/fEc")
local module3 = require("@luauforge/bundled/fEd")
local module4 = require("@luauforge/bundled/fEe")
local module5 = require("@luauforge/bundled/fEf")
local module6 = require("@luauforge/bundled/fEg")
local useLocalization = require("@luauforge/bundled/fEh").Hooks.useLocalization
local fFlagSduiPageEntryUseSharedHooks = require("@luauforge/bundled/fEi").FFlagSduiPageEntryUseSharedHooks

local module7 = require("@luauforge/bundled/fEj")
local module8 = require("@luauforge/bundled/fEl")
local module9 = require("@luauforge/bundled/fEn")

local compositionTags = module.CompositionTags
local sduiFeatureEntryPoint = module5.SduiFeatureEntryPoint
local sduiLoadTimer = module5.SduiLoadTimer
local sduiPageEntryPoint = module5.SduiPageEntryPoint
local sduiPageNavigationHeader = module5.SduiPageNavigationHeader
local getSduiApiStore = module5.getSduiApiStore
local useComponentConfig = module5.useComponentConfig
local alertSeverity = module2.Enums.AlertSeverity
local systemBanner = module2.SystemBanner
local view = module2.View

local overviewEntry = module7.OverviewEntry

local function resolveScope(routeName, param)
	if routeName == appPage.UserLibrary then
		return { kind = "library" }
	end

	if routeName == appPage.UserLibraryCollection and param then
		return { kind = "collection", libraryCollectionId = param }
	end

	return nil
end

local function getEntryKey(p2, p3)
	return `{p2}_{p3}`
end

local function LibraryPage(props)
	local scope = props.scope
	local page = props.page
	local surfaceKey = page.surfaceKey
	local v5 = module9(scope, page)
	local overviewConfigKey = v5.overviewConfigKey

	local v6 = useLocalization({ myLibrary = "Feature.UserLibrary.Label.MyLibrary" })

	local v7 = module3.useMemo(function()
		local loadTimer = sduiLoadTimer.createLoadTimer(surfaceKey)
		loadTimer.start("mount")
		return loadTimer
	end, { surfaceKey, overviewConfigKey })

	module3.useEffect(function()
		module8(scope, "VIEW_ALL", v7)
	end, { scope, v7 })
	local formatted = `{overviewConfigKey}_{overviewEntry.Header}`
	local v8 = module3.useCallback(function(p2)
		return getSduiApiStore().getTitle(overviewConfigKey, p2, formatted)
	end, { overviewConfigKey, formatted })
	local v9 = module6.useSignalState(v8)

	local v10 = useComponentConfig(overviewConfigKey, overviewEntry.Pills) ~= nil

	local v11 = v10 and v5.view ~= "VIEW_ALL"
	local v12 = not v11 and "VIEW_ALL" or v5.view
	local v13 = if v11 then v5.configKey else overviewConfigKey

	local v14 = module3.useCallback(function()
		local loadTimer = sduiLoadTimer.createLoadTimer(surfaceKey)
		loadTimer.start("refresh")
		module8(scope, v12, loadTimer, true)
	end, { scope, v12, surfaceKey })

	local v15 = module3.useCallback(function()
		return module3.createElement(sduiFeatureEntryPoint, {
			appPage = surfaceKey,
			configKey = overviewConfigKey,
			identifier = overviewEntry.Header,
			AutomaticSize = Enum.AutomaticSize.XY,
			shouldDisplayError = false,
			shouldDisplayLoading = false
		})
	end, { surfaceKey, overviewConfigKey })

	local createElement = module3.createElement
	local createElement2 = module3.createElement

	if not v9 then
		v9 = if scope.kind == "library" then v6.myLibrary else nil
	end

	local children = {
		Header = createElement2(sduiPageNavigationHeader, {
			title = v9,
			contentTag = compositionTags.ContentRegion.Header,
			layoutOrder = 1,
			renderUtilities = v15,
			navButtonType = "back",
			closeCallback = props.goBack
		}),
		Pills = 0,
		Body = 0
	}
	local v20

	if v10 then
		v20 = module3.createElement(view, {
			tag = {
				[compositionTags.ContentRegion.Header] = true,
				["size-full-0 auto-y bg-surface-0"] = true
			},
			LayoutOrder = 2
		}, {
			Entry = module3.createElement(sduiFeatureEntryPoint, {
				appPage = surfaceKey,
				configKey = overviewConfigKey,
				identifier = overviewEntry.Pills,
				shouldDisplayError = false,
				shouldDisplayLoading = false
			})
		})
	end

	children.Pills = v20

	local createElement3 = module3.createElement
	local createElement4 = module3.createElement
	local v25 = {
		key = v13,
		appPage = surfaceKey,
		configKey = v13,
		identifier = 0,
		pageTimer = 0,
		refresh = 0,
		includeNavigationHeaderBar = false,
		contentTag = 0
	}
	local v26

	if not v11 then
		if fFlagSduiPageEntryUseSharedHooks then
			v26 = overviewEntry.Content
		else
			v26 = `{overviewConfigKey}_{overviewEntry.Content}`
		end
	end

	v25.identifier = v26

	local v27 = if v11 then v5.listPageTimer or v7 else v7
	v25.pageTimer = v27
	v25.refresh = v14

	v25.contentTag = compositionTags.ContentRegion.Body
	children.Body = createElement3(view, { tag = "fill size-full-0", LayoutOrder = 3 }, {
		Entry = createElement4(sduiPageEntryPoint, v25)
	})
	return createElement(view, { tag = "col size-full bg-surface-0" }, children)
end

local function UserLibraryScreen(p2)
	local navigation = p2.navigation
	local routeName = navigation.state.routeName
	local param = navigation.getParam("libraryCollectionId", nil)
	local v5 = module3.useMemo(function()
		return resolveScope(routeName, param)
	end, { routeName, param })
	local v6 = if v5 then module7.getPage(v5) else nil

	local v7 = useLocalization({
		errorTitle = "CommonUI.Messages.Response.PageError",
		errorDescription = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	module3.useEffect(function()
		if v5 == nil or v6 == nil then
			warn(`UserLibrary: route {routeName} has no page to show (libraryCollectionId: {param})`)
		end
	end, { v5, v6, routeName, param })

	local v8 = module3.useCallback(function()
		navigation.dispatch(module4.Actions.back(nil))
	end, { navigation })

	if v5 == nil or v6 == nil then
		return module3.createElement(view, { tag = "col size-full bg-surface-0" }, {
			Header = module3.createElement(sduiPageNavigationHeader, {
				layoutOrder = 1,
				contentTag = compositionTags.ContentRegion.Header,
				navButtonType = "back",
				closeCallback = v8
			}),
			Error = module3.createElement(systemBanner, {
				LayoutOrder = 2,
				severity = alertSeverity.Error,
				title = v7.errorTitle,
				description = v7.errorDescription
			})
		})
	end

	return module3.createElement(LibraryPage, {
		key = module7.getConfigKey(v6, v5, "VIEW_ALL"),
		scope = v5,
		page = v6,
		goBack = v8
	})
end

return UserLibraryScreen
