local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local React = require(SocialExperienceJoinParent.React)
local Localization = require(SocialExperienceJoinParent.Localization)
local UIBlox = require(SocialExperienceJoinParent.UIBlox)
local useLocalization = Localization.Hooks.useLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local TextKeys = require(SocialExperienceJoin.Common.TextKeys)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v11 = useLocalization({
		titleText = TextKeys.PurchaseExperienceModalTitle,
		bodyText = {
			TextKeys.PurchaseExperienceModalBody,
			gameName = t1.experienceName,
			X = t1.price
		},
		confirmButtonText = TextKeys.Unlock,
		cancelButtonText = TextKeys.Cancel,
		successToastTitle = TextKeys.SuccessPurchaseToastTitle,
		successToastMessage = {
			TextKeys.SuccessPurchaseToastMessage,
			gameName = t1.experienceName,
			price = t1.price
		}
	})

	return React.createElement(InteractiveAlert, {
		screenSize = t1.screenSize,
		title = v11.titleText,
		bodyText = v11.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = {
						text = v11.cancelButtonText,
						onActivated = t1.cancelPurchase
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = v11.confirmButtonText,
						onActivated = t1.purchaseExperience
					}
				}
			}
		}
	})
end
