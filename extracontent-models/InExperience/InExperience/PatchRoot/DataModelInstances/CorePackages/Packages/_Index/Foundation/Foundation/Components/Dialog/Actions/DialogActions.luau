local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ButtonGroup = require(Foundation.Components.ButtonGroup)
require(Foundation.Enums.ButtonVariant)
local DialogSize = require(Foundation.Enums.DialogSize)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Orientation = require(Foundation.Enums.Orientation)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withDefaults = require(Foundation.Utility.withDefaults)

local useDialogVariants = require(script.Parent.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)

local v = { orientation = Orientation.Horizontal }

local function DialogActions(p)
	local v2 = withDefaults(p, v)
	local v3 = useDialogVariants2()
	local v4 = useDialog()

	local v5 = v4.responsiveSize == DialogSize.Small

	if v2.orientation ~= Orientation.Vertical then
		v5 = false
	end

	local createElement = React.createElement
	local v6 = {
		tag = "col size-full-0 auto-y",
		LayoutOrder = v2.LayoutOrder,
		testId = `{v4.testId}--actions`
	}

	local createElement2 = React.createElement
	local v8 = {
		buttons = v2.actions or {},
		orientation = 0,
		fillBehavior = 0,
		LayoutOrder = 1,
		testId = 0
	}
	local orientation

	if v5 then
		orientation = Orientation.Vertical
	else
		orientation = Orientation.Horizontal
	end

	v8.orientation = orientation
	v8.fillBehavior = FillBehavior.Fill

	v8.testId = `{v4.testId}--actions-container`
	local v7 = {
		ActionsContainer = createElement2(ButtonGroup, v8),
		ActionsLabel = 0
	}
	local actionsLabel

	if v2.label then
		actionsLabel = React.createElement(Text, {
			Text = v2.label,
			tag = v3.actionsLabel.tag,
			LayoutOrder = 2,
			testId = `{v4.testId}--actions-label`
		})
	end

	v7.ActionsLabel = actionsLabel
	return createElement(View, v6, v7)
end

return DialogActions
