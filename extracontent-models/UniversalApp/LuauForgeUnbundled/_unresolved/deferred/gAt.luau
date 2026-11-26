local module = require("@luauforge/deferred/gzX")

require("@luauforge/deferred/gzP")

local constants = require("@luauforge/deferred/gzN").Constants
local INTERVENTION_TYPES = constants.INTERVENTION_TYPES
local EVENT_TYPES = constants.EVENT_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local module2 = require("@luauforge/deferred/gzS")
local appPage = require("@luauforge/deferred/gAu").AppPage
local navigateDown = require("@luauforge/deferred/gAv").Thunks.NavigateDown
local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder
local useCallback = module2.useCallback

local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/gAd").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/gAx").NavigationCommands else nil

local module3 = require("@luauforge/deferred/gzT")
local text = module3.Text
local view = module3.View
local button = module3.Button
local buttonVariant = module3.Enums.ButtonVariant
local inputSize = module3.Enums.InputSize

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext
local module4 = require("@luauforge/deferred/gAy")

require("@luauforge/deferred/gzW")

local module5 = require("@luauforge/deferred/gAE")

local function PreventionSteps(props)
	local v5 = useNotApprovedPageContext()
	local translations = v5.translations
	local isKidsTreatment = v5.isKidsTreatment
	local dispatch = props.dispatch

	local hasEducationalPages = props.hasEducationalPages
	local showUGCAvatarGuidelinesLink = props.moderationDetail.showUGCAvatarGuidelinesLink
	local isAltInformed = props.moderationDetail.isAltInformed
	local v6

	if module5 then
		local v8

		if showUGCAvatarGuidelinesLink then
			v8 = urlBuilder.static.creatorHub() .. "/docs/marketplace/marketplace-policy#general-creation-guidelines"
		else
			v8 = urlBuilder.static.about.guidelines()
		end

		local v9

		if showUGCAvatarGuidelinesLink then
			v9 = translations.avatarGuidelinesLabel
		else
			v9 = translations.communityStandardsLabel
		end

		v6 = module4(v8, v9)
	else
		v6 = nil
	end

	local v7 = useCallback(function()
		local v10 = if showUGCAvatarGuidelinesLink then EVENT_TYPES.UGCGuidelinesClicked else EVENT_TYPES.CommunityGuidelineClicked
		module({ eventType = v10 })

		if module5 and v6 then
			v6()
			return
		end

		local v11 = { name = appPage.GenericWebPage, detail = 0, extraProps = 0 }

		local v12 = if showUGCAvatarGuidelinesLink then urlBuilder.static.creatorHub() .. "/docs/marketplace/marketplace-policy#general-creation-guidelines" else urlBuilder.static.about.guidelines()
		v11.detail = v12

		local v14 = if showUGCAvatarGuidelinesLink then translations.avatarGuidelinesLabel else translations.communityStandardsLabel
		v11.extraProps = { title = v14 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			dispatch(navigateDown(v11))
		end
	end, {
		dispatch,
		v6,
		showUGCAvatarGuidelinesLink,
		translations.avatarGuidelinesLabel,
		translations.communityStandardsLabel
	})

	local createElement = module2.createElement
	local v9 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = module2.createElement

	local v12 = if isKidsTreatment then translations.preventionStepsHeadingKids else translations.preventionStepsHeading
	local children = {
		Heading = createElement2(text, {
			Text = v12,
			tag = "auto-xy text-heading-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Content = 0
	}

	local createElement3 = module2.createElement

	local createElement4 = module2.createElement

	local v18 = if isKidsTreatment then translations.foreshadowDescriptionKids else translations.foreshadowDescription
	local v15 = {
		Description = createElement4(text, {
			Text = v18,
			tag = "auto-xy text-body-large text-wrap text-align-x-left",
			LayoutOrder = 3
		}),
		LinkedAccountsDescription = isAltInformed and module2.createElement(text, {
			Text = translations.linkedAccountsDescription,
			tag = "auto-xy text-body-large text-wrap text-align-x-left",
			LayoutOrder = 4
		}),
		GuidelinesLink = 0
	}
	local v19

	if hasEducationalPages and not showUGCAvatarGuidelinesLink then
		v19 = showUGCAvatarGuidelinesLink
	else
		local createElement5 = module2.createElement

		local v22 = if showUGCAvatarGuidelinesLink then translations.avatarGuidelinesLabel else translations.viewRulesButton
		v19 = createElement5(button, {
			text = v22,
			onActivated = v7,
			variant = buttonVariant.Standard,
			size = inputSize.Small,
			width = UDim.new(1, 0),
			LayoutOrder = 5
		})
	end

	v15.GuidelinesLink = v19
	children.Content = createElement3(
		view,
		{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
		v15
	)
	return createElement(view, v9, children)
end

return {
	getIsVisible = function(p2): boolean
		return PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p2.punishmentTypeDescription] ~= INTERVENTION_TYPES.Deleted
	end,
	renderComponent = module2.memo(PreventionSteps)
}
