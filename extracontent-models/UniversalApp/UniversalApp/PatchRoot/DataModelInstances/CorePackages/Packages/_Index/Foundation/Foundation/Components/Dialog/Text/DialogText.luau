local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local useDialogVariants = require(script.Parent.Parent.useDialogVariants).useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)

local function DialogText(t1: {[any]: any}) -- line: 17
	-- upvalues: useDialogVariants (copy), useDialog (copy), React (copy), Text (copy)
	local v9 = useDialogVariants()
	local v10 = useDialog()

	return React.createElement(Text, {
		RichText = true,
		Text = t1.Text,
		tag = v9.contentText.tag,
		LayoutOrder = t1.LayoutOrder,
		testId = `{ v10.testId }--text`
	})
end

return DialogText
