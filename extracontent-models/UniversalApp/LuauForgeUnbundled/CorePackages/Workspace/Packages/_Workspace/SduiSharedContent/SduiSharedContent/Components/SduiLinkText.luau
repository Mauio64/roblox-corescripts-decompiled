local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")
local checkAndFormatPossibleLink = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/CollectionViews").checkAndFormatPossibleLink
local SduiText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiText")

local useTokens = Foundation.Hooks.useTokens

local FFlagSduiLinkTextStyleOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Flags/FFlagSduiLinkTextStyleOverride")

local function SduiLinkText(props)
	local v5 = useTokens()
	local v6 = props.text
	local v7 = props.richText

	if v6 then
		local color3

		if props.linkStyle and props.linkStyle.Color3 then
			color3 = props.linkStyle.Color3
		else
			color3 = v5.Color.Content.Link.Color3
		end

		local v8 = string.format(
			"rgb(%d, %d, %d)",
			math.round(color3.R * 255),
			math.round(color3.G * 255),
			(math.round(color3.B * 255))
		)

		local v9 = not FFlagSduiLinkTextStyleOverride or props.isLinkBold ~= false
		local v10 = if FFlagSduiLinkTextStyleOverride then props.isLinkUnderlined == true else false

		local v11 = `<font color="{v8}">`
		local v12 = "</font>"

		if v10 then
			v11 ..= "<u>"
			v12 = "</u>" .. v12
		end

		if v9 then
			v11 ..= "<b>"
			v12 = "</b>" .. v12
		end

		local v13, v14 = checkAndFormatPossibleLink(v6, nil, nil, v11, v12)

		if v13 then
			v6 = v14
			v7 = true
		end
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v9 = {
		text = v6,
		richText = v7,
		linkStyle = Cryo.None,
		isLinkBold = 0,
		isLinkUnderlined = 0
	}
	local v10 = if FFlagSduiLinkTextStyleOverride then Cryo.None else nil
	v9.isLinkBold = v10
	local v11 = if FFlagSduiLinkTextStyleOverride then Cryo.None else nil
	v9.isLinkUnderlined = v11
	return createElement(SduiText, join(props, v9))
end

return SduiLinkText
