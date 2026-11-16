local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local RectangleButton = require(ShareGame.Components.RectangleButton)
local IconButton = require(ShareGame.Components.IconButton)
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(ShareGame.Constants)
local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)
local Theme = require(RobloxGui.Modules.Settings.Theme)

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("BackButton")
extended.IconType = { Arrow = "Arrow", Cross = "Cross", None = "None" }

extended.defaultProps = { iconType = extended.IconType.None }

local v = { [extended.IconType.Arrow] = "back", [extended.IconType.Cross] = "cross" }

local function fn(props)
	local iconType = props.iconType
	local visible = props.visible
	local anchorPoint = props.anchorPoint
	local position = props.position
	local size = props.size
	local zIndex = props.zIndex
	local onClick = props.onClick

	local v2 = v[iconType]

	if not v2 then
		return
	end

	local imagePath = ShareGameIcons:GetImagePath()
	local frame = ShareGameIcons:GetFrame(v2)

	return Roact.createElement(IconButton, {
		visible = visible,
		anchorPoint = anchorPoint,
		position = position,
		size = size,
		zIndex = zIndex,
		onClick = onClick,
		iconHorizontalAlignment = Enum.HorizontalAlignment.Left,
		iconSpritePath = imagePath,
		iconSpriteFrame = frame
	})
end

function extended.render(p)
	local iconType = p.props.iconType
	local zIndex = p.props.zIndex

	if iconType == extended.IconType.None then
		return Roact.createElement(RectangleButton, p.props, {
			TextLabel = Roact.createElement("TextLabel", {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Text = translator:FormatByKey("Feature.SettingsHub.Action.InviteFriendsBack"),
				TextSize = Theme.textSize(24, "BackButton"),
				TextColor3 = Constants.Color.WHITE,
				Font = Theme.font(Enum.Font.SourceSansSemibold, "BackButton"),
				ZIndex = zIndex
			})
		})
	end

	return fn(p.props)
end

return extended
