local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local SduiText = require(script.Parent.SduiText)
local useRevealText = require(script.Parent.useRevealText)

local function SduiRevealText(p1) -- line: 16
	-- upvalues: useRevealText (copy), React (copy), Cryo (copy), SduiText (copy)
	local v8 = useRevealText({
		delimiter = p1.delimiter,
		removeDelimiter = p1.removeDelimiter,
		revealInterval = p1.revealInterval,
		richText = p1.richText,
		text = p1.text
	})
	local v9 = React.useMemo(function() -- line: 24
		-- upvalues: Cryo (copy), p1 (copy), v8 (copy)
		return Cryo.Dictionary.join(p1, {
			delimiter = Cryo.None,
			removeDelimiter = Cryo.None,
			revealInterval = Cryo.None,
			text = v8
		})
	end, {
		p1,
		v8
	})

	return React.createElement(SduiText, v9)
end

return SduiRevealText
