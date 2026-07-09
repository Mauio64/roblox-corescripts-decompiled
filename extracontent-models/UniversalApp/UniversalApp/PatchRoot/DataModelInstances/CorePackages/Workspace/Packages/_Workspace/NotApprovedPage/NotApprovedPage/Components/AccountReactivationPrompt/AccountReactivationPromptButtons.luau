local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local ReactivateDeactivatedAccount = require(NotApprovedPage.Rodux.Thunks.ReactivateDeactivatedAccount)
local SetModerationStatus = require(NotApprovedPageParent.NotApprovedPageShared).SetModerationStatus
local useLogout = require(NotApprovedPage.Utils.useLogout)

require(NotApprovedPage.Common.Types)

local React = require(NotApprovedPageParent.React)
local useState = React.useState
local useCallback = React.useCallback
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local useLocalization = require(NotApprovedPageParent.Localization).Hooks.useLocalization
local RoactNetworking = require(NotApprovedPageParent.RoactServiceTags).RoactNetworking
local GuiService = game:GetService("GuiService")
local NotificationType = require(NotApprovedPageParent.RobloxAppEnums).NotificationType
local Foundation = require(NotApprovedPageParent.Foundation)
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function AccountReactivationPromptButtons(t1: {[any]: any}) -- line: 41
	-- upvalues: useState (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useLogout (copy), useCallback (copy), ReactivateDeactivatedAccount (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), useLocalization (copy), React (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v22, v23 = useState(false)
	local v24, v25 = useState(false)
	local v26 = useDispatch()
	local v27 = useRoactService(RoactNetworking)
	local v28 = useLogout(v25, t1.LogoutThunk)
	local v29 = useCallback(function() -- line: 49
		-- upvalues: t1 (copy), v23 (copy), ReactivateDeactivatedAccount (copy), v27 (copy), v26 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
		t1.setErrorState(false)
		v23(true)
		ReactivateDeactivatedAccount(v27):andThen(function(_) -- line: 53
			-- upvalues: v26 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
			v26(SetModerationStatus(false))
			GuiService:BroadcastNotification("", NotificationType.RESTART_LUA_APP)
		end):catch(function(_) -- line: 57
			-- upvalues: t1 (copy), v23 (copy)
			t1.setErrorState(true)
			v23(false)
		end)
	end, {
		v26,
		v27,
		t1.setErrorState
	})
	local v30 = useLocalization({
		logoutButton = "Application.Logout.Action.Logout",
		reactivationButton = "Feature.AccountReactivation.Label.Reactivate"
	})

	return React.createElement(View, {
		tag = "flex-between size-full-0 auto-y col gap-small padding-x-xxlarge"
	}, {
		ReactivationButton = React.createElement(Button, {
			LayoutOrder = 1,
			text = v30.reactivationButton,
			onActivated = v29,
			variant = ButtonVariant.Emphasis,
			size = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = v22
		}),
		LogoutButton = React.createElement(Button, {
			LayoutOrder = 2,
			text = v30.logoutButton,
			onActivated = v28,
			variant = ButtonVariant.Standard,
			size = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = v24
		})
	})
end

return React.memo(AccountReactivationPromptButtons)
