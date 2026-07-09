local AccountLockModal = script:FindFirstAncestor("AccountLockModal")
local AccountLockModalParent = AccountLockModal.Parent
local Players = game:GetService("Players")
local GetFIntAccountUnlockDelayMs = require(AccountLockModal.Flags.GetFIntAccountUnlockDelayMs)
local unlockAccount = require(AccountLockModal.Utils.unlockAccount)
local React = require(AccountLockModalParent.React)
local useDispatch = require(AccountLockModalParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(AccountLockModalParent.Localization).Hooks.useLocalization
local FFlagAccountLockReceiverClosesModal = require(AccountLockModalParent.SharedFlags).FFlagAccountLockReceiverClosesModal
local FFlagShowAccountUnlockMismatchDialog = require(AccountLockModalParent.SharedFlags).FFlagShowAccountUnlockMismatchDialog
local FFlagAccountUnlockAllowMissingUserId = require(AccountLockModalParent.SharedFlags).FFlagAccountUnlockAllowMissingUserId
local GetFFlagEnhancedPersonaLivenessEvents = require(AccountLockModalParent.SharedFlags).GetFFlagEnhancedPersonaLivenessEvents
local Foundation = require(AccountLockModalParent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Loading = Foundation.Loading
local View = Foundation.View
local useRoactService = require(AccountLockModalParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountLockModalParent.RoactServiceTags).RoactNetworking
local AppLogging = require(AccountLockModalParent.RoactServiceTags).AppLogging
local AppPage = require(AccountLockModalParent.RobloxAppEnums).AppPage
local AccountLockClientEvent = require(AccountLockModal.Common.AccountLockClientEvent)
local AccountLockEventContextEnum = require(AccountLockModal.Common.Enums).AccountLockEventContextEnum

local function defaultGetLocalUserId() -- line: 86
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	return LocalPlayer.UserId
end
local function routeHome(t1: {[any]: any}, p1) -- line: 94
	-- upvalues: AppPage (copy)
	p1(t1.ResetNavigationHistory({{
		name = AppPage.Home
	}}))
end
local function isCurrentUserMatch(s1: string?, p2: ((...any) -> ...any)) -- line: 101
	if not s1 then
		return false
	end

	local v39 = p2()

	if not v39 or v39 == 0 then
		return false
	end

	return s1 == tostring(v39)
end
local function AccountMismatchDialog(t2: {[any]: any}) -- line: 116
	-- upvalues: React (copy), useLocalization (copy), Dialog (copy), DialogSize (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), FillBehavior (copy)
	local v41 = React.useCallback(function() -- line: 119
		-- upvalues: t2 (copy)
		t2.onDismiss()
	end, { t2.onDismiss })
	local v42 = useLocalization({
		title = "Feature.AccountLock.Title.WrongAccount",
		body = "Feature.AccountLock.Content.AccountMismatchDialog",
		okButton = "Feature.AccountLock.Action.Ok"
	})

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		disablePortal = false,
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v42.title
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(View, {
				tag = "col items-start fill gap-medium auto-xy"
			}, {
				BodyText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = v42.body
				}),
				Footer = React.createElement(View, {
					tag = "row gap-small size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					OkButton = React.createElement(Button, {
						LayoutOrder = 1,
						text = v42.okButton,
						onActivated = v41,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium,
						fillBehavior = FillBehavior.Fill
					})
				})
			})
		})
	})
end
local function AccountUnlockDeepLinkPage(t3: {[any]: any}) -- line: 163
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), AppLogging (copy), React (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), defaultGetLocalUserId (copy), FFlagAccountUnlockAllowMissingUserId (copy), FFlagShowAccountUnlockMismatchDialog (copy), routeHome (copy), unlockAccount (copy), GetFIntAccountUnlockDelayMs (copy), FFlagAccountLockReceiverClosesModal (copy), AppPage (copy), AccountMismatchDialog (copy), Loading (copy), IconSize (copy)
	local v44 = useDispatch()
	local v45 = useRoactService(RoactNetworking)
	local v46 = useRoactService(AppLogging)
	local v47, v48 = React.useState("Pending")

	React.useEffect(function() -- line: 173
		-- upvalues: GetFFlagEnhancedPersonaLivenessEvents (copy), v46 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy)
		if not GetFFlagEnhancedPersonaLivenessEvents() then
			return
		end

		v46:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
			context = AccountLockEventContextEnum.DeepLinkReceived
		})
	end, {})
	React.useEffect(function() -- line: 187
		-- upvalues: t3 (copy), defaultGetLocalUserId (copy), FFlagAccountUnlockAllowMissingUserId (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v46 (copy), AccountLockClientEvent (copy), AccountLockEventContextEnum (copy), FFlagShowAccountUnlockMismatchDialog (copy), v48 (copy), routeHome (copy), v44 (copy), unlockAccount (copy), v45 (copy), GetFIntAccountUnlockDelayMs (copy), FFlagAccountLockReceiverClosesModal (copy), AppPage (copy)
		local v49 = t3.getLocalUserId or defaultGetLocalUserId

		if not FFlagAccountUnlockAllowMissingUserId or t3.targetUserId and t3.targetUserId ~= "" then
			local targetUserId = t3.targetUserId
			local v51

			if not targetUserId then
				v51 = false
			else
				local v52 = v49()

				v51 = not not v52 and (v52 ~= 0 and targetUserId == tostring(v52))
			end

			if not v51 then
				if GetFFlagEnhancedPersonaLivenessEvents() then
					v46:logRobloxTelemetryEvent(AccountLockClientEvent, {}, {
						context = AccountLockEventContextEnum.DeepLinkMismatch
					})
				end

				if FFlagShowAccountUnlockMismatchDialog then
					v48("WrongUser")

					return
				end

				routeHome(t3, v44)
				v48("Done")

				return
			end
		end

		unlockAccount(v45):andThen(function() -- line: 212
			-- upvalues: GetFIntAccountUnlockDelayMs (copy), v44 (copy), t3 (copy), v45 (copy)
			task.wait(GetFIntAccountUnlockDelayMs() / 1000)

			return v44(t3.ApiFetchAccessStatus(v45)):catch(function() -- line: 216
			end)
		end):andThen(function() -- line: 218
			-- upvalues: FFlagAccountLockReceiverClosesModal (copy), v44 (copy), t3 (copy), AppPage (copy), v48 (copy)
			if not FFlagAccountLockReceiverClosesModal then
				v44(t3.closeCentralOverlayThunk())
			end

			v44(t3.ResetNavigationHistory({{
				name = AppPage.Home
			}}))
			v48("Done")
		end):catch(function() -- line: 230
			-- upvalues: routeHome (copy), t3 (copy), v44 (copy), v48 (copy)
			routeHome(t3, v44)
			v48("Done")
		end)
	end, {})

	if v47 == "WrongUser" then
		return React.createElement(AccountMismatchDialog, {
			onDismiss = function() -- line: 241
				-- upvalues: routeHome (copy), t3 (copy), v44 (copy), v48 (copy)
				routeHome(t3, v44)
				v48("Done")
			end
		})
	end

	if v47 == "Done" then
		return nil
	end

	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return AccountUnlockDeepLinkPage
