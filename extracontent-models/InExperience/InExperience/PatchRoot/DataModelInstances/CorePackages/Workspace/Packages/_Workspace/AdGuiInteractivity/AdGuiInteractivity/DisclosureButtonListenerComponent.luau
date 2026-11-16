local AdService = game:GetService("AdService")

local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local parent = AdGuiInteractivity.Parent
local React = require(parent.React)
local t = require(parent.t)

local getScreenPositionFromGuiObjectInput = require(AdGuiInteractivity.getScreenPositionFromGuiObjectInput)
local ImmersiveBrandedAdMenu = require(AdGuiInteractivity.ImmersiveBrandedAdMenu)
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)

local interface = t.interface({
	disclosureButton = t.instanceIsA("GuiButton"),
	inputObject = t.instanceIsA("InputObject"),
	advertiserName = t.string,
	campaignId = t.string,
	immersiveBrandedAdId = t.string
})

return function()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		function AdService.OnImmersiveBrandedAdDisclosureButtonActivated(data)
			local v, _ = interface(data)

			if not v then
				return
			end

			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("disclosure")
			setState({
				menuScreenPosition = getScreenPositionFromGuiObjectInput(data.disclosureButton, data.inputObject),
				advertiserName = data.advertiserName,
				campaignId = data.campaignId,
				immersiveBrandedAdId = data.immersiveBrandedAdId
			})
		end

		return function()
			function AdService.OnImmersiveBrandedAdDisclosureButtonActivated() end
		end
	end, {})

	local onDismiss = React.useCallback(function()
		setState(nil)
	end, {})

	if state then
		return React.createElement(ImmersiveBrandedAdMenu, {
			screenPosition = state.menuScreenPosition,
			advertiserName = state.advertiserName,
			campaignId = state.campaignId,
			immersiveBrandedAdId = state.immersiveBrandedAdId,
			onDismiss = onDismiss
		})
	end

	return nil
end
