local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local AccountReactivationPromptButtons = require(NotApprovedPage.Components.AccountReactivationPrompt.AccountReactivationPromptButtons)
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local canReactivate = require(NotApprovedPage.Utils.canReactivate)

require(NotApprovedPage.Common.Types)

local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES
local React = require(NotApprovedPageParent.React)
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback
local useSelector = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(NotApprovedPageParent.Localization).Hooks.useLocalization
local Foundation = require(NotApprovedPageParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local PartialPageModal = require(NotApprovedPageParent.UIBlox).App.Dialog.Modal.PartialPageModal
local UserInputService = game:GetService("UserInputService")

local function AccountReactivationPrompt(t1: {[any]: any}) -- line: 44
	-- upvalues: useState (copy), UserInputService (copy), useSelector (copy), useLocalization (copy), useEffect (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), canReactivate (copy), useCallback (copy), React (copy), AccountReactivationPromptButtons (copy), PartialPageModal (copy), View (copy), FoundationText (copy)
	local v20, v21 = useState(false)
	local StatusBarSizeY = UserInputService.StatusBarSize.Y
	local v23 = useSelector(function(p1) -- line: 48
		return p1.ScreenSize
	end)
	local v24 = useLocalization({
		modalTitle = "Feature.AccountReactivation.Heading.AccountDeactivated",
		messageToUser = "Feature.AccountReactivation.Content.AccountDeactivatedMessage",
		errorMessage = "Feature.AccountReactivation.Label.DefaultError"
	})

	useEffect(function() -- line: 58
		-- upvalues: t1 (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), canReactivate (copy)
		local moderationDetail = t1.moderationDetail

		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.AccountReactivationPageRendered,
			interventionId = moderationDetail.interventionId,
			verificationCategory = moderationDetail.verificationCategory,
			isReactivationEligible = tostring(canReactivate(moderationDetail.punishmentTypeDescription, moderationDetail.endDate, moderationDetail.verificationCategory)),
			punishedUserId = moderationDetail.punishedUserId
		})
	end, {})

	local v25 = useCallback(function() -- line: 77
		-- upvalues: React (copy), AccountReactivationPromptButtons (copy), t1 (copy), v21 (copy)
		return React.createElement(AccountReactivationPromptButtons, {
			moderationDetail = t1.moderationDetail,
			setErrorState = v21,
			LogoutThunk = t1.LogoutThunk
		})
	end, {
		t1.moderationDetail,
		t1.LogoutThunk
	})

	return React.createElement(PartialPageModal, {
		marginSize = 0,
		title = v24.modalTitle,
		screenSize = v23,
		distanceFromTop = StatusBarSizeY,
		footerContent = v25
	}, {
		Content = React.createElement(View, {
			tag = "auto-xy col padding-xxlarge gap-medium"
		}, {
			MessageToUser = React.createElement(FoundationText, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = v24.messageToUser
			}),
			ErrorMessage = v20 and React.createElement(FoundationText, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 2,
				Text = v24.errorMessage
			})
		})
	})
end

return React.memo(AccountReactivationPrompt)
