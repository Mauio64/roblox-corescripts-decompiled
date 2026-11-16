local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local text = Foundation.Text

local function BuildAttributionDisclaimer(props)
	local v5 = useLocalization({
		disclaimerText = "Feature.ExperienceDetails.Description.MadeWithBuild"
	})

	local v6 = useTokens()

	local horizontalPadding = props.horizontalPadding or v6.Padding.XLarge
	local v7 = if props.rightPadding == nil then horizontalPadding else props.rightPadding

	return React.createElement(view, {
		tag = "col size-full-0 auto-y align-x-left align-y-center",
		padding = {
			top = UDim.new(0, v6.Padding.XXLarge),
			bottom = UDim.new(0, v6.Padding.XXLarge),
			left = UDim.new(0, horizontalPadding),
			right = UDim.new(0, v7)
		},
		LayoutOrder = props.layoutOrder
	}, {
		DisclaimerText = React.createElement(text, {
			Text = v5.disclaimerText,
			tag = "text-body-medium content-muted size-full-0 auto-y text-wrap text-align-x-left",
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
end

return BuildAttributionDisclaimer
