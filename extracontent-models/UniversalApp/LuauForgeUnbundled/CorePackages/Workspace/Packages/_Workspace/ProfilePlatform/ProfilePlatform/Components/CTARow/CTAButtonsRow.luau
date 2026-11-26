require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local CTAButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/CTAButton")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local text = Foundation.Text
local popoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens

local useDisabledReasonText = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfileActionBar/useDisabledReasonText")

local FFlagEnableProfilePlatformDisabledReasonText = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableProfilePlatformDisabledReasonText")

local function CTAButtonsRow(p2)
	local v5 = if FFlagEnableProfilePlatformDisabledReasonText then useTokens() else nil
	local v6

	if FFlagEnableProfilePlatformDisabledReasonText then
		v6 = React.useMemo(function()
			for k, button in p2.buttonList do
				if button.disabledReason then
					return button.disabledReason
				end
			end

			return nil
		end, { p2.buttonList })
	end

	local v7 = if FFlagEnableProfilePlatformDisabledReasonText then useDisabledReasonText(v6) else nil

	local v8 = React.useMemo(function()
		local children = {}

		for k, button in p2.buttonList do
			local formatted = `CTAButton_{k}`
			local createElement = React.createElement

			local v11 = if k <= #p2.buttonList / 2 then popoverAlign.Start else popoverAlign.End
			children[formatted] = createElement(CTAButton, {
				buttonItem = button,
				layoutOrder = k,
				align = v11
			})
		end

		return children
	end, { p2.buttonList })

	local createElement = React.createElement
	local v10 = {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = p2.layoutOrder
	}
	local v11 = {
		ButtonRow = React.createElement(
			view,
			{ tag = "row gap-small size-full-0 auto-y", LayoutOrder = 0 },
			v8
		),
		DisabledReasonText = 0
	}

	local v12 = if FFlagEnableProfilePlatformDisabledReasonText and v7 and v5 then React.createElement(text, {
		LayoutOrder = 1,
		Text = v7,
		TextWrapped = true,
		fontStyle = v5.Typography.CaptionMedium,
		colorStyle = v5.Color.Content.Emphasis,
		tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom"
	}) else nil
	v11.DisabledReasonText = v12
	return createElement(view, v10, v11)
end

return CTAButtonsRow
