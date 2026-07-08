local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text

local function TextLink(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), getIconRichText (copy), IconName (copy), ControlState (copy), FoundationText (copy)
	local v10, v11 = React.useState(false)
	local v12 = getIconRichText(IconName.ArrowUpRightFromSquare)
	local v13 = React.useCallback(function(p1) -- line: 25
		-- upvalues: v11 (copy), ControlState (copy)
		v11(p1 == ControlState.Hover)
	end, {})

	return React.createElement(FoundationText, {
		RichText = true,
		Text = if not v10 then `{ t1.text } { v12 }` else `<u>{ t1.text }</u> { v12 }`,
		onActivated = t1.onActivated,
		onStateChanged = v13,
		tag = t1.tag or "auto-xy text-body-medium text-wrap text-align-x-left radius-small content-emphasis",
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(TextLink)
