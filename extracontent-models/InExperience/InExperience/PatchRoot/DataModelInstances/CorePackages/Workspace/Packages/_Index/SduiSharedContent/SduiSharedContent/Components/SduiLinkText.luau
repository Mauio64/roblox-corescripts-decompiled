local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local checkAndFormatPossibleLink = require(Parent.CollectionViews).checkAndFormatPossibleLink
local SduiText = require(script.Parent.SduiText)
local useTokens = Foundation.Hooks.useTokens

local function SduiLinkText(p1) -- line: 24
	-- upvalues: useTokens (copy), checkAndFormatPossibleLink (copy), React (copy), SduiText (copy), Cryo (copy)
	local v10 = useTokens()
	local text = p1.text
	local richText = p1.richText

	if text then
		local v13 = if not p1.linkStyle or not p1.linkStyle.Color3 then v10.Color.Content.Link.Color3 else p1.linkStyle.Color3
		local v14 = `<font color="{ string.format("rgb(%d, %d, %d)", math.round(v13.R * 255), math.round(v13.G * 255), (math.round(v13.B * 255))) }"><b>`
		local v15, v16 = checkAndFormatPossibleLink(text, nil, nil, v14, "</b></font>")

		if v15 then
			text = v16
			richText = true
		end
	end

	return React.createElement(SduiText, Cryo.Dictionary.join(p1, {
		text = text,
		richText = richText,
		linkStyle = Cryo.None
	}))
end

return SduiLinkText
