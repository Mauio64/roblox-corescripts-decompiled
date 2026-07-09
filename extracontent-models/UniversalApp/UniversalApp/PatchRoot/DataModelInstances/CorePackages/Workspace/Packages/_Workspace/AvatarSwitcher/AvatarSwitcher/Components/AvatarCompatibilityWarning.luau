local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FFlagAvatarSwitcherExpiredItemsWarning = require(Parent.AvatarExperienceFlags).FFlagAvatarSwitcherExpiredItemsWarning

local function AvatarCompatibilityWarning(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), useLocalization (copy), FFlagAvatarSwitcherExpiredItemsWarning (copy), React (copy), Foundation (copy)
	local v9 = useTokens()
	local v10 = useLocalization({
		partiallyUnsupported = not FFlagAvatarSwitcherExpiredItemsWarning and "Feature.AvatarSwitcher.Message.PartiallyUnsupported" or nil,
		message = if not FFlagAvatarSwitcherExpiredItemsWarning then nil else t1.message
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		InfoIcon = React.createElement(Foundation.Image, {
			Image = "icons/actions/info",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v9.Size.Size_500, v9.Size.Size_500)
		}),
		CompatibilityWarning = React.createElement(Foundation.Text, {
			tag = "auto-y position-top-right anchor-top-right text-caption-small text-wrap text-align-x-left padding-top-xsmall",
			LayoutOrder = 2,
			Size = UDim2.new(1, -v9.Size.Size_500 - v9.Gap.Small, 0, 0),
			Text = if not FFlagAvatarSwitcherExpiredItemsWarning then v10.partiallyUnsupported else v10.message
		})
	})
end

return AvatarCompatibilityWarning
