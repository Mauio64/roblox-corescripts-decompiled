local module = require("@luauforge/bundled/fwe")
local useLocalization = require("@luauforge/bundled/fwf").Hooks.useLocalization
local module2 = require("@luauforge/bundled/fwg")
local emptyState = module2.App.Indicator.EmptyState
local images = module2.App.ImageSet.Images
local module3 = require("@luauforge/bundled/fwh")
local sduiPageEntryPoint = module3.SduiPageEntryPoint
local sduiLoadTimer = module3.SduiLoadTimer
local getSduiApiStore = module3.getSduiApiStore
local appPage = require("@luauforge/bundled/fwi").AppPage
local compositionTags = require("@luauforge/bundled/fwj").CompositionTags
local fFlagSduiPageEntryPointResolvedSlot = require("@luauforge/bundled/fwk").FFlagSduiPageEntryPointResolvedSlot
local fFlagSduiReleaseSearchResultsPageState = require("@luauforge/bundled/fwk").FFlagSduiReleaseSearchResultsPageState

local module4 = require("@luauforge/bundled/fwl")
local module5 = require("@luauforge/bundled/fwq")
local module6 = require("@luauforge/bundled/fwt")

local searchPage = appPage.SearchPage
local iconsstatusoof_xlarge = images["icons/status/oof_xlarge"]

local function SduiSearchResultsPage(props)
	local searchKeyword = props.searchKeyword
	local searchUuid = props.searchUuid
	local globalSessionId = props.globalSessionId
	local pageTopPadding = props.pageTopPadding
	local v5 = module5(searchUuid)

	local v6 = module.useMemo(function()
		return sduiLoadTimer.createLoadTimer(searchPage)
	end, { v5 })

	module.useEffect(function()
		if searchKeyword and searchKeyword ~= "" then
			module4(searchKeyword, searchUuid, globalSessionId, v6)
		end
	end, { searchKeyword, searchUuid, globalSessionId, v6 })

	if fFlagSduiReleaseSearchResultsPageState then
		module.useEffect(function()
			return function()
				getSduiApiStore().releaseConfigKey(v5)
			end
		end, { v5 })
	end

	local v7 = module.useCallback(function()
		if searchKeyword and searchKeyword ~= "" then
			local loadTimer = sduiLoadTimer.createLoadTimer(searchPage)
			loadTimer.start("refresh")
			module4(searchKeyword, searchUuid, globalSessionId, loadTimer, true)
		end
	end, { searchKeyword, searchUuid, globalSessionId })

	local v8 = module6(v5)

	local v9 = useLocalization({ noResultsFound = "CommonUI.Controls.NoResultsFound" })

	if not searchKeyword or searchKeyword == "" then
		return nil
	end

	local createElement = module.createElement
	local v11 = {
		appPage = searchPage,
		configKey = v5,
		pageTimer = v6,
		includeNavigationHeaderBar = false,
		refresh = v7,
		contentTag = compositionTags.ContentRegion.Body,
		pageTopPadding = 0,
		resolvedSlot = 0,
		onScrollDirectionChanged = 0
	}

	if v8 then
		pageTopPadding = nil
	end

	v11.pageTopPadding = pageTopPadding

	local v12 = if fFlagSduiPageEntryPointResolvedSlot and v8 then module.createElement(emptyState, {
		icon = iconsstatusoof_xlarge,
		text = v9.noResultsFound
	}) else nil
	v11.resolvedSlot = v12

	v11.onScrollDirectionChanged = props.onScrollDirectionChanged
	return createElement(sduiPageEntryPoint, v11)
end

return module.memo(SduiSearchResultsPage)
