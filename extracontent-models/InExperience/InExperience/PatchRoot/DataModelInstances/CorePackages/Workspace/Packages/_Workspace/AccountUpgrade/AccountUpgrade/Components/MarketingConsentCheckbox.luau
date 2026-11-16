local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Checkbox = Foundation.Checkbox

local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local function MarketingConsentCheckbox(props)
	local v = props.size == InputSize.Small or props.size == InputSize.XSmall
	local smallGap = props.smallGap == true
	local onToggled = props.onToggled
	local isDisabled = props.isDisabled
	local onActivated = React.useCallback(function(_: boolean)
		onToggled()
	end, { onToggled })
	local onActivated2 = React.useCallback(function()
		if not isDisabled then
			onToggled()
		end
	end, { onToggled, isDisabled })

	return React.createElement(View, {
		tag = {
			["row align-y-top size-full-0 auto-y"] = true,
			["gap-small"] = smallGap,
			["gap-medium"] = not smallGap
		},
		LayoutOrder = props.LayoutOrder,
		testId = "AccountUpgradeMarketingConsent"
	}, {
		Box = React.createElement(Checkbox, {
			label = "",
			isChecked = props.isChecked,
			isDisabled = isDisabled,
			onActivated = onActivated,
			size = props.size,
			LayoutOrder = 1,
			testId = "AccountUpgradeMarketingConsentBox"
		}),
		Text = React.createElement(View, {
			tag = { ["fill size-full-0 auto-y"] = true, ["padding-top-xxsmall"] = v },
			GroupTransparency = isDisabled and 0.5 or 0,
			LayoutOrder = 2,
			testId = "AccountUpgradeMarketingConsentText"
		}, {
			Text = React.createElement(Text, {
				Text = props.text,
				tag = {
					["size-full-0 auto-y text-wrap text-align-x-left content-emphasis"] = true,
					["text-body-small"] = v,
					["text-body-medium"] = not v
				},
				onActivated = onActivated2,
				isDisabled = isDisabled,
				stateLayer = { affordance = StateLayerAffordance.None },
				selection = { Selectable = false }
			})
		})
	})
end

return MarketingConsentCheckbox
