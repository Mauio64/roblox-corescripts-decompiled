local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)

require(PhoneUpsell.Components.PhoneVerificationUpsellOverlay)

local UpsellContainer = require(PhoneUpsell.Components.UpsellContainer)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)
local Cryo = require(PhoneUpsellParent.Cryo)
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FFlagFixUpsellVerificationToNavigateToOverlays = require(PhoneUpsell.Flags.FFlagFixUpsellVerificationToNavigateToOverlays)
local t1 = {
	onSuccess = function() -- line: 24
	end,
	closeUpsell = function() -- line: 25
	end
}

local function PhoneVerificationUpsellOverlayWrapper(p1) -- line: 30
	-- upvalues: mergeProps (copy), t1 (copy), React (copy), ImageSetLabel (copy), Images (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), useLocalization (copy), UpsellContainer (copy), Cryo (copy), PhoneVerificationStatusOverlay (copy)
	local v16 = mergeProps(t1, p1)
	local v17, v18 = React.useState(false)
	local v19 = React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(40, 40),
		Image = Images["icons/status/success_large"]
	})
	local v20 = useLocalization({
		verifySuccessKey = "Feature.VerificationUpsell.Heading.VerifiedSuccessfully.V2"
	})

	return React.createElement(React.Fragment, nil, {
		PhoneVerificationUpsellOverlay = React.createElement(UpsellContainer, Cryo.Dictionary.join(v16, {
			onSuccess = function() -- line: 41
				-- upvalues: v18 (copy), FFlagFixUpsellVerificationToNavigateToOverlays (copy), v16 (copy)
				v18(true)
				task.delay(3, function() -- line: 43
					-- upvalues: FFlagFixUpsellVerificationToNavigateToOverlays (copy), v16 (copy)
					if FFlagFixUpsellVerificationToNavigateToOverlays then
						v16.closeUpsell()
						v16.onSuccess()

						return
					end

					v16.onSuccess()
					v16.closeUpsell()
				end)
			end
		})),
		SuccessOverlay = v17 and React.createElement(PhoneVerificationStatusOverlay, {
			image = v19,
			text = v20.verifySuccessKey
		})
	})
end

return PhoneVerificationUpsellOverlayWrapper
