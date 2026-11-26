local module = require("@luauforge/deferred/gzX")

local EVENT_TYPES = require("@luauforge/deferred/gzN").Constants.EVENT_TYPES

local module2 = require("@luauforge/deferred/gzS")
local useCallback = module2.useCallback
local appPage = require("@luauforge/deferred/gAu").AppPage
local navigateDown = require("@luauforge/deferred/gAv").Thunks.NavigateDown
local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gAd").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gAx").NavigationCommands else nil

local module3 = require("@luauforge/deferred/gzT")
local text = module3.Text
local view = module3.View
local button = module3.Button
local buttonVariant = module3.Enums.ButtonVariant
local inputSize = module3.Enums.InputSize

local renderPageItemsFromList = require("@luauforge/deferred/gzW").renderPageItemsFromList

local module4 = require("@luauforge/deferred/gAI")
local module5 = require("@luauforge/deferred/gAh")
local module6 = require("@luauforge/deferred/gAJ")

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext
local module7 = require("@luauforge/deferred/gAy")

local fFlagNavigateToSafetyDashboardForAppeals = require("@luauforge/deferred/gAd").FFlagNavigateToSafetyDashboardForAppeals
local module8 = require("@luauforge/deferred/gAE")

local v5 = { module4, module5, module6 }

local function RecentActivity(props)
	local v6 = useNotApprovedPageContext()
	local translations = v6.translations
	local isKidsTreatment = v6.isKidsTreatment
	local v7

	if fFlagNavigateToSafetyDashboardForAppeals then
		v7 = urlBuilder.static.safetyDashboard.violations()
	else
		v7 = urlBuilder.static.appealsPortal.main()
	end

	local v8

	if module8 then
		local v10

		if fFlagNavigateToSafetyDashboardForAppeals then
			v10 = translations.accountStatusTitle
		else
			v10 = translations.appealsPortalTitle
		end

		v8 = module7(v7, v10)
	else
		v8 = nil
	end

	local interventionId = props.moderationDetail.interventionId
	local consequenceTransparencyMessage = props.moderationDetail.consequenceTransparencyMessage
	local dispatch = props.dispatch

	local v9 = renderPageItemsFromList(v5, props.moderationDetail, props.dispatch)

	local v10 = useCallback(function()
		module({ eventType = EVENT_TYPES.AppealsPortalClicked })

		if module8 and v8 then
			v8()
			return
		end

		local v11 = { name = appPage.GenericWebPage, detail = v7, extraProps = 0 }

		local v13 = if fFlagNavigateToSafetyDashboardForAppeals then translations.accountStatusTitle else translations.appealsPortalTitle
		v11.extraProps = { title = v13 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			dispatch(navigateDown(v11))
		end
	end, { v7, dispatch, v8, translations })

	local createElement = module2.createElement
	local v12 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = module2.createElement

	local v15 = if isKidsTreatment then translations.latestActivityLabelKids else translations.latestActivityLabel
	return createElement(view, v12, {
		Heading = createElement2(text, {
			tag = "auto-xy text-title-large text-wrap text-align-x-left content-emphasis",
			Text = v15,
			LayoutOrder = 1
		}),
		Content = module2.createElement(
			view,
			{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
			{
				EvidenceCard = module2.createElement(
					view,
					{
						tag = "col gap-small size-full-0 auto-y padding-large radius-medium bg-shift-100",
						LayoutOrder = 1
					},
					{
						Evidence = module2.createElement(
							view,
							{ tag = "col size-full-0 auto-y", LayoutOrder = 1 },
							unpack(v9)
						),
						DecisionMethod = consequenceTransparencyMessage ~= "" and module2.createElement(text, {
							tag = "auto-xy text-body-medium text-wrap text-align-x-left",
							Text = `<b>{translations.decisionMethodLabel}:</b>\n{consequenceTransparencyMessage}`,
							RichText = true,
							LayoutOrder = 2
						}),
						ViewActivityButton = module2.createElement(button, {
							text = translations.viewMoreButton,
							onActivated = v10,
							variant = buttonVariant.Standard,
							size = inputSize.Small,
							width = UDim.new(1, 0),
							LayoutOrder = 3
						})
					}
				),
				InterventionId = module2.createElement(text, {
					tag = "auto-xy text-caption-medium text-wrap text-align-x-left content-muted",
					Text = interventionId,
					LayoutOrder = 2
				})
			}
		)
	})
end

return {
	getIsVisible = function(): boolean
		return true
	end,
	renderComponent = module2.memo(RecentActivity)
}
