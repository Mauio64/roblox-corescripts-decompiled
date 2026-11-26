local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellOverlay")
local UpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/UpsellContainer")
local PhoneVerificationStatusOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationStatusOverlay")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local FFlagFixUpsellVerificationToNavigateToOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/FFlagFixUpsellVerificationToNavigateToOverlays")

local v5 = {
	onSuccess = function() end,
	closeUpsell = function() end
}

local function PhoneVerificationUpsellOverlayWrapper(p2)
	local v6 = mergeProps(v5, p2)

	local state, setState = React.useState(false)

	local element = React.createElement(imageSetLabel, {
		Size = UDim2.fromOffset(40, 40),
		Image = images["icons/status/success_large"],
		BackgroundTransparency = 1
	})

	local function onSuccess()
		setState(true)
		task.delay(3, function()
			if FFlagFixUpsellVerificationToNavigateToOverlays then
				v6.closeUpsell()
				v6.onSuccess()
			else
				v6.onSuccess()
				v6.closeUpsell()
			end
		end)
	end

	local v7 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VerifiedSuccessfully.V2"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(
			UpsellContainer,
			Cryo.Dictionary.join(v6, { onSuccess = onSuccess })
		),
		SuccessOverlay = state and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v7.verifySuccessKey
		})
	})
end

return PhoneVerificationUpsellOverlayWrapper
