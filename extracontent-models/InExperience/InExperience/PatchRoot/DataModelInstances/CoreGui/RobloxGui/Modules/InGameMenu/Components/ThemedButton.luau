local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v13 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v14 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local v15 = Roact.PureComponent:extend("ThemedButton")

v15.validateProps = t.strictInterface({
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
v15.defaultProps = {
	enabled = true,
	imageProps = Assets.Images.RoundedRect
}

function v15.init(p1) -- line: 74
	p1:setState({
		hover = false,
		press = false
	})
end
function v15.renderWithSelectionCursor(p2, p3) -- line: 81
	-- upvalues: withFoundationOrUIBloxStyle (copy), divideTransparency (copy), Roact (copy), ImageSetButton (copy), v14 (copy)
	local props = p2.props
	local normalThemeKey = props.normalThemeKey

	if props.enabled and p2.state.hover then
		normalThemeKey = props.hoverThemeKey
	end

	return withFoundationOrUIBloxStyle(function(p4) -- line: 89
		return {
			Theme = {
				BackgroundDefault = {
					Color = p4.Color.Surface.Surface_0.Color3,
					Transparency = p4.Color.Surface.Surface_0.Transparency
				},
				BackgroundContrast = {
					Color = p4.Color.Surface.Surface_100.Color3,
					Transparency = p4.Color.Surface.Surface_100.Transparency
				},
				BackgroundMuted = {
					Color = p4.Color.Surface.Surface_200.Color3,
					Transparency = p4.Color.Surface.Surface_200.Transparency
				},
				BackgroundUIDefault = {
					Color = p4.Color.Surface.Surface_300.Color3,
					Transparency = p4.Color.Surface.Surface_300.Transparency
				},
				BackgroundUIContrast = {
					Color = p4.Color.OverMedia.OverMedia_0.Color3,
					Transparency = p4.Color.OverMedia.OverMedia_0.Transparency
				},
				BackgroundOnHover = {
					Color = p4.Color.State.Hover.Color3,
					Transparency = p4.Color.State.Hover.Transparency
				},
				BackgroundOnPress = {
					Color = p4.Color.State.Press.Color3,
					Transparency = p4.Color.State.Press.Transparency
				},
				UIDefault = {
					Color = p4.Color.Shift.Shift_200.Color3,
					Transparency = p4.Color.Shift.Shift_200.Transparency
				},
				UIMuted = {
					Color = p4.Color.Shift.Shift_100.Color3,
					Transparency = p4.Color.Shift.Shift_100.Transparency
				},
				UIEmphasis = {
					Color = p4.Color.Shift.Shift_400.Color3,
					Transparency = p4.Color.Shift.Shift_400.Transparency
				},
				ContextualPrimaryDefault = {
					Color = p4.Color.ActionEmphasis.Background.Color3,
					Transparency = p4.Color.ActionEmphasis.Background.Transparency
				},
				ContextualPrimaryContent = {
					Color = p4.Color.ActionEmphasis.Foreground.Color3,
					Transparency = p4.Color.ActionEmphasis.Foreground.Transparency
				},
				SystemPrimaryDefault = {
					Color = p4.Color.ActionSubEmphasis.Background.Color3,
					Transparency = p4.Color.ActionSubEmphasis.Background.Transparency
				},
				SystemPrimaryContent = {
					Color = p4.Color.ActionSubEmphasis.Foreground.Color3,
					Transparency = p4.Color.ActionSubEmphasis.Foreground.Transparency
				},
				IconDefault = {
					Color = p4.Color.Content.Default.Color3,
					Transparency = p4.Color.Content.Default.Transparency
				},
				IconEmphasis = {
					Color = p4.Color.Content.Emphasis.Color3,
					Transparency = p4.Color.Content.Emphasis.Transparency
				},
				IconOnHover = {
					Color = p4.Color.Content.Emphasis.Color3,
					Transparency = p4.Color.Content.Emphasis.Transparency
				},
				TextEmphasis = {
					Color = p4.Color.Content.Emphasis.Color3,
					Transparency = p4.Color.Content.Emphasis.Transparency
				},
				TextDefault = {
					Color = p4.Color.Content.Default.Color3,
					Transparency = p4.Color.Content.Default.Transparency
				},
				TextMuted = {
					Color = p4.Color.Content.Muted.Color3,
					Transparency = p4.Color.Content.Muted.Transparency
				},
				TextLink = {
					Color = p4.Color.Content.Link.Color3,
					Transparency = p4.Color.Content.Link.Transparency
				},
				Divider = {
					Color = p4.Color.Stroke.Emphasis.Color3,
					Transparency = p4.Color.Stroke.Emphasis.Transparency
				},
				Overlay = {
					Color = p4.Color.Common.Scrim.Color3,
					Transparency = p4.Color.Common.Scrim.Transparency
				},
				DropShadow = {
					Color = p4.Color.Common.Shadow.Color3,
					Transparency = p4.Color.Common.Shadow.Transparency
				},
				NavigationBar = {
					Color = p4.Color.Common.NavigationBar.Color3,
					Transparency = p4.Color.Common.NavigationBar.Transparency
				},
				PlaceHolder = {
					Color = p4.Color.Common.Shimmer.Color3,
					Transparency = p4.Color.Common.Shimmer.Transparency
				},
				OnlineStatus = {
					Color = p4.Color.System.Success.Color3,
					Transparency = p4.Color.System.Success.Transparency
				},
				OfflineStatus = {
					Color = p4.Color.System.Neutral.Color3,
					Transparency = p4.Color.System.Neutral.Transparency
				},
				Success = {
					Color = p4.Color.System.Success.Color3,
					Transparency = p4.Color.System.Success.Transparency
				},
				Alert = {
					Color = p4.Color.System.Alert.Color3,
					Transparency = p4.Color.System.Alert.Transparency
				},
				Badge = {
					Color = p4.Color.System.Contrast.Color3,
					Transparency = p4.Color.System.Contrast.Transparency
				},
				BadgeContent = {
					Color = p4.Inverse.Content.Emphasis.Color3,
					Transparency = p4.Inverse.Content.Emphasis.Transparency
				},
				SecondaryDefault = {
					Color = p4.Color.Extended.White.White_70.Color3,
					Transparency = p4.Color.Extended.White.White_70.Transparency
				},
				SecondaryOnHover = {
					Color = p4.Color.Extended.White.White_100.Color3,
					Transparency = p4.Color.Extended.White.White_100.Transparency
				}
			}
		}
	end, function(p5) -- line: 230
		-- upvalues: normalThemeKey (ref), divideTransparency (copy), p2 (copy), props (copy), Roact (copy), ImageSetButton (copy), p3 (copy), v14 (copy)
		local v24 = p5.Theme[normalThemeKey]

		assert(v24 ~= nil, "theme key " .. normalThemeKey .. " is nil")

		local v25 = divideTransparency(v24.Transparency, not p2.state.press and 1 or 2)

		if not props.enabled then
			v25 = 0.5
		end

		return Roact.createElement(ImageSetButton, {
			Visible = props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = v24.Color,
			Position = props.Position,
			Size = props.Size,
			AnchorPoint = props.AnchorPoint,
			ImageTransparency = v25,
			LayoutOrder = props.LayoutOrder,
			ScaleType = props.imageProps.ScaleType,
			SliceCenter = props.imageProps.SliceCenter,
			Image = props.imageProps.Image,
			SelectionImageObject = p3(v14.RoundedRectNoInset),
			[Roact.Event.Activated] = function() -- line: 250
				-- upvalues: props (copy)
				if props.enabled then
					props.onActivated()
				end
			end,
			[Roact.Event.MouseEnter] = function() -- line: 255
				-- upvalues: p2 (copy)
				p2:setState({
					hover = true
				})
			end,
			[Roact.Event.MouseLeave] = function() -- line: 260
				-- upvalues: p2 (copy)
				p2:setState({
					hover = false,
					press = false
				})
			end,
			[Roact.Event.InputBegan] = function(_, p7) -- line: 266
				-- upvalues: p2 (copy)
				if p7.UserInputType == Enum.UserInputType.MouseButton1 or p7.UserInputType == Enum.UserInputType.Touch then
					p2:setState({
						press = true
					})
				end
			end,
			[Roact.Event.InputEnded] = function(_, p9) -- line: 276
				-- upvalues: p2 (copy)
				if p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch then
					p2:setState({
						press = false
					})
				end
			end,
			[Roact.Ref] = p2.props.ButtonRef
		}, props.renderChildren(v25, props.enabled and p2.state.hover, props.enabled and p2.state.press))
	end)
end
function v15.render(p10) -- line: 291
	-- upvalues: v13 (copy)
	return v13(function(p11) -- line: 292
		-- upvalues: p10 (copy)
		return p10:renderWithSelectionCursor(p11)
	end)
end

return v15
