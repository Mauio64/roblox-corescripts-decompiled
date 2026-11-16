local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)

local PeopleService = require(parent.PeopleService)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local StateLayerMode = Foundation.Enums.StateLayerMode
local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local Constants = require(PeopleReactView.Constants)

local getFFlagFixPeoplePageCardTooltip = PeopleService.getService("Flags").GetFFlagFixPeoplePageCardTooltip

local function CardTooltip(p)
	local v = useTokens()

	local size = UDim2.fromScale(1.75, 0)

	if getFFlagFixPeoplePageCardTooltip() then
		local v2 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait

		size = React.useMemo(function()
			if v2 then
				return (UDim2.fromScale(1, 0))
			end

			return (UDim2.fromScale(1.75, 0))
		end, { v2 })
	end

	local v2 = useLocalization({
		title = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.BUY_WHAT_THEYRE_WEARING,
		description = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.SELECT_AVATAR_TO_CHECKOUT_ITEMS,
		secondaryDescription = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.SELECT_USERNAME_TO_VIEW_PROFILE,
		ok = Constants.PEOPLEPAGE.CARD_TOOLTIP.LOCALIZED_STRINGS.OK
	})

	return React.createElement(View, {
		tag = "auto-y radius-medium",
		backgroundStyle = v.Inverse.Surface.Surface_0,
		Position = UDim2.new(1, v.Size.Size_300, 0, 0),
		Size = size,
		stateLayer = { mode = StateLayerMode.Inverse },
		ZIndex = 2
	}, {
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium padding-medium"
		}, {
			Title = React.createElement(Text, {
				tag = "size-full-0 auto-y text-title-large content-inverse-emphasis text-align-x-left text-wrap",
				Text = v2.title,
				LayoutOrder = 1
			}),
			Description = React.createElement(Text, {
				tag = "size-full-0 auto-y text-body-medium content-inverse-default text-align-x-left text-wrap",
				Text = v2.description,
				LayoutOrder = 2
			}),
			SecondaryDescription = React.createElement(Text, {
				tag = "size-full-0 auto-y text-body-medium content-inverse-default text-align-x-left text-wrap",
				Text = v2.secondaryDescription,
				LayoutOrder = 3
			}),
			Action = React.createElement(Button, {
				text = v2.ok,
				size = InputSize.Medium,
				width = UDim.new(1, 0),
				variant = ButtonVariant.Emphasis,
				LayoutOrder = 4,
				onActivated = p.action
			})
		}),
		Arrow = React.createElement(View, {
			tag = "size-200 radius-xsmall",
			backgroundStyle = v.Inverse.Surface.Surface_0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, 1, 0.5, 0),
			Rotation = 45,
			stateLayer = { mode = StateLayerMode.Inverse }
		})
	})
end

return CardTooltip
