local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLocalization = Localization.Hooks.useLocalization
local usePreferredInput = Responsive.usePreferredInput
local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local InputSize = Foundation.Enums.InputSize
local Popover = Foundation.Popover
local ControlState = Foundation.Enums.ControlState
local useScaledValue = Foundation.Hooks.useScaledValue

local function SponsoredFooter(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), useScaledValue (copy), React (copy), usePreferredInput (copy), Responsive (copy), ControlState (copy), View (copy), FoundationText (copy), Popover (copy), Icon (copy), InputSize (copy)
	local v17 = useLocalization({
		SponsoredText = "Feature.GamePage.Label.Sponsored",
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})
	local v18 = useScaledValue(320)
	local v19, v20 = React.useState(false)
	local v21 = usePreferredInput() == Responsive.Input.Pointer
	local v22 = React.useCallback(function(p1) -- line: 32
		-- upvalues: ControlState (copy), v20 (copy)
		if p1 == ControlState.Hover or p1 == ControlState.Selected then
			v20(true)

			return
		end

		if p1 == ControlState.Default then
			v20(false)
		end
	end, {})
	local v23 = React.useCallback(function() -- line: 39
		-- upvalues: v20 (copy)
		v20(function(p2) -- line: 40
			return not p2
		end)
	end, {})

	return React.createElement(View, {
		tag = "row align-y-bottom align-x-center gap-xsmall flex-between auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		SponsoredText = React.createElement(FoundationText, {
			tag = "size-full-0 text-no-wrap text-body-medium content-default text-align-x-left auto-xy",
			LayoutOrder = 1,
			Text = v17.SponsoredText
		}),
		SponsoredTooltip = React.createElement(Popover.Root, {
			isOpen = v19
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				LayoutOrder = 2
			}, {
				IconView = React.createElement(View, {
					tag = "size-400-400 radius-circle",
					onStateChanged = if not v21 then nil else v22,
					onActivated = if not v21 then v23 else nil
				}, {
					Icon = React.createElement(Icon, {
						name = "icons/actions/info",
						size = InputSize.Small
					})
				})
			}),
			Content = React.createElement(Popover.Content, nil, {
				DescriptionView = React.createElement(View, {
					tag = "col gap-xsmall padding-small auto-xy size-full-2400",
					sizeConstraint = {
						MaxSize = Vector2.new(v18, 1e999)
					}
				}, {
					Description = React.createElement(FoundationText, {
						tag = "auto-xy text-body-small text-wrap",
						Text = v17.SponsoredDisclosure
					})
				})
			})
		})
	})
end

return React.memo(SponsoredFooter)
