local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local parent = script.Parent.Parent

local FFlagLuaMenuPerfImprovements = require(parent.Flags.FFlagLuaMenuPerfImprovements)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags2.GetFFlagLuaAppEnableOpenTypeSupport

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeIGMFix = SharedFlags3.GetFFlagLuaAppEnableOpenTypeIGMFix

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = Foundation.Image

local v3 = {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 24, 1, 1),
	Size = UDim2.new(0, 56, 0, 56)
}

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local validatePropsWithForwardRef = RoactUtils.validatePropsWithForwardRef

local extended = Roact.PureComponent:extend("PlayerLabelV2")

extended.validateProps = t.strictInterface(validatePropsWithForwardRef({
	userId = t.number,
	username = t.string,
	displayName = t.string,
	isOnline = t.boolean,
	isSelected = t.boolean,
	LayoutOrder = t.integer,
	Visible = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	[Roact.Children] = t.optional(t.table),
	[Roact.Change.AbsolutePosition] = t.optional(t.callback),
	[Roact.Ref] = t.optional(t.union(t.callback, t.table))
}))

extended.defaultProps = { Visible = true }

if FFlagLuaMenuPerfImprovements then
	function extended:init()
		function self.onActivated()
			self.props.onActivated(self.props.userId)
		end
	end
end

function extended:renderButtons()
	local v4 = self.props[Roact.Children] or {}
	return (Cryo.Dictionary.join(v4, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end

function extended:renderWithSelectionCursor(callback)
	local props = self.props
	local displayName = props.displayName ~= "" and props.displayName or props.username

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundContrast = {
					Color = p.Color.Surface.Surface_100.Color3,
					Transparency = p.Color.Surface.Surface_100.Transparency
				},
				BackgroundOnHover = {
					Color = p.Color.State.Hover.Color3,
					Transparency = p.Color.State.Hover.Transparency
				}
			}
		}
	end, function(p)
		local v4 = p.Theme.BackgroundContrast

		if self.props.isSelected then
			v4 = p.Theme.BackgroundOnHover
		end

		local onActivated = self.props.onActivated

		if FFlagLuaMenuPerfImprovements then
			onActivated = self.props.onActivated and self.onActivated or nil
		end

		local forwardRef = self.props.forwardRef

		local createElement = Roact.createElement
		local v5 = {
			BackgroundTransparency = v4.Transparency,
			BackgroundColor3 = v4.Color,
			BorderSizePixel = 0,
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 71),
			Visible = props.Visible,
			Text = "",
			AutoButtonColor = false,
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = self.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = forwardRef,
			SelectionImageObject = callback(v2.Square)
		}
		local playerIcon

		if FFlagCoreUiMigrateUIBloxToFoundation then
			playerIcon = Roact.createElement(Image, Cryo.Dictionary.join(v3, {
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or "",
				imageStyle = {
					Color3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
					Transparency = 0
				},
				ZIndex = 2
			}))
		else
			playerIcon = Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(v3, {
				ImageColor3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
				BackgroundTransparency = 1,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or "",
				ZIndex = 2
			}))
		end

		local children = {
			PlayerIcon = playerIcon,
			DisplayNameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				Position = UDim2.new(0, 104, 0, 14),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = displayName,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			UsernameLabel = 0,
			ButtonContainer = 0
		}

		local createElement2 = Roact.createElement
		local v6 = {
			fontKey = "Header2",
			themeKey = "TextDefault",
			Position = UDim2.new(0, 104, 0, 36),
			Size = UDim2.new(0, 219, 0, 22),
			Text = "@" .. props.username,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			OpenTypeFeatures = 0
		}
		local openTypeFeatures

		if GetFFlagLuaAppEnableOpenTypeSupport() and GetFFlagLuaAppEnableOpenTypeIGMFix() then
			openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
		end

		v6.OpenTypeFeatures = openTypeFeatures
		children.UsernameLabel = createElement2(ThemedTextLabel, v6)

		children.ButtonContainer = Roact.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			},
			self:renderButtons()
		)
		return createElement("TextButton", v5, children)
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
