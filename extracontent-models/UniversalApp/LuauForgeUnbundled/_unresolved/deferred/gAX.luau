local module = require("@luauforge/deferred/gzS")
local fragment = module.Fragment
local useCallback = module.useCallback
local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder

local module2 = require("@luauforge/deferred/gzT")
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize

local module3 = require("@luauforge/deferred/gAL")
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext
local module4 = require("@luauforge/deferred/gzX")
local module5 = require("@luauforge/deferred/gAy")

local EVENT_TYPES = require("@luauforge/deferred/gzN").Constants.EVENT_TYPES

local fFlagNavigateToSafetyDashboardForAppeals = require("@luauforge/deferred/gAd").FFlagNavigateToSafetyDashboardForAppeals

require("@luauforge/deferred/gzW")

local function DeleteCta(p2)
	local translations = useNotApprovedPageContext().translations

	local violation = p2.moderationDetail.violation
	local v6

	if fFlagNavigateToSafetyDashboardForAppeals then
		v6 = module3(violation)
	else
		v6 = urlBuilder.static.appealsPortal.main()
	end

	local v7

	if fFlagNavigateToSafetyDashboardForAppeals then
		v7 = translations.accountStatusTitle
	else
		v7 = translations.appealsPortalTitle
	end

	local v8 = module5(v6, v7)

	local v9 = useCallback(function()
		module4({ eventType = EVENT_TYPES.AppealsPortalClicked })
		v8()
	end, { v8 })

	return module.createElement(fragment, nil, {
		AppealButton = module.createElement(button, {
			text = translations.reportMistakeButton,
			onActivated = v9,
			variant = buttonVariant.SoftEmphasis,
			size = inputSize.Medium,
			width = UDim.new(1, 0),
			LayoutOrder = 1
		})
	})
end

return module.memo(DeleteCta)
