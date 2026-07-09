local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local Divider = Foundation.Divider
local View = Foundation.View
local SessionActionButtons = require(InExperienceSideSheet.Components.SessionActionButtons)

local function Footer(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), View (copy), Divider (copy), SessionActionButtons (copy)
	return React.createElement(View, {
		tag = "col size-full-0 auto-y padding-right-xlarge padding-bottom-medium",
		LayoutOrder = t1.layoutOrder
	}, {
		FooterDivider = React.createElement(View, {
			tag = "size-full-0 auto-y padding-bottom-medium",
			LayoutOrder = 1
		}, {
			Divider = React.createElement(Divider)
		}),
		SessionActionButtons = React.createElement(SessionActionButtons, {
			layoutOrder = 2
		})
	})
end

return React.memo(Footer)
