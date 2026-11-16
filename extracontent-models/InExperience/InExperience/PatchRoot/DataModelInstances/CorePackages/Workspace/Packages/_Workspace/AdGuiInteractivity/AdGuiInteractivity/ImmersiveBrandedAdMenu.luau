local GuiService = game:GetService("GuiService")

local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local parent = AdGuiInteractivity.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local ImmersiveBrandedAdWhyThisAdDialog = require(AdGuiInteractivity.ImmersiveBrandedAdWhyThisAdDialog)
local ImmersiveBrandedAdReportAdDialog = require(AdGuiInteractivity.ImmersiveBrandedAdReportAdDialog)
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)

local Menu = Foundation.Menu
local InputSize = Foundation.Enums.InputSize
local PopoverSide = Foundation.Enums.PopoverSide
local useLocalization = Localization.Hooks.useLocalization
local useMeasurableRef = Foundation.Hooks.useMeasurableRef

local _ = { WhyThisAd = "whyThisAd", ReportAd = "reportAd" }

return function(props)
	local screenPosition = props.screenPosition
	local v = useLocalization({
		WhyThisAdText = "CoreScripts.Ads.Label.WhyThisAd",
		ReportAdText = "CoreScripts.Ads.Label.ReportAd"
	})

	local state, setState = React.useState(nil)
	local anchorRef = useMeasurableRef(screenPosition)

	React.useEffect(function()
		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			props.onDismiss()
		end)

		return function()
			menuOpenedConnection:Disconnect()
		end
	end, { props.onDismiss })

	local items = React.useMemo(function()
		return {
			{ id = "whyThisAd", icon = "icons/actions/info_small", text = v.WhyThisAdText },
			{ id = "reportAd", icon = "icons/actions/feedback", text = v.ReportAdText }
		}
	end, { v.WhyThisAdText, v.ReportAdText })

	local onActivated = React.useCallback(function(p: string)
		if p == "whyThisAd" then
			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("whyThisAd")
			setState("whyThisAd")
		elseif p == "reportAd" then
			AdsInteractivityTelemetry.logImmersiveBrandedAdButtonClickCounter("reportAd")
			setState("reportAd")
		end
	end, {})

	if state == "whyThisAd" then
		return React.createElement(ImmersiveBrandedAdWhyThisAdDialog, {
			advertiserName = props.advertiserName,
			onDismiss = props.onDismiss
		})
	elseif state == "reportAd" then
		return React.createElement(ImmersiveBrandedAdReportAdDialog, {
			immersiveBrandedAdId = props.immersiveBrandedAdId,
			onDismiss = props.onDismiss
		})
	end

	return React.createElement(React.Fragment, nil, {
		menu = React.createElement(Menu, {
			isOpen = true,
			items = items,
			size = InputSize.Small,
			side = PopoverSide.Right,
			onActivated = onActivated,
			onPressedOutside = props.onDismiss,
			anchorRef = anchorRef
		}),
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Modal = true
		})
	})
end
