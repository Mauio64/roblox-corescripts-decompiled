local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local SduiText = require(script.Parent.SduiText)
local useRevealText = require(script.Parent.useRevealText)

local function SduiRevealText(props)
	local text = useRevealText({
		delimiter = props.delimiter,
		removeDelimiter = props.removeDelimiter,
		revealInterval = props.revealInterval,
		richText = props.richText,
		text = props.text
	})

	local v = React.useMemo(function()
		return Cryo.Dictionary.join(props, {
			delimiter = Cryo.None,
			removeDelimiter = Cryo.None,
			revealInterval = Cryo.None,
			text = text
		})
	end, { props, text })

	return React.createElement(SduiText, v)
end

return SduiRevealText
