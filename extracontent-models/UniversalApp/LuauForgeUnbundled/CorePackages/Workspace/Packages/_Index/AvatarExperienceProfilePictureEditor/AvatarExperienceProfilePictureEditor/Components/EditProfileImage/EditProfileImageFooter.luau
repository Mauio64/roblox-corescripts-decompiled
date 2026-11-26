local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/editProfileImageHelpers")

local function EditProfileImageFooter(props)
	local v5

	if props.footerCta == "purchaseEmote" then
		local selectedEmoteId = props.selectedEmoteId
		v5 = {
			Purchase = props.renderRecommendedEmotePurchaseFooter(selectedEmoteId)
		}
	elseif props.footerCta == "subscribePlus" then
		v5 = {
			Subscribe = React.createElement(button, {
				text = props.localizedSubscribeLabel,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				fillBehavior = fillBehavior.Fill,
				onActivated = function()
					props.onOpenProfileFramesSubscriptionUpsell("footer")
				end,
				LayoutOrder = 1
			})
		}
	else
		v5 = {
			Save = React.createElement(button, {
				text = props.localizedSaveLabel,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				fillBehavior = fillBehavior.Fill,
				isLoading = props.isSaving,
				isDisabled = props.isSaving,
				onActivated = props.onSave,
				LayoutOrder = 1
			})
		}
	end

	return React.createElement(
		view,
		{
			tag = "row gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-medium padding-top-medium",
			LayoutOrder = props.layoutOrder
		},
		v5
	)
end

return EditProfileImageFooter
