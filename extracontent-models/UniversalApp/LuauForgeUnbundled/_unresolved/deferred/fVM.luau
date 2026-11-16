require("@luauforge/deferred/fUR")

local EVENT_TYPES = require("@luauforge/deferred/fUP").Constants.EVENT_TYPES

local module = require("@luauforge/deferred/fUU")
local useCallback = module.useCallback
local appPage = require("@luauforge/deferred/fVw").AppPage
local navigateDown = require("@luauforge/deferred/fVx").Thunks.NavigateDown
local urlBuilder = require("@luauforge/deferred/fVy").UrlBuilder

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/fVf").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/fVz").NavigationCommands else nil

local module2 = require("@luauforge/deferred/fUV")
local text = module2.Text
local view = module2.View
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize

local module3 = require("@luauforge/deferred/fVN")
local module4 = require("@luauforge/deferred/fUZ")

local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext
local module5 = require("@luauforge/deferred/fVA")

local STATIC_PAGE_NAMES = require("@luauforge/deferred/fUY").STATIC_PAGE_NAMES

local fFlagNavigateToSafetyDashboardForAppeals = require("@luauforge/deferred/fVf").FFlagNavigateToSafetyDashboardForAppeals
local module6 = require("@luauforge/deferred/fVG")

local function ReportMistake(props)
	local v5 = useNotApprovedPageContext()
	local translations = v5.translations
	local isKidsTreatment = v5.isKidsTreatment
	local dispatch = props.dispatch
	local violation = props.moderationDetail.violation
	local v6

	if fFlagNavigateToSafetyDashboardForAppeals then
		v6 = module3(violation)
	else
		v6 = urlBuilder.static.appealsPortal.main()
	end

	local v7

	if module6 then
		local v9

		if fFlagNavigateToSafetyDashboardForAppeals then
			v9 = translations.accountStatusTitle
		else
			v9 = translations.appealsPortalTitle
		end

		v7 = module5(v6, v9)
	else
		v7 = nil
	end

	local v8 = useCallback(function()
		module4({ eventType = EVENT_TYPES.AppealsPortalClicked })

		if module6 and v7 then
			v7()
			return
		end

		local v9 = { name = appPage.GenericWebPage, detail = v6, extraProps = 0 }

		local v11 = if fFlagNavigateToSafetyDashboardForAppeals then translations.accountStatusTitle else translations.appealsPortalTitle
		v9.extraProps = { title = v11 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			dispatch(navigateDown(v9))
		end
	end, { v6, dispatch, v7, translations })

	local createElement = module.createElement
	local v10 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = module.createElement

	local v13 = if isKidsTreatment then translations.reportMistakeDescriptionKids else translations.reportMistakeDescriptionV3
	return createElement(view, v10, {
		Content = createElement2(text, {
			Text = v13,
			tag = "auto-xy text-body-large text-wrap text-align-x-left",
			LayoutOrder = 2
		}),
		ReportMistakeButton = module.createElement(button, {
			text = translations.sendAppealButton,
			onActivated = v8,
			variant = buttonVariant.Standard,
			size = inputSize.Small,
			width = UDim.new(1, 0),
			LayoutOrder = 3
		})
	})
end

return {
	getIsVisible = function(p2, p3, p4, p5): boolean
		local v5 = if p5 then p5.educational_pass_eligible else false

		return (p4 or STATIC_PAGE_NAMES.Unknown) == STATIC_PAGE_NAMES.SecondChanceIntro or not v5
	end,
	renderComponent = module.memo(ReportMistake)
}
