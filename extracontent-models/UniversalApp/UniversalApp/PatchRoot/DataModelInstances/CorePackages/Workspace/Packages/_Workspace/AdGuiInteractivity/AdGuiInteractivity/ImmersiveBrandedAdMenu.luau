local GuiService = game:GetService("GuiService")
local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local AdGuiInteractivityParent = AdGuiInteractivity.Parent
local React = require(AdGuiInteractivityParent.React)
local Foundation = require(AdGuiInteractivityParent.Foundation)
local Localization = require(AdGuiInteractivityParent.Localization)
local ImmersiveBrandedAdWhyThisAdDialog = require(AdGuiInteractivity.ImmersiveBrandedAdWhyThisAdDialog)
local ImmersiveBrandedAdReportAdDialog = require(AdGuiInteractivity.ImmersiveBrandedAdReportAdDialog)
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)
local Menu = Foundation.Menu
local InputSize = Foundation.Enums.InputSize
local PopoverSide = Foundation.Enums.PopoverSide
local useLocalization = Localization.Hooks.useLocalization
local useMeasurableRef = Foundation.Hooks.useMeasurableRef
local _ = {
	WhyThisAd = "whyThisAd",
	ReportAd = "reportAd"
}

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), React (copy), useMeasurableRef (copy), GuiService (copy), AdsInteractivityTelemetry (copy), ImmersiveBrandedAdWhyThisAdDialog (copy), ImmersiveBrandedAdReportAdDialog (copy), Menu (copy), InputSize (copy), PopoverSide (copy)
	local screenPosition = t1.screenPosition
	local v18 = useLocalization({
		WhyThisAdText = "CoreScripts.Ads.Label.WhyThisAd",
		ReportAdText = "CoreScripts.Ads.Label.ReportAd"
	})
	local v19, v20 = React.useState(nil)
	local v21 = useMeasurableRef(screenPosition)

	React.useEffect(function() -- line: 44
		-- upvalues: GuiService (copy), t1 (copy)
		local connection = GuiService.MenuOpened:Connect(function() -- line: 45
			-- upvalues: t1 (copy)
			t1.onDismiss()
		end)

		return function() -- line: 49
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t1.onDismiss })

	local v22 = React.useMemo(function() -- line: 54
		-- upvalues: v18 (copy)
		return {
			{
				id = "whyThisAd",
				icon = "icons/actions/info_small",
				text = v18.WhyThisAdText
			},
			{
				id = "reportAd",
				icon = "icons/actions/feedback",
				text = v18.ReportAdText
			}
		}
	end, {
		v18.WhyThisAdText,
		v18.ReportAdText
	})
	local v23 = React.useCallback(function(s1: string) -- line: 69
		-- upvalues: AdsInteractivityTelemetry (copy), v20 (copy)
		if s1 == "whyThisAd" then
			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("whyThisAd")
			v20("whyThisAd")

			return
		end

		if s1 == "reportAd" then
			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("reportAd")
			v20("reportAd")
		end
	end, {})

	if v19 == "whyThisAd" then
		return React.createElement(ImmersiveBrandedAdWhyThisAdDialog, {
			advertiserName = t1.advertiserName,
			onDismiss = t1.onDismiss
		})
	end

	if v19 == "reportAd" then
		return React.createElement(ImmersiveBrandedAdReportAdDialog, {
			immersiveBrandedAdId = t1.immersiveBrandedAdId,
			onDismiss = t1.onDismiss
		})
	end

	return React.createElement(React.Fragment, nil, {
		menu = React.createElement(Menu, {
			isOpen = true,
			items = v22,
			size = InputSize.Small,
			side = PopoverSide.Right,
			onActivated = v23,
			onPressedOutside = t1.onDismiss,
			anchorRef = v21
		}),
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		})
	})
end
