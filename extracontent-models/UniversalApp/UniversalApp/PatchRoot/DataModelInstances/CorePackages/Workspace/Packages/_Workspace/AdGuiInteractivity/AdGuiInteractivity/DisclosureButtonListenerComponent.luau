local AdService = game:GetService("AdService")
local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local AdGuiInteractivityParent = AdGuiInteractivity.Parent
local React = require(AdGuiInteractivityParent.React)
local t = require(AdGuiInteractivityParent.t)
local getScreenPositionFromGuiObjectInput = require(AdGuiInteractivity.getScreenPositionFromGuiObjectInput)
local ImmersiveBrandedAdMenu = require(AdGuiInteractivity.ImmersiveBrandedAdMenu)
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)
local v9 = t.interface({
	disclosureButton = t.instanceIsA("GuiButton"),
	inputObject = t.instanceIsA("InputObject"),
	advertiserName = t.string,
	campaignId = t.string,
	immersiveBrandedAdId = t.string
})

return function() -- line: 35
	-- upvalues: React (copy), AdService (copy), v9 (copy), AdsInteractivityTelemetry (copy), getScreenPositionFromGuiObjectInput (copy), ImmersiveBrandedAdMenu (copy)
	local v10, v11 = React.useState(nil)

	React.useEffect(function() -- line: 39
		-- upvalues: AdService (copy), v9 (copy), AdsInteractivityTelemetry (copy), v11 (copy), getScreenPositionFromGuiObjectInput (copy)
		function AdService.OnImmersiveBrandedAdDisclosureButtonActivated(t1: {[any]: any}) -- line: 40
			-- upvalues: v9 (copy), AdsInteractivityTelemetry (copy), v11 (copy), getScreenPositionFromGuiObjectInput (copy)
			local v14, _ = v9(t1)

			if not v14 then
				return
			end

			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("disclosure")
			v11({
				menuScreenPosition = getScreenPositionFromGuiObjectInput(t1.disclosureButton, t1.inputObject),
				advertiserName = t1.advertiserName,
				campaignId = t1.campaignId,
				immersiveBrandedAdId = t1.immersiveBrandedAdId
			})
		end

		return function() -- line: 55
			-- upvalues: AdService (copy)
			function AdService.OnImmersiveBrandedAdDisclosureButtonActivated() -- line: 56
			end
		end
	end, {})

	local v12 = React.useCallback(function() -- line: 60
		-- upvalues: v11 (copy)
		v11(nil)
	end, {})

	if not v10 then
		return nil
	end

	return React.createElement(ImmersiveBrandedAdMenu, {
		screenPosition = v10.menuScreenPosition,
		advertiserName = v10.advertiserName,
		campaignId = v10.campaignId,
		immersiveBrandedAdId = v10.immersiveBrandedAdId,
		onDismiss = v12
	})
end
