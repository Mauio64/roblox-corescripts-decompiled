local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local RectangleButton = require(ShareGame.Components.RectangleButton)
local IconButton = require(ShareGame.Components.IconButton)
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(ShareGame.Constants)
local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v10 = require(ShareGame.getTranslator)()
local v11 = Roact.PureComponent:extend("BackButton")

v11.IconType = {
	Arrow = "Arrow",
	Cross = "Cross",
	None = "None"
}
v11.defaultProps = {
	iconType = v11.IconType.None
}

local t1 = {
	[v11.IconType.Arrow] = "back",
	[v11.IconType.Cross] = "cross"
}

local function v13(p1) -- line: 36
	-- upvalues: t1 (copy), ShareGameIcons (copy), Roact (copy), IconButton (copy)
	local iconType = p1.iconType
	local visible = p1.visible
	local anchorPoint = p1.anchorPoint
	local position = p1.position
	local size = p1.size
	local zIndex = p1.zIndex
	local onClick = p1.onClick
	local v22 = t1[iconType]

	if v22 then
		local ImagePath = ShareGameIcons:GetImagePath()
		local Frame = ShareGameIcons:GetFrame(v22)

		return Roact.createElement(IconButton, {
			visible = visible,
			anchorPoint = anchorPoint,
			position = position,
			size = size,
			zIndex = zIndex,
			onClick = onClick,
			iconHorizontalAlignment = Enum.HorizontalAlignment.Left,
			iconSpritePath = ImagePath,
			iconSpriteFrame = Frame
		})
	end
end

function v11.render(p2) -- line: 65
	-- upvalues: v11 (copy), Roact (copy), RectangleButton (copy), v10 (copy), Theme (copy), Constants (copy), v13 (copy)
	local iconType = p2.props.iconType
	local zIndex = p2.props.zIndex

	if iconType == v11.IconType.None then
		return Roact.createElement(RectangleButton, p2.props, {
			TextLabel = Roact.createElement("TextLabel", {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Text = v10:FormatByKey("Feature.SettingsHub.Action.InviteFriendsBack"),
				TextSize = Theme.textSize(24, "BackButton"),
				TextColor3 = Constants.Color.WHITE,
				Font = Theme.font(Enum.Font.SourceSansSemibold, "BackButton"),
				ZIndex = zIndex
			})
		})
	end

	return v13(p2.props)
end

return v11
