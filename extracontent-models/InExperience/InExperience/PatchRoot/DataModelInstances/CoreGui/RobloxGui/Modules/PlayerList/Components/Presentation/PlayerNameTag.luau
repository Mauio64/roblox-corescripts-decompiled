local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent.Parent
local Connection = ParentParent.Components.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local usePlayerCombinedName = require(ParentParent.Hooks.usePlayerCombinedName)
local createShallowEqualAndTables = require(ParentParent.createShallowEqualAndTables)
local FFlagPlayerListReduceRerenders = require(ParentParent.Flags.FFlagPlayerListReduceRerenders)
local useVerifiedBadge = require(CorePackages.Workspace.Packages.UserProfiles).Hooks.useVerifiedBadge
local FFlagEnableVerifiedBadgeStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableVerifiedBadgeStore
local playerInterface = require(RobloxGui.Modules.Interfaces.playerInterface)
local v17 = React.PureComponent:extend("PlayerNameTag")

v17.validateProps = t.strictInterface({
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
		Font = t.enum(Enum.Font)
	})
})

function v17.render(p1) -- line: 64
	-- upvalues: WithLayoutValues (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), React (copy), VerifiedBadges (copy)
	return WithLayoutValues(function(p2) -- line: 65
		-- upvalues: p1 (copy), FFlagEnableVerifiedBadgeStore (copy), UserLib (copy), React (copy), VerifiedBadges (copy)
		local IconUnSelectedColor = p2.IconUnSelectedColor

		if p1.props.isHovered then
			IconUnSelectedColor = p2.IconSelectedColor
		end

		local textFontFont = p1.props.textFont.Font
		local textFontSize = p1.props.textFont.Size
		local t1 = {}
		local PlatformName = p1.props.player.PlatformName
		local v29 = if not FFlagEnableVerifiedBadgeStore then UserLib.Utils.isPlayerVerified(p1.props.player) else p1.props.hasVerifiedBadge

		if p2.IsTenFoot and PlatformName ~= "" then
			t1.VerticalLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			})
			t1.PlayerPlatformName = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0.35, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSans,
				TextSize = textFontSize,
				TextColor3 = p1.props.textStyle.Color,
				TextTransparency = p1.props.textStyle.Transparency,
				TextStrokeColor3 = p1.props.textStyle.StrokeColor,
				TextStrokeTransparency = p1.props.textStyle.StrokeTransparency,
				Text = PlatformName
			})
			t1.RobloxNameFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0.45, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 6)
				}),
				RobloxIcon = React.createElement("ImageButton", {
					BackgroundTransparency = 1,
					Selectable = false,
					LayoutOrder = 1,
					Size = UDim2.new(0, 24, 0, 24),
					Image = p2.RobloxIconImage,
					ImageColor3 = IconUnSelectedColor
				}),
				PlayerNameContainer = React.createElement(VerifiedBadges.EmojiWrapper, {
					layoutOrder = 2,
					mockIsEnrolled = true,
					emoji = not v29 and "" or VerifiedBadges.emoji.verified,
					size = UDim2.new(1, -30, 0, 0),
					automaticSize = Enum.AutomaticSize.Y,
					verticalAlignment = Enum.VerticalAlignment.Center
				}, {
					PlayerName = React.createElement("TextLabel", {
						ClipsDescendants = false,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.fromScale(0, 1),
						Font = textFontFont,
						Text = p1.props.name,
						TextSize = textFontSize,
						TextColor3 = p1.props.textStyle.Color,
						TextTransparency = p1.props.textStyle.Transparency,
						TextStrokeColor3 = p1.props.textStyle.StrokeColor,
						TextStrokeTransparency = p1.props.textStyle.StrokeTransparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			})
		else
			t1.PlayerNameContainer = React.createElement(VerifiedBadges.EmojiWrapper, {
				mockIsEnrolled = true,
				emoji = not v29 and "" or VerifiedBadges.emoji.verified,
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.fromScale(0, 0.5),
				verticalAlignment = Enum.VerticalAlignment.Center,
				automaticSize = Enum.AutomaticSize.X,
				size = UDim2.new(0, 0, 0, textFontSize)
			}, {
				PlayerName = React.createElement("TextLabel", {
					TextScaled = false,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.fromScale(0, 1),
					Font = textFontFont,
					Text = p1.props.name,
					TextSize = textFontSize,
					TextColor3 = p1.props.textStyle.Color,
					TextTransparency = p1.props.textStyle.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextStrokeColor3 = p1.props.textStyle.StrokeColor,
					TextStrokeTransparency = p1.props.textStyle.StrokeTransparency,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			Size = p2.PlayerNameSize
		}, t1)
	end)
end

local function PlayerNameTagContainer(t2: {[any]: any}) -- line: 183
	-- upvalues: usePlayerCombinedName (copy), FFlagEnableVerifiedBadgeStore (copy), useVerifiedBadge (copy), React (copy), v17 (copy), Cryo (copy)
	local v21 = usePlayerCombinedName(tostring(t2.player.UserId), t2.player.DisplayName)
	local v22 = if not FFlagEnableVerifiedBadgeStore then nil else useVerifiedBadge(t2.player)

	return React.createElement(v17, Cryo.Dictionary.join(t2, {
		name = v21,
		hasVerifiedBadge = if not FFlagEnableVerifiedBadgeStore then nil else v22
	}))
end

if FFlagPlayerListReduceRerenders then
	return (React.memo(PlayerNameTagContainer, createShallowEqualAndTables({ "textFont" })))
end

return PlayerNameTagContainer
