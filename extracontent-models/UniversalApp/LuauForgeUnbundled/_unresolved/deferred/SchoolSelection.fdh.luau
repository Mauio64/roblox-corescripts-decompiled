local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module3 = require("@luauforge/deferred/fbW")
require("@luauforge/deferred/ekr")
local module4 = require("@luauforge/deferred/ekv")
local module5 = require("@luauforge/deferred/fdi")
local module6 = require("@luauforge/deferred/fdj")
local module7 = require("@luauforge/deferred/fcy")
local module8 = require("@luauforge/deferred/fdk")
local module9 = require("@luauforge/deferred/fdl")
local module10 = require("@luauforge/deferred/fdm")
local module11 = require("@luauforge/deferred/fcz")

local text = Foundation.Text

local function SchoolSelection(props)
	local v5 = useLocalization({
		headerTitle = module4.AddSchoolHeading,
		heading = module4.ConfirmSchoolLabel,
		searchPlaceholder = module4.SearchPlaceholder,
		cantFindAction = module4.CantFindSchoolAction
	})

	local createElement = module.createElement
	local fragment = module.Fragment
	local createElement2 = module.createElement
	local v9 = {
		title = v5.headerTitle,
		onBack = props.onBack,
		fillContent = true,
		testId = "schools-selection-page"
	}

	local children = {
		Heading = module.createElement(text, {
			LayoutOrder = 1,
			Text = v5.heading,
			tag = "size-full-0 auto-y padding-bottom-xsmall text-heading-medium text-wrap text-align-x-left content-emphasis"
		}),
		Search = 0,
		List = 0
	}

	local createElement3 = module.createElement
	local v11 = {
		layoutOrder = 2,
		query = props.query,
		placeholder = v5.searchPlaceholder,
		onQueryChanged = props.onQueryChanged,
		onFocusLost = 0
	}
	local v12 = if module5 then props.onSearchFocusLost else nil
	v11.onFocusLost = v12
	children.Search = createElement3(module8, v11)

	local createElement4 = module.createElement
	local v14 = {
		layoutOrder = 3,
		schools = props.schools,
		selectedSchoolId = props.selectedSchoolId,
		onSchoolSelected = props.onSchoolSelected,
		onSchoolImpression = 0,
		onScrollStarted = 0,
		onCantFindSchool = 0,
		cantFindAction = 0
	}
	local v15 = if module5 then props.onSchoolImpression else nil
	v14.onSchoolImpression = v15
	local v16 = if module5 then props.onScrollStarted else nil
	v14.onScrollStarted = v16
	v14.onCantFindSchool = props.onCantFindSchool
	v14.cantFindAction = v5.cantFindAction
	children.List = createElement4(module9, v14)
	local v7 = {
		Page = createElement2(module3, v9, children),
		CantFindDialog = 0
	}
	local v17

	if module6 then
		v17 = module.createElement(module11, {
			isOpen = props.isCantFindSchoolOpen,
			onClose = props.onDismissCantFindSchool,
			entryPoint = module7 and "schoolSelection" or nil
		})
	elseif props.isCantFindSchoolOpen then
		v17 = module.createElement(module10, {
			onDismiss = props.onDismissCantFindSchool
		})
	end

	v7.CantFindDialog = v17
	return createElement(fragment, nil, v7)
end

return SchoolSelection
