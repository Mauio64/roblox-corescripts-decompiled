local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)
require(ProfilePlatform.Common.Enums)

local React = require(parent.React)
local CTAButton = require(ProfilePlatform.Components.CTARow.CTAButton)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local PopoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens

local useDisabledReasonText = require(ProfilePlatform.Components.ProfileActionBar.useDisabledReasonText)

local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)

local function CTAButtonsRow(p)
	local v

	if FFlagEnableProfilePlatformDisabledReasonText then
		v = useTokens()
	end

	local v2

	if FFlagEnableProfilePlatformDisabledReasonText then
		v2 = React.useMemo(function()
			for _, button in p.buttonList do
				if button.disabledReason then
					return button.disabledReason
				end
			end

			return nil
		end, { p.buttonList })
	end

	local text

	if FFlagEnableProfilePlatformDisabledReasonText then
		text = useDisabledReasonText(v2)
	end

	local v3 = React.useMemo(function()
		local children = {}

		for k, button in p.buttonList do
			local formatted = `CTAButton_{k}`
			local createElement = React.createElement
			local align

			if k <= #p.buttonList / 2 then
				align = PopoverAlign.Start
			else
				align = PopoverAlign.End
			end

			children[formatted] = createElement(CTAButton, {
				buttonItem = button,
				layoutOrder = k,
				align = align
			})
		end

		return children
	end, { p.buttonList })

	local createElement = React.createElement
	local v4 = { tag = "col gap-small size-full-0 auto-y", LayoutOrder = p.layoutOrder }
	local v5 = {
		ButtonRow = React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y",
			LayoutOrder = 0
		}, v3),
		DisabledReasonText = 0
	}
	local disabledReasonText

	if FFlagEnableProfilePlatformDisabledReasonText and text and v then
		disabledReasonText = React.createElement(Text, {
			LayoutOrder = 1,
			Text = text,
			TextWrapped = true,
			fontStyle = v.Typography.CaptionMedium,
			colorStyle = v.Color.Content.Emphasis,
			tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom"
		})
	end

	v5.DisabledReasonText = disabledReasonText
	return createElement(View, v4, v5)
end

return CTAButtonsRow
