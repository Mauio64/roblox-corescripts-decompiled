local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Divider = Foundation.Divider
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local SessionActionButtons = require(InExperienceSideSheet.Components.SessionActionButtons)

local function Footer(p)
	local v = useTokens()

	return React.createElement(
		View,
		{
			tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
			LayoutOrder = p.layoutOrder
		},
		{
			FooterDivider = React.createElement(
				View,
				{
					Size = UDim2.new(1, 0, 0, v.Stroke.Standard),
					testId = "side-sheet-footer-divider",
					LayoutOrder = 1
				},
				{
					DividerBleed = React.createElement(View, {
						Position = UDim2.fromOffset(-v.Padding.XLarge, 0),
						Size = UDim2.new(1, v.Padding.XLarge * 2, 1, 0),
						testId = "side-sheet-footer-divider-bleed"
					}, { Divider = React.createElement(Divider) })
				}
			),
			SessionActionButtons = React.createElement(SessionActionButtons, { layoutOrder = 2 })
		}
	)
end

return React.memo(Footer)
