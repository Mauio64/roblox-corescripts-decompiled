local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local FFlagLuaMenuPerfImprovements = require(ParentParent.Flags.FFlagLuaMenuPerfImprovements)
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v16 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v17 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local t1 = {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 24, 0.5, 0),
	Size = UDim2.new(0, 44, 0, 44)
}
local validatePropsWithForwardRef = require(CorePackages.Workspace.Packages.RoactUtils).validatePropsWithForwardRef
local GetFFlagLuaAppEnableOpenTypeSupport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local GetFFlagLuaAppEnableOpenTypeIGMFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeIGMFix
local v23 = Roact.PureComponent:extend("PlayerLabel")

v23.validateProps = t.strictInterface(validatePropsWithForwardRef({
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
v23.defaultProps = {
	Visible = true
}

if FFlagLuaMenuPerfImprovements then
	function v23.init(p1) -- line: 82
		function p1.onActivated() -- line: 83
			-- upvalues: p1 (copy)
			p1.props.onActivated(p1.props.userId)
		end
	end
end

function v23.renderButtons(p2) -- line: 89
	-- upvalues: Roact (copy), Cryo (copy)
	local v26 = p2.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v26, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end
function v23.renderWithSelectionCursor(p3, p4) -- line: 104
	-- upvalues: withFoundationOrUIBloxStyle (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), v17 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Cryo (copy), t1 (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
	local props = p3.props

	return withFoundationOrUIBloxStyle(function(p5) -- line: 107
		return {
			Theme = {
				BackgroundContrast = {
					Color = p5.Color.Surface.Surface_100.Color3,
					Transparency = p5.Color.Surface.Surface_100.Transparency
				},
				UIDefault = {
					Color = p5.Color.Shift.Shift_200.Color3,
					Transparency = p5.Color.Shift.Shift_200.Transparency
				},
				OnlineStatus = {
					Color = p5.Color.System.Success.Color3,
					Transparency = p5.Color.System.Success.Transparency
				}
			}
		}
	end, function(p6) -- line: 115
		-- upvalues: p3 (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), props (copy), p4 (copy), v17 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Cryo (copy), t1 (copy), Assets (copy), ImageSetLabel (copy), ThemedTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
		local BackgroundContrast = p6.Theme.BackgroundContrast

		if p3.props.isSelected then
			BackgroundContrast = {
				Transparency = 0,
				Color = Color3.fromRGB(48, 50, 52)
			}
		end

		local onActivated = p3.props.onActivated

		if FFlagLuaMenuPerfImprovements then
			onActivated = p3.props.onActivated and p3.onActivated or nil
		end

		local forwardRef = p3.props.forwardRef

		return Roact.createElement("TextButton", {
			BackgroundTransparency = BackgroundContrast.Transparency,
			BackgroundColor3 = BackgroundContrast.Color,
			BorderSizePixel = 0,
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 70),
			Visible = props.Visible,
			Text = "",
			AutoButtonColor = false,
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = p3.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = forwardRef,
			SelectionImageObject = p4(v17.Square)
		}, {
			PlayerCutout = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t1, {
				BackgroundTransparency = 1,
				ZIndex = 3,
				Image = Assets.Images.CircleCutout,
				ImageColor3 = BackgroundContrast.Color
			})) else Roact.createElement(FoundationImage, Cryo.Dictionary.join(t1, {
				ZIndex = 3,
				Image = Assets.Images.CircleCutout,
				imageStyle = {
					Transparency = 0,
					Color3 = BackgroundContrast.Color
				}
			})),
			PlayerIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t1, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=48&h=48" or ""
			})) else Roact.createElement(FoundationImage, Cryo.Dictionary.join(t1, {
				ZIndex = 2,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=48&h=48" or ""
			})),
			PlayerBackground = Roact.createElement("Frame", Cryo.Dictionary.join(t1, {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				BackgroundColor3 = p6.Theme.UIDefault.Color
			})),
			OnlineIndicator = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Image = Assets.Images.Circle,
				ImageColor3 = props.isOnline and p6.Theme.OnlineStatus.Color or p6.Theme.UIDefault.Color,
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16)
			}) else Roact.createElement(FoundationImage, {
				AnchorPoint = Vector2.new(0, 0.5),
				Image = Assets.Images.Circle,
				imageStyle = {
					Transparency = 0,
					Color3 = props.isOnline and p6.Theme.OnlineStatus.Color or p6.Theme.UIDefault.Color
				},
				Position = UDim2.new(0, 80, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16)
			}),
			UsernameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 100, 0.5, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = props.username,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				OpenTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() or not GetFFlagLuaAppEnableOpenTypeIGMFix() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
			}),
			ButtonContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 0, 1, 0)
			}, p3:renderButtons())
		})
	end)
end
function v23.render(p7) -- line: 234
	-- upvalues: v16 (copy)
	return v16(function(p8) -- line: 235
		-- upvalues: p7 (copy)
		return p7:renderWithSelectionCursor(p8)
	end)
end

return Roact.forwardRef(function(p9, p10) -- line: 240
	-- upvalues: Roact (copy), v23 (copy), Cryo (copy)
	return Roact.createElement(v23, Cryo.Dictionary.join(p9, {
		forwardRef = p10
	}))
end)
