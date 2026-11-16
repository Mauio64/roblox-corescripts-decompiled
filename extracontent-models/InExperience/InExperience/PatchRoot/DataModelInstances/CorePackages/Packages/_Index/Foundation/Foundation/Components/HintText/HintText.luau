local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local function HintText(props, ref)
	return React.createElement(Text, withCommonProps(props, {
		Text = props.text,
		tag = {
			["size-full-0 auto-y text-caption-small text-align-x-left text-align-y-top text-wrap"] = true,
			["content-action-alert"] = props.hasError,
			["content-muted"] = props.isDisabled and not props.hasError,
			["content-default"] = not (props.isDisabled or props.hasError)
		},
		ref = ref
	}))
end

return React.memo(React.forwardRef(HintText))
