local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)

local useDialogVariants = require(script.Parent.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)

local function DialogText(p)
	local v = useDialogVariants2()
	local v2 = useDialog()

	return React.createElement(Text, {
		Text = p.Text,
		RichText = true,
		tag = v.contentText.tag,
		LayoutOrder = p.LayoutOrder,
		testId = `{v2.testId}--text`
	})
end

return DialogText
