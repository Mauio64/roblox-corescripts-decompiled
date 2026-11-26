local module = require("@luauforge/deferred/gBz")
local module2 = require("@luauforge/deferred/gzX")
local module3 = require("@luauforge/deferred/gzM")

require("@luauforge/deferred/gzP")

local EVENT_TYPES = require("@luauforge/deferred/gzN").Constants.EVENT_TYPES

local module4 = require("@luauforge/deferred/gzS")
local useState = module4.useState
local useEffect = module4.useEffect
local useCallback = module4.useCallback
local useSelector = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useSelector
local useLocalization = require("@luauforge/deferred/gAn").Hooks.useLocalization

local module5 = require("@luauforge/deferred/gzT")
local view = module5.View
local text = module5.Text

local partialPageModal = require("@luauforge/deferred/gAr").App.Dialog.Modal.PartialPageModal

local UserInputService = game:GetService("UserInputService")

local function AccountReactivationPrompt(p2)
	local state, setState = useState(false)

	local y = UserInputService.StatusBarSize.Y
	local v5 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v6 = useLocalization({
		modalTitle = "Feature.AccountReactivation.Heading.AccountDeactivated",
		messageToUser = "Feature.AccountReactivation.Content.AccountDeactivatedMessage",
		errorMessage = "Feature.AccountReactivation.Label.DefaultError"
	})

	useEffect(function()
		local moderationDetail = p2.moderationDetail
		module2({
			eventType = EVENT_TYPES.AccountReactivationPageRendered,
			interventionId = moderationDetail.interventionId,
			verificationCategory = moderationDetail.verificationCategory,
			isReactivationEligible = tostring(module3(
				moderationDetail.punishmentTypeDescription,
				moderationDetail.endDate,
				moderationDetail.verificationCategory
			)),
			punishedUserId = moderationDetail.punishedUserId
		})
	end, {})

	local v7 = useCallback(function()
		return module4.createElement(module, {
			moderationDetail = p2.moderationDetail,
			setErrorState = setState,
			LogoutThunk = p2.LogoutThunk
		})
	end, { p2.moderationDetail, p2.LogoutThunk })

	return module4.createElement(partialPageModal, {
		title = v6.modalTitle,
		screenSize = v5,
		distanceFromTop = y,
		marginSize = 0,
		footerContent = v7
	}, {
		Content = module4.createElement(view, {
			tag = "auto-xy col padding-xxlarge gap-medium"
		}, {
			MessageToUser = module4.createElement(text, {
				Text = v6.messageToUser,
				tag = "auto-xy text-wrap",
				LayoutOrder = 1
			}),
			ErrorMessage = state and module4.createElement(text, {
				Text = v6.errorMessage,
				tag = "auto-xy text-wrap",
				LayoutOrder = 2
			})
		})
	})
end

return module4.memo(AccountReactivationPrompt)
