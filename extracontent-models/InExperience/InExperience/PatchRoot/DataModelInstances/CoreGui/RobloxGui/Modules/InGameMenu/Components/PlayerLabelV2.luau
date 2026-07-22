local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v11 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local ParentParent = script.Parent.Parent
local FFlagLuaMenuPerfImprovements = require(ParentParent.Flags.FFlagLuaMenuPerfImprovements)
local GetFFlagLuaAppEnableOpenTypeSupport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local GetFFlagLuaAppEnableOpenTypeIGMFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeIGMFix
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local t1 = {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 24, 1, 1),
	Size = UDim2.new(0, 56, 0, 56)
}
local validatePropsWithForwardRef = require(CorePackages.Workspace.Packages.RoactUtils).validatePropsWithForwardRef
local v22 = Roact.PureComponent:extend("PlayerLabelV2")

v22.validateProps = t.strictInterface(validatePropsWithForwardRef({
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
v22.defaultProps = {
	Visible = true
}

if FFlagLuaMenuPerfImprovements then
	function v22.init(p1) -- line: 78
		function p1.onActivated() -- line: 79
			-- upvalues: p1 (copy)
			p1.props.onActivated(p1.props.userId)
		end
	end
end

function v22.renderButtons(p2) -- line: 85
	-- upvalues: Roact (copy), Cryo (copy)
	local v25 = p2.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v25, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end
function v22.renderWithSelectionCursor(p3, p4) -- line: 100
	-- upvalues: withFoundationOrUIBloxStyle (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), v11 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Cryo (copy), t1 (copy), ImageSetLabel (copy), ThemedTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
	local props = p3.props
	local v29 = props.displayName ~= "" and props.displayName or props.username

	return withFoundationOrUIBloxStyle(function(p5) -- line: 110
		return {
			Theme = {
				BackgroundContrast = {
					Color = p5.Color.Surface.Surface_100.Color3,
					Transparency = p5.Color.Surface.Surface_100.Transparency
				},
				BackgroundOnHover = {
					Color = p5.Color.State.Hover.Color3,
					Transparency = p5.Color.State.Hover.Transparency
				}
			}
		}
	end, function(p6) -- line: 117
		-- upvalues: p3 (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), props (copy), p4 (copy), v11 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), Cryo (copy), t1 (copy), ImageSetLabel (copy), ThemedTextLabel (copy), v29 (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
		local BackgroundContrast = p6.Theme.BackgroundContrast

		if p3.props.isSelected then
			BackgroundContrast = p6.Theme.BackgroundOnHover
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
			Size = UDim2.new(1, 0, 0, 71),
			Visible = props.Visible,
			Text = "",
			AutoButtonColor = false,
			[Roact.Event.Activated] = onActivated,
			[Roact.Change.AbsolutePosition] = p3.props[Roact.Change.AbsolutePosition],
			[Roact.Ref] = forwardRef,
			SelectionImageObject = p4(v11.Square)
		}, {
			PlayerIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t1, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				ImageColor3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or ""
			})) else Roact.createElement(FoundationImage, Cryo.Dictionary.join(t1, {
				ZIndex = 2,
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or "",
				imageStyle = {
					Transparency = 0,
					Color3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115)
				}
			})),
			DisplayNameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				Position = UDim2.new(0, 104, 0, 14),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = v29,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			UsernameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextDefault",
				Position = UDim2.new(0, 104, 0, 36),
				Size = UDim2.new(0, 219, 0, 22),
				Text = "@" .. props.username,
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
function v22.render(p7) -- line: 205
	-- upvalues: v10 (copy)
	return v10(function(p8) -- line: 206
		-- upvalues: p7 (copy)
		return p7:renderWithSelectionCursor(p8)
	end)
end

return Roact.forwardRef(function(p9, p10) -- line: 211
	-- upvalues: Roact (copy), v22 (copy), Cryo (copy)
	return Roact.createElement(v22, Cryo.Dictionary.join(p9, {
		forwardRef = p10
	}))
end)
