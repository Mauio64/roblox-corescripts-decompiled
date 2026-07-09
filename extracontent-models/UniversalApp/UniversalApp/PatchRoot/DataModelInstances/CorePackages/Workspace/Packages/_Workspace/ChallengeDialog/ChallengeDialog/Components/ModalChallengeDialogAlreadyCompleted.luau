local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local useLocalization = require(ChallengeDialogParent.Localization).Hooks.useLocalization
local AppPage = require(ChallengeDialogParent.RobloxAppEnums).AppPage
local Lock = require(ChallengeDialog.Common.Lock)
local ModalTextComponent = require(ChallengeDialog.Common.ModalTextComponent)
local ModalButtonConfig = require(ChallengeDialog.Common.ModalButtonConfig)
local FullPageModalWrapper = require(ChallengeDialog.Common.FullPageModalWrapper)
local ModalFooter = require(ChallengeDialog.Common.ModalFooter)
local ModalTextSizes = require(ChallengeDialog.Common.ModalTextSizes)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	okay = "Authentication.TwoStepVerification.Action.Okay",
	header = "Authentication.TwoStepVerification.Label.AttemptReviewed",
	alreadyReviewed = "Authentication.TwoStepVerification.Label.AlreadyReviewed",
	helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
}

return function(p1) -- line: 25
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), FullPageModalWrapper (copy), Lock (copy), ModalTextComponent (copy), ModalButtonConfig (copy), ButtonType (copy), ModalFooter (copy), ModalTextSizes (copy), AppPage (copy)
	local v16 = useLocalization(t1)

	return React.createElement(FullPageModalWrapper, {
		title = v16.header,
		closeModal = p1.closeModal,
		makeBodyFragment = function(p2) -- line: 30
			-- upvalues: React (copy), Lock (copy), ModalTextComponent (copy), v16 (copy)
			return React.createElement(React.Fragment, nil, {
				Lock = React.createElement(Lock, {
					layoutOrder = 1
				}),
				AlreadyCompleted = React.createElement(ModalTextComponent, {
					layoutOrder = 2,
					useBold = true,
					useEmphasis = true,
					contentWidth = p2,
					text = v16.alreadyReviewed
				})
			})
		end,
		buttonConfig = ModalButtonConfig({{
			onActivated = p1.closeModal,
			text = v16.okay,
			type = ButtonType.PrimarySystem
		}}),
		footerContent = ModalFooter(function(p3) -- line: 51
			-- upvalues: React (copy), ModalTextComponent (copy), v16 (copy), ModalTextSizes (copy), p1 (copy), AppPage (copy)
			return React.createElement(ModalTextComponent, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v16.helpMessage,
				contentWidth = p3,
				size = ModalTextSizes.Footer,
				onActivated = function() -- line: 58
					-- upvalues: p1 (copy), AppPage (copy)
					p1.navigateToPage({
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
end
