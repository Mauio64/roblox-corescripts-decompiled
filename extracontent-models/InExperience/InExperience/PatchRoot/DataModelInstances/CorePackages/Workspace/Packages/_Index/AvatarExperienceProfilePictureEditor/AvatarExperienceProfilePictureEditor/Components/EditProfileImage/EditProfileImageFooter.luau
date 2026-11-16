local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

require(AvatarExperienceProfilePictureEditor.Utils.editProfileImageHelpers)

local function EditProfileImageFooter(props)
	local v

	if props.footerCta == "purchaseEmote" then
		local selectedEmoteId = props.selectedEmoteId
		v = {
			Purchase = props.renderRecommendedEmotePurchaseFooter(selectedEmoteId)
		}
	elseif props.footerCta == "subscribePlus" then
		v = {
			Subscribe = React.createElement(Button, {
				text = props.localizedSubscribeLabel,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				fillBehavior = FillBehavior.Fill,
				onActivated = function()
					props.onOpenProfileFramesSubscriptionUpsell("footer")
				end,
				LayoutOrder = 1
			})
		}
	else
		v = {
			Save = React.createElement(Button, {
				text = props.localizedSaveLabel,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				fillBehavior = FillBehavior.Fill,
				isLoading = props.isSaving,
				isDisabled = props.isSaving,
				onActivated = props.onSave,
				LayoutOrder = 1
			})
		}
	end

	return React.createElement(
		View,
		{
			tag = "row gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-medium padding-top-medium",
			LayoutOrder = props.layoutOrder
		},
		v
	)
end

return EditProfileImageFooter
