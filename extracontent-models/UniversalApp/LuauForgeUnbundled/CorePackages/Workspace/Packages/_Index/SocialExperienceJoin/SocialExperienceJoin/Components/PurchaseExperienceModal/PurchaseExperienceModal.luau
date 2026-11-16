local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Localization")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/UIBlox")

local useLocalization = Localization.Hooks.useLocalization
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Common/TextKeys")

return function(props)
	local v5 = useLocalization({
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

	return React.createElement(interactiveAlert, {
		screenSize = props.screenSize,
		title = v5.titleText,
		bodyText = v5.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = {
						text = v5.cancelButtonText,
						onActivated = props.cancelPurchase
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						text = v5.confirmButtonText,
						onActivated = props.purchaseExperience
					}
				}
			}
		}
	})
end
