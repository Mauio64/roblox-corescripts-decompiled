local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ComponentSubtext(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy)
	local v8 = useTokens()

	return React.createElement(FoundationText, {
		tag = "auto-xy",
		Text = t1.requirementMessage,
		textStyle = if not t1.isOptional then v8.Color.System.Alert else v8.Color.Content.Muted,
		fontStyle = v8.Typography.CaptionMedium,
		Visible = (t1.isOptional or t1.isErrorState) and true or false,
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(ComponentSubtext)
