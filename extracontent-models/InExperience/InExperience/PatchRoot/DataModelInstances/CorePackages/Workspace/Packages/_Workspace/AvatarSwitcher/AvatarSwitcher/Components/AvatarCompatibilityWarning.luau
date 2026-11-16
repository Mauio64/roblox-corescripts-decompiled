local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherExpiredItemsWarning = AvatarExperienceFlags.FFlagAvatarSwitcherExpiredItemsWarning

local function AvatarCompatibilityWarning(p)
	local v = useTokens()
	local v2 = {
		partiallyUnsupported = not FFlagAvatarSwitcherExpiredItemsWarning and "Feature.AvatarSwitcher.Message.PartiallyUnsupported" or nil,
		message = 0
	}
	local message

	if FFlagAvatarSwitcherExpiredItemsWarning then
		message = p.message
	end

	v2.message = message
	local v3 = useLocalization(v2)

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = { tag = "size-full-0 auto-y", LayoutOrder = p.LayoutOrder }
	local v5 = {
		InfoIcon = React.createElement(Foundation.Image, {
			Image = "icons/actions/info",
			Size = UDim2.fromOffset(v.Size.Size_500, v.Size.Size_500),
			LayoutOrder = 1
		}),
		CompatibilityWarning = 0
	}

	local createElement2 = React.createElement
	local text = Foundation.Text
	local v6 = {
		tag = "auto-y position-top-right anchor-top-right text-caption-small text-wrap text-align-x-left padding-top-xsmall",
		Size = UDim2.new(1, -v.Size.Size_500 - v.Gap.Small, 0, 0),
		Text = 0,
		LayoutOrder = 2
	}
	local text2

	if FFlagAvatarSwitcherExpiredItemsWarning then
		text2 = v3.message
	else
		text2 = v3.partiallyUnsupported
	end

	v6.Text = text2
	v5.CompatibilityWarning = createElement2(text, v6)
	return createElement(view, v4, v5)
end

return AvatarCompatibilityWarning
