local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local RoactRodux = require(ChallengeDialogParent.RoactRodux)
local HttpRequest = require(ChallengeDialogParent.HttpRequest)
local NavigateDown = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ChallengeDialogParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(ChallengeDialogParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(ChallengeDialogParent.RobloxAppEnums).AppPage
local useLocalization = require(ChallengeDialogParent.Localization).Hooks.useLocalization
local FullPageModalWrapper = require(ChallengeDialog.Common.FullPageModalWrapper)
local Lock = require(ChallengeDialog.Common.Lock)
local ModalTextComponent = require(ChallengeDialog.Common.ModalTextComponent)
local ModalButtonConfig = require(ChallengeDialog.Common.ModalButtonConfig)
local ModalFooter = require(ChallengeDialog.Common.ModalFooter)
local ChallengeDialogAction = require(ChallengeDialog.Enum.ChallengeDialogAction)
local ChallengeDialogType = require(ChallengeDialog.Enum.ChallengeDialogType)
local FinishDialog = require(ChallengeDialog.Thunks.FinishDialog)
local EventService = require(ChallengeDialog.Analytics.EventService)
local ModalTextSizes = require(ChallengeDialog.Common.ModalTextSizes)
local FFlagLuaAppDefaultHttpRetry = require(ChallengeDialogParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v24 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ModalChallengeDialogExpiredHttpRetryCount", 4)
})

local function v25(n1: number) -- line: 37
	-- upvalues: ChallengeDialogType (copy)
	return {
		okay = "Authentication.TwoStepVerification.Action.Okay",
		helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage",
		header = n1 ~= ChallengeDialogType.toRawValue(ChallengeDialogType.DIALOG_TYPE_APPROVAL_2SV_GENERIC) and "Authentication.TwoStepVerification.Header.LoginAttemptExpired" or "Authentication.TwoStepVerification.Header.AttemptExpired",
		loginExpired = n1 ~= ChallengeDialogType.toRawValue(ChallengeDialogType.DIALOG_TYPE_APPROVAL_2SV_GENERIC) and "Authentication.TwoStepVerification.Label.LoginExpired" or "Authentication.TwoStepVerification.Label.Expired"
	}
end

return RoactRodux.connect(function(_, _) -- line: 120
	return {}
end, function(p3) -- line: 122
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), FinishDialog (copy)
	return {
		navigateToPage = function(p4) -- line: 124
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p3 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v9.down(v9.fromLegacyPage(p4))
			end

			return p3(NavigateDown(p4))
		end,
		finishDialog = function(p5, p6, p7) -- line: 131
			-- upvalues: p3 (copy), FinishDialog (copy)
			return p3(FinishDialog(p5, p6, p7))
		end
	}
end)(function(p8) -- line: 52
	-- upvalues: React (copy), useLocalization (copy), v25 (copy), v24 (copy), ChallengeDialogAction (copy), EventService (copy), FullPageModalWrapper (copy), Lock (copy), ModalTextComponent (copy), ModalButtonConfig (copy), ButtonType (copy), ModalFooter (copy), ModalTextSizes (copy), AppPage (copy)
	local v28, v29 = React.useState(false)
	local v30 = useLocalization((v25(p8.dialogItem.type)))

	local function v31() -- line: 56
		-- upvalues: v29 (copy), p8 (copy), v24 (copy), ChallengeDialogAction (copy)
		v29(true)
		p8.finishDialog(v24, {
			type = p8.dialogItem.type,
			typeInternalId = p8.dialogItem.typeInternalId
		}, ChallengeDialogAction.Deny):await()
		v29(false)
		p8.closeModal()
	end

	return React.createElement(FullPageModalWrapper, {
		title = v30.header,
		closeModal = function() -- line: 68
			-- upvalues: EventService (copy), p8 (copy), v31 (copy)
			EventService.sendDialogAbandonedEvent(p8.dialogItem.type, p8.dialogItem.typeInternalId)
			v31()
		end,
		makeBodyFragment = function(p9) -- line: 76
			-- upvalues: React (copy), Lock (copy), ModalTextComponent (copy), v30 (copy)
			return React.createElement(React.Fragment, nil, {
				Lock = React.createElement(Lock, {
					layoutOrder = 1
				}),
				ChangeYourPassword = React.createElement(ModalTextComponent, {
					layoutOrder = 2,
					useBold = true,
					useEmphasis = true,
					contentWidth = p9,
					text = v30.loginExpired
				})
			})
		end,
		buttonConfig = ModalButtonConfig({{
			isDisabled = v28,
			isLoading = v28,
			onActivated = v31,
			text = v30.okay,
			type = ButtonType.PrimarySystem
		}}),
		footerContent = ModalFooter(function(p10) -- line: 99
			-- upvalues: React (copy), ModalTextComponent (copy), v30 (copy), ModalTextSizes (copy), p8 (copy), AppPage (copy)
			return React.createElement(ModalTextComponent, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v30.helpMessage,
				contentWidth = p10,
				size = ModalTextSizes.Footer,
				onActivated = function() -- line: 106
					-- upvalues: p8 (copy), AppPage (copy)
					p8.navigateToPage({
						detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
						name = AppPage.GenericWebPage,
						extraProps = {
							title = ""
						}
					})
				end
			})
		end)
	})
end)
