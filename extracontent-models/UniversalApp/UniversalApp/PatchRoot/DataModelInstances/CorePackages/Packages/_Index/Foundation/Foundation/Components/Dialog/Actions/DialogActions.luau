local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Button = require(Foundation.Components.Button)

require(Foundation.Enums.ButtonVariant)

local DialogSize = require(Foundation.Enums.DialogSize)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Orientation = require(Foundation.Enums.Orientation)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withDefaults = require(Foundation.Utility.withDefaults)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants).useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)
local t1 = {
	orientation = Orientation.Horizontal
}

local function DialogActions(t2: {[any]: any}) -- line: 44
	-- upvalues: withDefaults (copy), t1 (copy), useDialogVariants (copy), useDialog (copy), React (copy), Dash (copy), Button (copy), FillBehavior (copy), DialogSize (copy), Orientation (copy), View (copy), Text (copy)
	local v17 = withDefaults(t2, t1)
	local v18 = useDialogVariants()
	local v19 = useDialog()
	local v20 = React.useMemo(function() -- line: 49
		-- upvalues: v17 (copy), React (copy), Dash (copy), Button (copy), FillBehavior (copy)
		if not v17.actions then
			return nil
		end

		return React.createElement(React.Fragment, nil, Dash.map(v17.actions, function(p1, p2) -- line: 56
			-- upvalues: React (copy), Button (copy), Dash (copy), FillBehavior (copy)
			return React.createElement(Button, Dash.join(p1, {
				key = `{ p2 }-{ p1.text }`,
				Name = p1.text,
				LayoutOrder = p2,
				fillBehavior = FillBehavior.Fill
			}))
		end))
	end, { v17.actions })
	local v21 = v19.responsiveSize == DialogSize.Small
	local v22 = v17.orientation == Orientation.Horizontal or not v21
	local v23 = v17.orientation == Orientation.Vertical and v21

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = v17.LayoutOrder,
		testId = `{ v19.testId }--actions`
	}, {
		ActionsContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["gap-small size-full-0 auto-y"] = true,
				["row wrap"] = v22,
				["col flex-x-fill"] = v23
			},
			testId = `{ v19.testId }--actions-container`
		}, {
			Actions = v20
		}),
		ActionsLabel = if not v17.label then nil else React.createElement(Text, {
			LayoutOrder = 2,
			Text = v17.label,
			tag = v18.actionsLabel.tag,
			testId = `{ v19.testId }--actions-label`
		})
	})
end

return DialogActions
