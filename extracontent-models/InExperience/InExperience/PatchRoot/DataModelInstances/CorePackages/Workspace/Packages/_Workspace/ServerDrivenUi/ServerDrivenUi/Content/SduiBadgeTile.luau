local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Cryo = require(parent.Cryo)

local SduiTile = require(ServerDrivenUi.Content.SduiTile)

local function SduiBadgeTile(props)
	local v = useTokens()
	local imageCornerRadius = props.imageCornerRadius or 1000
	local imagePadding = props.imagePadding or v.Padding.Medium

	local isContained = props.isContained == nil or props.isContained

	local joined = Cryo.Dictionary.join(props, {
		testId = "--sdui-badge-tile",
		imagePadding = imagePadding,
		imageCornerRadius = imageCornerRadius,
		isContained = isContained
	})

	return React.createElement(SduiTile, joined)
end

return React.memo(SduiBadgeTile)
