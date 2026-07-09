local AccountLockModal = script:FindFirstAncestor("AccountLockModal")
local AccountLockModalTitle = require(AccountLockModal.Components.AccountLockModalTitle)
local AccountLockModalContent = require(AccountLockModal.Components.AccountLockModalContent)
local AccountLockModalFooter = require(AccountLockModal.Components.AccountLockModalFooter)
local AccountLockContext = require(AccountLockModal.Contexts.AccountLockContext)
local AccountLockModalParent = AccountLockModal.Parent
local React = require(AccountLockModalParent.React)
local useEffect = React.useEffect
local useRoactService = require(AccountLockModalParent.RobloxAppHooks).useRoactService
local AppLogging = require(AccountLockModalParent.RoactServiceTags).AppLogging
local Foundation = require(AccountLockModalParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local View = Foundation.View

local function AccountLockModal2(t1: {[any]: any}) -- line: 29
	-- upvalues: useRoactService (copy), AppLogging (copy), AccountLockModal (copy), useEffect (copy), React (copy), AccountLockContext (copy), Dialog (copy), DialogSize (copy), AccountLockModalTitle (copy), View (copy), AccountLockModalContent (copy), AccountLockModalFooter (copy)
	local v17 = useRoactService(AppLogging)
	local AccountLockClientEvent = require(AccountLockModal.Common.AccountLockClientEvent)
	local AccountLockEventContextEnum = require(AccountLockModal.Common.Enums).AccountLockEventContextEnum

	useEffect(function() -- line: 34
		-- upvalues: v17 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy)
		v17:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
			context = AccountLockEventContextEnum.Init
		})
	end, nil)

	return React.createElement(AccountLockContext.Provider, {}, {
		children = React.createElement(Dialog.Root, {
			size = DialogSize.Medium
		}, {
			DialogTitle = React.createElement(AccountLockModalTitle, {}),
			DialogContent = React.createElement(Dialog.Content, nil, {
				DialogView = React.createElement(View, {
					tag = "col fill auto-xy items-start gap-medium"
				}, {
					DialogContentText = React.createElement(AccountLockModalContent, {}),
					DialogFooter = React.createElement(AccountLockModalFooter, {
						Logout = t1.Logout,
						ResetNavigationHistory = t1.ResetNavigationHistory,
						ApiFetchAccessStatus = t1.ApiFetchAccessStatus,
						ChallengeError = t1.ChallengeError,
						closeCentralOverlayThunk = t1.closeCentralOverlayThunk
					})
				})
			})
		})
	})
end

return React.memo(AccountLockModal2)
