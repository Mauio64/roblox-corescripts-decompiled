local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")

local view = Foundation.View
local text = Foundation.Text
local checkbox = Foundation.Checkbox

local inputSize = Foundation.Enums.InputSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function MarketingConsentCheckbox(props)
	local v5 = props.size == inputSize.Small or props.size == inputSize.XSmall
	local smallGap = props.smallGap == true
	local onToggled = props.onToggled
	local isDisabled = props.isDisabled
	local v6 = React.useCallback(function(p2)
		onToggled()
	end, { onToggled })
	local v7 = React.useCallback(function()
		if not isDisabled then
			onToggled()
		end
	end, { onToggled, isDisabled })

	return React.createElement(view, {
		tag = {
			["row align-y-top size-full-0 auto-y"] = true,
			["gap-small"] = smallGap,
			["gap-medium"] = not smallGap
		},
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeMarketingConsent"
	}, {
		Box = React.createElement(checkbox, {
			label = "",
			isChecked = props.isChecked,
			isDisabled = isDisabled,
			onActivated = v6,
			size = props.size,
			LayoutOrder = 1,
			testId = "AccountUpgradeMarketingConsentBox"
		}),
		Text = React.createElement(view, {
			tag = { ["fill size-full-0 auto-y"] = true, ["padding-top-xxsmall"] = v5 },
			GroupTransparency = isDisabled and 0.5 or 0,
			LayoutOrder = 2,
			testId = "AccountUpgradeMarketingConsentText"
		}, {
			Text = React.createElement(text, {
				Text = props.text,
				tag = {
					["size-full-0 auto-y text-wrap text-align-x-left content-emphasis"] = true,
					["text-body-small"] = v5,
					["text-body-medium"] = not v5
				},
				onActivated = v7,
				isDisabled = isDisabled,
				stateLayer = { affordance = stateLayerAffordance.None },
				selection = { Selectable = false }
			})
		})
	})
end

return MarketingConsentCheckbox
