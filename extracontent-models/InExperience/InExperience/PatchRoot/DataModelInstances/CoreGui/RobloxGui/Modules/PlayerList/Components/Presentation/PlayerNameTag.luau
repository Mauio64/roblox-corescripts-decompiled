local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent.Parent
local connection = parent.Components.Connection
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues
local usePlayerCombinedName = require(parent.Hooks.usePlayerCombinedName)
local createShallowEqualAndTables = require(parent.createShallowEqualAndTables)
local FFlagPlayerListReduceRerenders = require(parent.Flags.FFlagPlayerListReduceRerenders)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local useVerifiedBadge = UserProfiles.Hooks.useVerifiedBadge
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore

local playerInterface = require(RobloxGui.Modules.Interfaces.playerInterface)

local extended = React.PureComponent:extend("PlayerNameTag")

extended.validateProps = t.strictInterface({
	player = playerInterface,
	isTitleEntry = t.boolean,
	isHovered = t.boolean,
	layoutOrder = t.integer,
	name = t.union(t.string, t.table),
	hasVerifiedBadge = t.optional(t.boolean),
	textStyle = t.strictInterface({
		Color = t.Color3,
		Transparency = t.number,
		StrokeColor = t.optional(t.Color3),
		StrokeTransparency = t.optional(t.number)
	}),
	textFont = t.strictInterface({
		Size = t.number,
		MinSize = t.number,
		Font = t.enum(Enum.Font),
		FontFace = t.optional(t.typeof("Font"))
	})
})

function extended.render(p)
	return WithLayoutValues(function(props)
		local imageColor = props.IconUnSelectedColor

		if p.props.isHovered then
			imageColor = props.IconSelectedColor
		end

		local fontFace = p.props.textFont.FontFace
		local size = p.props.textFont.Size

		local children = {}
		local platformName = p.props.player.PlatformName
		local v

		if FFlagEnableVerifiedBadgeStore then
			v = p.props.hasVerifiedBadge
		else
			v = UserLib.Utils.isPlayerVerified(p.props.player)
		end

		if props.IsTenFoot and platformName ~= "" then
			children.VerticalLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			})

			children.PlayerPlatformName = React.createElement("TextLabel", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0.35, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSans,
				TextSize = size,
				TextColor3 = p.props.textStyle.Color,
				TextTransparency = p.props.textStyle.Transparency,
				TextStrokeColor3 = p.props.textStyle.StrokeColor,
				TextStrokeTransparency = p.props.textStyle.StrokeTransparency,
				BackgroundTransparency = 1,
				Text = platformName,
				LayoutOrder = 2
			})

			children.RobloxNameFrame = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 0.45, 0), BackgroundTransparency = 1, LayoutOrder = 2 },
				{
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 6)
					}),
					RobloxIcon = React.createElement("ImageButton", {
						Size = UDim2.new(0, 24, 0, 24),
						Image = props.RobloxIconImage,
						BackgroundTransparency = 1,
						Selectable = false,
						ImageColor3 = imageColor,
						LayoutOrder = 1
					}),
					PlayerNameContainer = React.createElement(VerifiedBadges.EmojiWrapper, {
						emoji = not v and "" or VerifiedBadges.emoji.verified,
						layoutOrder = 2,
						mockIsEnrolled = true,
						size = UDim2.new(1, -30, 0, 0),
						automaticSize = Enum.AutomaticSize.Y,
						verticalAlignment = Enum.VerticalAlignment.Center
					}, {
						PlayerName = React.createElement("TextLabel", {
							AutomaticSize = Enum.AutomaticSize.X,
							ClipsDescendants = false,
							Size = UDim2.fromScale(0, 1),
							FontFace = fontFace,
							Text = p.props.name,
							TextSize = size,
							TextColor3 = p.props.textStyle.Color,
							TextTransparency = p.props.textStyle.Transparency,
							TextStrokeColor3 = p.props.textStyle.StrokeColor,
							TextStrokeTransparency = p.props.textStyle.StrokeTransparency,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundTransparency = 1
						})
					})
				}
			)
		else
			children.PlayerNameContainer = React.createElement(VerifiedBadges.EmojiWrapper, {
				emoji = not v and "" or VerifiedBadges.emoji.verified,
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				mockIsEnrolled = true,
				verticalAlignment = Enum.VerticalAlignment.Center,
				automaticSize = Enum.AutomaticSize.X,
				size = UDim2.new(0, 0, 0, size)
			}, {
				PlayerName = React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromScale(0, 1),
					FontFace = fontFace,
					Text = p.props.name,
					TextSize = size,
					TextColor3 = p.props.textStyle.Color,
					TextTransparency = p.props.textStyle.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextScaled = false,
					TextStrokeColor3 = p.props.textStyle.StrokeColor,
					TextStrokeTransparency = p.props.textStyle.StrokeTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				})
			})
		end

		return React.createElement(
			"Frame",
			{
				LayoutOrder = p.props.layoutOrder,
				Size = props.PlayerNameSize,
				BackgroundTransparency = 1
			},
			children
		)
	end)
end

local function PlayerNameTagContainer(p)
	local name = usePlayerCombinedName(tostring(p.player.UserId), p.player.DisplayName)
	local hasVerifiedBadge

	if FFlagEnableVerifiedBadgeStore then
		hasVerifiedBadge = useVerifiedBadge(p.player)
	end

	local createElement = React.createElement
	local join = Cryo.Dictionary.join

	if not FFlagEnableVerifiedBadgeStore then
		hasVerifiedBadge = nil
	end

	return createElement(extended, join(p, { name = name, hasVerifiedBadge = hasVerifiedBadge }))
end

if FFlagPlayerListReduceRerenders then
	return (React.memo(PlayerNameTagContainer, createShallowEqualAndTables({ "textFont" })))
end

return PlayerNameTagContainer
