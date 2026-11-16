local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent

local FFlagLuaMenuPerfImprovements = require(parent.Flags.FFlagLuaMenuPerfImprovements)

local Assets = require(parent.Resources.Assets)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
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

local v3 = {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 24, 0.5, 0),
	Size = UDim2.new(0, 44, 0, 44)
}

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local validatePropsWithForwardRef = RoactUtils.validatePropsWithForwardRef

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags2.GetFFlagLuaAppEnableOpenTypeSupport

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeIGMFix = SharedFlags3.GetFFlagLuaAppEnableOpenTypeIGMFix

local extended = Roact.PureComponent:extend("PlayerLabel")

extended.validateProps = t.strictInterface(validatePropsWithForwardRef({
	userId = t.number,
	username = t.string,
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

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundContrast = {
					Color = p.Color.Surface.Surface_100.Color3,
					Transparency = p.Color.Surface.Surface_100.Transparency
				},
				UIDefault = {
					Color = p.Color.Shift.Shift_200.Color3,
					Transparency = p.Color.Shift.Shift_200.Transparency
				},
				OnlineStatus = {
					Color = p.Color.System.Success.Color3,
					Transparency = p.Color.System.Success.Transparency
				}
			}
		}
	end, function(p)
		local backgroundContrast = p.Theme.BackgroundContrast
		local v4 = self.props.isSelected and {
				Color = Color3.fromRGB(48, 50, 52),
				Transparency = 0
			}
			or backgroundContrast

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
			Size = UDim2.new(1, 0, 0, 70),
			Visible = props.Visible,
			Text = "",
			AutoButtonColor = false,
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = self.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = forwardRef,
			SelectionImageObject = callback(v2.Square)
		}
		local playerCutout

		if FFlagCoreUiMigrateUIBloxToFoundation then
			playerCutout = Roact.createElement(Image, Cryo.Dictionary.join(v3, {
				Image = Assets.Images.CircleCutout,
				imageStyle = { Color3 = v4.Color, Transparency = 0 },
				ZIndex = 3
			}))
		else
			playerCutout = Roact.createElement(
				ImageSetLabel,
				Cryo.Dictionary.join(v3, {
					BackgroundTransparency = 1,
					Image = Assets.Images.CircleCutout,
					ImageColor3 = v4.Color,
					ZIndex = 3
				})
			)
		end

		local playerIcon

		if FFlagCoreUiMigrateUIBloxToFoundation then
			playerIcon = Roact.createElement(Image, Cryo.Dictionary.join(v3, {
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=48&h=48" or "",
				ZIndex = 2
			}))
		else
			playerIcon = Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(v3, {
				BackgroundTransparency = 1,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=48&h=48" or "",
				ZIndex = 2
			}))
		end

		local children = {
			PlayerCutout = playerCutout,
			PlayerIcon = playerIcon,
			PlayerBackground = Roact.createElement(
				"Frame",
				Cryo.Dictionary.join(v3, {
					BackgroundColor3 = p.Theme.UIDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				})
			),
			OnlineIndicator = 0,
			UsernameLabel = 0,
			ButtonContainer = 0
		}
		local onlineIndicator

		if FFlagCoreUiMigrateUIBloxToFoundation then
			onlineIndicator = Roact.createElement(Image, {
				AnchorPoint = Vector2.new(0, 0.5),
				Image = Assets.Images.Circle,
				imageStyle = {
					Color3 = props.isOnline and p.Theme.OnlineStatus.Color or p.Theme.UIDefault.Color,
					Transparency = 0
				},
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16)
			})
		else
			onlineIndicator = Roact.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = Assets.Images.Circle,
				ImageColor3 = props.isOnline and p.Theme.OnlineStatus.Color or p.Theme.UIDefault.Color,
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16)
			})
		end

		children.OnlineIndicator = onlineIndicator

		local createElement2 = Roact.createElement
		local v6 = {
			fontKey = "Header2",
			themeKey = "TextEmphasis",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 100, 0.5, 0),
			Size = UDim2.new(0, 219, 0, 22),
			Text = props.username,
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
