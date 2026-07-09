local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local useDeviceOrientation = require(PeopleReactViewParent.RobloxAppHooks).useDeviceOrientation
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local Foundation = require(PeopleReactViewParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local StateLayerMode = Foundation.Enums.StateLayerMode
local Button = Foundation.Button
local FoundationText = Foundation.Text
local View = Foundation.View
local Constants = require(PeopleReactView.Constants)
local GetFFlagFixPeoplePageCardTooltip = PeopleService.getService("Flags").GetFFlagFixPeoplePageCardTooltip

local function CardTooltip(p1) -- line: 33
	-- upvalues: useTokens (copy), GetFFlagFixPeoplePageCardTooltip (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), React (copy), useLocalization (copy), Constants (copy), View (copy), StateLayerMode (copy), FoundationText (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v20 = useTokens()
	local uDim2 = UDim2.fromScale(1.75, 0)

	if GetFFlagFixPeoplePageCardTooltip() then
		local v22 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait

		uDim2 = React.useMemo(function() -- line: 41
			-- upvalues: v22 (copy)
			if v22 then
				return (UDim2.fromScale(1, 0))
			end

			return (UDim2.fromScale(1.75, 0))
		end, { v22 })
	end

	local v23 = useLocalization({
		title = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.BUY_WHAT_THEYRE_WEARING,
		description = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.SELECT_AVATAR_TO_CHECKOUT_ITEMS,
		secondaryDescription = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.SELECT_USERNAME_TO_VIEW_PROFILE,
		ok = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.OK
	})

	return React.createElement(View, {
		tag = "auto-y radius-medium",
		ZIndex = 2,
		backgroundStyle = v20.Inverse.Surface.Surface_0,
		Position = UDim2.new(1, v20.Size.Size_300, 0, 0),
		Size = uDim2,
		stateLayer = {
			mode = StateLayerMode.Inverse
		}
	}, {
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium padding-medium"
		}, {
			Title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-title-large content-inverse-emphasis text-align-x-left text-wrap",
				LayoutOrder = 1,
				Text = v23.title
			}),
			Description = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium content-inverse-default text-align-x-left text-wrap",
				LayoutOrder = 2,
				Text = v23.description
			}),
			SecondaryDescription = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium content-inverse-default text-align-x-left text-wrap",
				LayoutOrder = 3,
				Text = v23.secondaryDescription
			}),
			Action = React.createElement(Button, {
				LayoutOrder = 4,
				text = v23.ok,
				size = InputSize.Medium,
				width = UDim.new(1, 0),
				variant = ButtonVariant.Emphasis,
				onActivated = p1.action
			})
		}),
		Arrow = React.createElement(View, {
			tag = "size-200 radius-xsmall",
			Rotation = 45,
			backgroundStyle = v20.Inverse.Surface.Surface_0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 1, 0.5, 0),
			stateLayer = {
				mode = StateLayerMode.Inverse
			}
		})
	})
end

return CardTooltip
