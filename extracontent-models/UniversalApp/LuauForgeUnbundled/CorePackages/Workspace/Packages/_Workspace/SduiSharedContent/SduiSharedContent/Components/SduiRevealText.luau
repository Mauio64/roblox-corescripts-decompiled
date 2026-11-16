local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")

local SduiText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiText")
local useRevealText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useRevealText")

local function SduiRevealText(props)
	local v5 = useRevealText({
		delimiter = props.delimiter,
		removeDelimiter = props.removeDelimiter,
		revealInterval = props.revealInterval,
		richText = props.richText,
		text = props.text
	})

	local v6 = React.useMemo(function()
		return Cryo.Dictionary.join(props, {
			delimiter = Cryo.None,
			removeDelimiter = Cryo.None,
			revealInterval = Cryo.None,
			text = v5
		})
	end, { props, v5 })

	return React.createElement(SduiText, v6)
end

return SduiRevealText
