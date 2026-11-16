local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local Assets = require(parent.Resources.Assets)
local divideTransparency = require(parent.Utility.divideTransparency)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
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

local extended = Roact.PureComponent:extend("ThemedButton")

extended.validateProps = t.strictInterface({
	normalThemeKey = t.string,
	hoverThemeKey = t.string,
	imageProps = t.strictInterface({
		Image = t.union(t.string, t.table),
		ScaleType = t.enum(Enum.ScaleType),
		SliceCenter = t.Rect
	}),
	enabled = t.optional(t.boolean),
	renderChildren = t.callback,
	onActivated = t.callback,
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	Visible = t.optional(t.boolean),
	ButtonRef = t.optional(t.union(t.callback, t.table))
})

extended.defaultProps = { imageProps = Assets.Images.RoundedRect, enabled = true }

function extended.init(object)
	object:setState({ hover = false, press = false })
end

function extended:renderWithSelectionCursor(callback)
	local props = self.props
	local v3 = props.normalThemeKey

	if props.enabled and self.state.hover then
		v3 = props.hoverThemeKey
	end

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundDefault = {
					Color = p.Color.Surface.Surface_0.Color3,
					Transparency = p.Color.Surface.Surface_0.Transparency
				},
				BackgroundContrast = {
					Color = p.Color.Surface.Surface_100.Color3,
					Transparency = p.Color.Surface.Surface_100.Transparency
				},
				BackgroundMuted = {
					Color = p.Color.Surface.Surface_200.Color3,
					Transparency = p.Color.Surface.Surface_200.Transparency
				},
				BackgroundUIDefault = {
					Color = p.Color.Surface.Surface_300.Color3,
					Transparency = p.Color.Surface.Surface_300.Transparency
				},
				BackgroundUIContrast = {
					Color = p.Color.OverMedia.OverMedia_0.Color3,
					Transparency = p.Color.OverMedia.OverMedia_0.Transparency
				},
				BackgroundOnHover = {
					Color = p.Color.State.Hover.Color3,
					Transparency = p.Color.State.Hover.Transparency
				},
				BackgroundOnPress = {
					Color = p.Color.State.Press.Color3,
					Transparency = p.Color.State.Press.Transparency
				},
				UIDefault = {
					Color = p.Color.Shift.Shift_200.Color3,
					Transparency = p.Color.Shift.Shift_200.Transparency
				},
				UIMuted = {
					Color = p.Color.Shift.Shift_100.Color3,
					Transparency = p.Color.Shift.Shift_100.Transparency
				},
				UIEmphasis = {
					Color = p.Color.Shift.Shift_400.Color3,
					Transparency = p.Color.Shift.Shift_400.Transparency
				},
				ContextualPrimaryDefault = {
					Color = p.Color.ActionEmphasis.Background.Color3,
					Transparency = p.Color.ActionEmphasis.Background.Transparency
				},
				ContextualPrimaryContent = {
					Color = p.Color.ActionEmphasis.Foreground.Color3,
					Transparency = p.Color.ActionEmphasis.Foreground.Transparency
				},
				SystemPrimaryDefault = {
					Color = p.Color.ActionSubEmphasis.Background.Color3,
					Transparency = p.Color.ActionSubEmphasis.Background.Transparency
				},
				SystemPrimaryContent = {
					Color = p.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = p.Color.ActionSubEmphasis.Foreground.Transparency
				},
				IconDefault = {
					Color = p.Color.Content.Default.Color3,
					Transparency = p.Color.Content.Default.Transparency
				},
				IconEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				},
				IconOnHover = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				},
				TextEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				},
				TextDefault = {
					Color = p.Color.Content.Default.Color3,
					Transparency = p.Color.Content.Default.Transparency
				},
				TextMuted = {
					Color = p.Color.Content.Muted.Color3,
					Transparency = p.Color.Content.Muted.Transparency
				},
				TextLink = {
					Color = p.Color.Content.Link.Color3,
					Transparency = p.Color.Content.Link.Transparency
				},
				Divider = {
					Color = p.Color.Stroke.Emphasis.Color3,
					Transparency = p.Color.Stroke.Emphasis.Transparency
				},
				Overlay = {
					Color = p.Color.Common.Scrim.Color3,
					Transparency = p.Color.Common.Scrim.Transparency
				},
				DropShadow = {
					Color = p.Color.Common.Shadow.Color3,
					Transparency = p.Color.Common.Shadow.Transparency
				},
				NavigationBar = {
					Color = p.Color.Common.NavigationBar.Color3,
					Transparency = p.Color.Common.NavigationBar.Transparency
				},
				PlaceHolder = {
					Color = p.Color.Common.Shimmer.Color3,
					Transparency = p.Color.Common.Shimmer.Transparency
				},
				OnlineStatus = {
					Color = p.Color.System.Success.Color3,
					Transparency = p.Color.System.Success.Transparency
				},
				OfflineStatus = {
					Color = p.Color.System.Neutral.Color3,
					Transparency = p.Color.System.Neutral.Transparency
				},
				Success = {
					Color = p.Color.System.Success.Color3,
					Transparency = p.Color.System.Success.Transparency
				},
				Alert = {
					Color = p.Color.System.Alert.Color3,
					Transparency = p.Color.System.Alert.Transparency
				},
				Badge = {
					Color = p.Color.System.Contrast.Color3,
					Transparency = p.Color.System.Contrast.Transparency
				},
				BadgeContent = {
					Color = p.Inverse.Content.Emphasis.Color3,
					Transparency = p.Inverse.Content.Emphasis.Transparency
				},
				SecondaryDefault = {
					Color = p.Color.Extended.White.White_70.Color3,
					Transparency = p.Color.Extended.White.White_70.Transparency
				},
				SecondaryOnHover = {
					Color = p.Color.Extended.White.White_100.Color3,
					Transparency = p.Color.Extended.White.White_100.Transparency
				}
			}
		}
	end, function(p)
		local v4 = p.Theme[v3]
		assert(v4 ~= nil, "theme key " .. v3 .. " is nil")
		local v5 = divideTransparency(v4.Transparency, self.state.press and 2 or 1)
		local imageTransparency = not props.enabled and 0.5 or v5

		return Roact.createElement(ImageSetButton, {
			Visible = props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = v4.Color,
			Position = props.Position,
			Size = props.Size,
			AnchorPoint = props.AnchorPoint,
			ImageTransparency = imageTransparency,
			LayoutOrder = props.LayoutOrder,
			ScaleType = props.imageProps.ScaleType,
			SliceCenter = props.imageProps.SliceCenter,
			Image = props.imageProps.Image,
			SelectionImageObject = callback(v2.RoundedRectNoInset),
			[Roact.Event.Activated] = function()
				if props.enabled then
					props.onActivated()
				end
			end,
			[Roact.Event.MouseEnter] = function()
				self:setState({ hover = true })
			end,
			[Roact.Event.MouseLeave] = function()
				self:setState({ hover = false, press = false })
			end,
			[Roact.Event.InputBegan] = function(_, p2)
				if
					p2.UserInputType == Enum.UserInputType.MouseButton1
					or p2.UserInputType == Enum.UserInputType.Touch
				then
					self:setState({ press = true })
				end
			end,
			[Roact.Event.InputEnded] = function(_, p2)
				if
					p2.UserInputType == Enum.UserInputType.MouseButton1
					or p2.UserInputType == Enum.UserInputType.Touch
				then
					self:setState({ press = false })
				end
			end,
			[Roact.Ref] = self.props.ButtonRef
		}, props.renderChildren(
			imageTransparency,
			props.enabled and self.state.hover,
			props.enabled and self.state.press
		))
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
