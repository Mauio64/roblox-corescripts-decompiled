local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local useDialog = require(script.Parent.Parent.useDialog)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants).useDialogVariants

local function DialogTitle(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), useDialog (copy), useDialogVariants (copy), React (copy), View (copy), Constants (copy), Text (copy)
	local v12 = useTokens()
	local v13 = useDialog()
	local v14 = useDialogVariants()

	return React.createElement(View, {
		tag = v14.title.tag,
		LayoutOrder = Constants.MIN_LAYOUT_ORDER + 1,
		padding = {
			right = if not v13.hasHeroMedia then UDim.new(0, v14.closeAffordance.offset + v12.Size.Size_1000) else nil,
			top = if not v13.hasHeroMedia then UDim.new(0, v12.Size.Size_500) else nil
		},
		testId = `{ v13.testId }--title`
	}, {
		Title = React.createElement(Text, {
			tag = v14.titleText.tag,
			Text = t1.text
		})
	})
end

return DialogTitle
