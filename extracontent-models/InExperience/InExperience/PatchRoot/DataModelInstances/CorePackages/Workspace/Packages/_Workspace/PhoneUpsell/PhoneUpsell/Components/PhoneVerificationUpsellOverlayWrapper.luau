local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)

require(PhoneUpsell.Components.PhoneVerificationUpsellOverlay)
local UpsellContainer = require(PhoneUpsell.Components.UpsellContainer)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)

local Cryo = require(parent.Cryo)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local FFlagFixUpsellVerificationToNavigateToOverlays = require(PhoneUpsell.Flags.FFlagFixUpsellVerificationToNavigateToOverlays)

local v = {
	onSuccess = function() end,
	closeUpsell = function() end
}

local function PhoneVerificationUpsellOverlayWrapper(p)
	local v2 = mergeProps(v, p)

	local state, setState = React.useState(false)

	local element = React.createElement(ImageSetLabel, {
		Size = UDim2.fromOffset(40, 40),
		Image = Images["icons/status/success_large"],
		BackgroundTransparency = 1
	})

	local function onSuccess()
		setState(true)
		task.delay(3, function()
			if FFlagFixUpsellVerificationToNavigateToOverlays then
				v2.closeUpsell()
				v2.onSuccess()
			else
				v2.onSuccess()
				v2.closeUpsell()
			end
		end)
	end

	local v3 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VerifiedSuccessfully.V2"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(
			UpsellContainer,
			Cryo.Dictionary.join(v2, { onSuccess = onSuccess })
		),
		SuccessOverlay = state and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v3.verifySuccessKey
		})
	})
end

return PhoneVerificationUpsellOverlayWrapper
