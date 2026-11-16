local Players = game:GetService("Players")

local module = require("@luauforge/deferred/gxc")
local module2 = require("@luauforge/deferred/gxf")

local module3 = require("@luauforge/deferred/gwV")
local useDispatch = require("@luauforge/deferred/gxi").Hooks.RoactRodux.useDispatch
local useLocalization = require("@luauforge/deferred/gwY").Hooks.useLocalization

local fFlagAccountLockReceiverClosesModal = require("@luauforge/deferred/gxp").FFlagAccountLockReceiverClosesModal
local fFlagShowAccountUnlockMismatchDialog = require("@luauforge/deferred/gxp").FFlagShowAccountUnlockMismatchDialog
local fFlagAccountUnlockAllowMissingUserId = require("@luauforge/deferred/gxp").FFlagAccountUnlockAllowMissingUserId
local getFFlagEnhancedPersonaLivenessEvents = require("@luauforge/deferred/gxp").GetFFlagEnhancedPersonaLivenessEvents

local module4 = require("@luauforge/deferred/gwZ")
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local dialog = module4.Dialog
local dialogSize = module4.Enums.DialogSize
local fillBehavior = module4.Enums.FillBehavior
local iconSize = module4.Enums.IconSize
local inputSize = module4.Enums.InputSize
local loading = module4.Loading
local view = module4.View

local useRoactService = require("@luauforge/deferred/gxj").useRoactService
local roactNetworking = require("@luauforge/deferred/gxk").RoactNetworking
local appLogging = require("@luauforge/deferred/gxk").AppLogging
local appPage = require("@luauforge/deferred/gxn").AppPage

local module5 = require("@luauforge/deferred/gxd")
local accountLockEventContextEnum = require("@luauforge/deferred/gwT").AccountLockEventContextEnum

local function defaultGetLocalUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return nil
end

local function routeHome(props, callback)
	callback(props.ResetNavigationHistory({
		{ name = appPage.Home }
	}))
end

local function isCurrentUserMatch(p2, callback): boolean
	if not p2 then
		return false
	end

	local v5 = callback()

	if v5 and v5 ~= 0 then
		return tostring(v5) == p2
	end

	return false
end

local function AccountMismatchDialog(p2)
	local v5 = module3.useCallback(function()
		p2.onDismiss()
	end, { p2.onDismiss })

	local v6 = useLocalization({
		title = "Feature.AccountLock.Title.WrongAccount",
		body = "Feature.AccountLock.Content.AccountMismatchDialog",
		okButton = "Feature.AccountLock.Action.Ok"
	})

	return module3.createElement(
		dialog.Root,
		{ size = dialogSize.Medium, hasBackdrop = true, disablePortal = false },
		{
			DialogTitle = module3.createElement(dialog.Title, { text = v6.title }),
			DialogContent = module3.createElement(dialog.Content, nil, {
				DialogView = module3.createElement(
					view,
					{ tag = "col items-start fill gap-medium auto-xy" },
					{
						BodyText = module3.createElement(dialog.Text, {
							Text = v6.body,
							LayoutOrder = 1
						}),
						Footer = module3.createElement(
							view,
							{
								tag = "row gap-small size-full-0 auto-y",
								LayoutOrder = 2
							},
							{
								OkButton = module3.createElement(button, {
									text = v6.okButton,
									onActivated = v5,
									variant = buttonVariant.Emphasis,
									size = inputSize.Medium,
									fillBehavior = fillBehavior.Fill,
									LayoutOrder = 1
								})
							}
						)
					}
				)
			})
		}
	)
end

local function AccountUnlockDeepLinkPage(props)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useRoactService(appLogging)

	local state, setState = module3.useState("Pending")

	module3.useEffect(function()
		if not getFFlagEnhancedPersonaLivenessEvents() then
			return
		end

		v7:logRobloxTelemetryEvent(module5, {}, {
			context = accountLockEventContextEnum.DeepLinkReceived
		})
	end, {})

	module3.useEffect(function()
		local getLocalUserId = props.getLocalUserId or defaultGetLocalUserId

		if not fFlagAccountUnlockAllowMissingUserId or props.targetUserId and props.targetUserId ~= "" then
			local targetUserId = props.targetUserId
			local v8

			if targetUserId then
				local localUserId = getLocalUserId()

				v8 = if localUserId and localUserId ~= 0 then tostring(localUserId) == targetUserId else false
			else
				v8 = false
			end

			if not v8 then
				if getFFlagEnhancedPersonaLivenessEvents() then
					v7:logRobloxTelemetryEvent(module5, {}, {
						context = accountLockEventContextEnum.DeepLinkMismatch
					})
				end

				if fFlagShowAccountUnlockMismatchDialog then
					setState("WrongUser")
					return
				end

				routeHome(props, v5)
				setState("Done")

				return
			end
		end

		module2(v6):andThen(function()
			task.wait(module() / 1000)

			return v5(props.ApiFetchAccessStatus(v6)):catch(function() end)
		end):andThen(function()
			if not fFlagAccountLockReceiverClosesModal then
				v5(props.closeCentralOverlayThunk())
			end

			v5(props.ResetNavigationHistory({
				{ name = appPage.Home }
			}))
			setState("Done")
		end):catch(function()
			routeHome(props, v5)
			setState("Done")
		end)
	end, {})

	if state == "WrongUser" then
		return module3.createElement(AccountMismatchDialog, {
			onDismiss = function()
				routeHome(props, v5)
				setState("Done")
			end
		})
	elseif state == "Done" then
		return nil
	end

	return module3.createElement(loading, {
		size = iconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return AccountUnlockDeepLinkPage
