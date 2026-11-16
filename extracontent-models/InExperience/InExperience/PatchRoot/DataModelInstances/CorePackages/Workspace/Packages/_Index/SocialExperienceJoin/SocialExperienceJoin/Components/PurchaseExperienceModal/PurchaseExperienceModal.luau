local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local UIBlox = require(parent.UIBlox)

local useLocalization = Localization.Hooks.useLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local TextKeys = require(SocialExperienceJoin.Common.TextKeys)

return function(props)
	local v = useLocalization({
		titleText = TextKeys.PurchaseExperienceModalTitle,
		bodyText = {
			TextKeys.PurchaseExperienceModalBody,
			gameName = props.experienceName,
			X = props.price
		},
		confirmButtonText = TextKeys.Unlock,
		cancelButtonText = TextKeys.Cancel,
		successToastTitle = TextKeys.SuccessPurchaseToastTitle,
		successToastMessage = {
			TextKeys.SuccessPurchaseToastMessage,
			gameName = props.experienceName,
			price = props.price
		}
	})

	return React.createElement(InteractiveAlert, {
		screenSize = props.screenSize,
		title = v.titleText,
		bodyText = v.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = { text = v.cancelButtonText, onActivated = props.cancelPurchase }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { text = v.confirmButtonText, onActivated = props.purchaseExperience }
				}
			}
		}
	})
end
