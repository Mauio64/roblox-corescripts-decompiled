local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local useDialog = require(script.Parent.Parent.useDialog)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants

local function DialogTitle(p)
	local v = useTokens()
	local v2 = useDialog()
	local v3 = useDialogVariants2()

	local createElement = React.createElement
	local v4 = {
		tag = v3.title.tag,
		LayoutOrder = Constants.MIN_LAYOUT_ORDER + 1,
		padding = 0,
		testId = 0
	}
	local right

	if not v2.hasHeroMedia then
		right = UDim.new(0, v3.closeAffordance.offset + v.Size.Size_1000)
	end

	local top

	if not v2.hasHeroMedia then
		top = UDim.new(0, v.Size.Size_500)
	end

	v4.padding = { right = right, top = top }

	v4.testId = `{v2.testId}--title`
	return createElement(View, v4, {
		Title = React.createElement(Text, { tag = v3.titleText.tag, Text = p.text })
	})
end

return DialogTitle
