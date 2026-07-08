local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)
require(ProfilePlatform.Common.Enums)

local React = require(ProfilePlatformParent.React)
local CTAButton = require(ProfilePlatform.Components.CTARow.CTAButton)
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local PopoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens
local useDisabledReasonText = require(ProfilePlatform.Components.ProfileActionBar.useDisabledReasonText)
local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)

local function CTAButtonsRow(t1: {[any]: any}) -- line: 26
	-- upvalues: FFlagEnableProfilePlatformDisabledReasonText (copy), useTokens (copy), React (copy), useDisabledReasonText (copy), CTAButton (copy), PopoverAlign (copy), View (copy), FoundationText (copy)
	local v14 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else useTokens()
	local v15 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else React.useMemo(function() -- line: 30
		-- upvalues: t1 (copy)
		for _, v19 in t1.buttonList do
			if v19.disabledReason then
				return v19.disabledReason
			end
		end

		return nil
	end, { t1.buttonList })
	local v16 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else useDisabledReasonText(v15)
	local v17 = React.useMemo(function() -- line: 44
		-- upvalues: t1 (copy), React (copy), CTAButton (copy), PopoverAlign (copy)
		local t2 = {}

		for v21, v22 in t1.buttonList do
			t2[`CTAButton_{ v21 }`] = React.createElement(CTAButton, {
				buttonItem = v22,
				layoutOrder = v21,
				align = if not (v21 <= #t1.buttonList / 2) then PopoverAlign.End else PopoverAlign.Start
			})
		end

		return t2
	end, { t1.buttonList })

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		ButtonRow = React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y",
			LayoutOrder = 0
		}, v17),
		DisabledReasonText = if not FFlagEnableProfilePlatformDisabledReasonText or (not v16 or not v14) then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			TextWrapped = true,
			tag = "size-full-0 auto-y text-align-x-left text-align-y-bottom",
			Text = v16,
			fontStyle = v14.Typography.CaptionMedium,
			colorStyle = v14.Color.Content.Emphasis
		})
	})
end

return CTAButtonsRow
