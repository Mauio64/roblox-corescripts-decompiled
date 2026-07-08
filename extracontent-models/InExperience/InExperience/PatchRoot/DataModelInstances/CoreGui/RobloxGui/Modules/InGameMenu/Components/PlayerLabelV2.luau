local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local ParentParent = script.Parent.Parent
local FFlagLuaMenuPerfImprovements = require(ParentParent.Flags.FFlagLuaMenuPerfImprovements)
local GetFFlagLuaAppEnableOpenTypeSupport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local GetFFlagLuaAppEnableOpenTypeIGMFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeIGMFix
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 24, 1, 1),
	Size = UDim2.new(0, 56, 0, 56)
}
local validatePropsWithForwardRef = require(CorePackages.Workspace.Packages.RoactUtils).validatePropsWithForwardRef
local v19 = Roact.PureComponent:extend("PlayerLabelV2")

v19.validateProps = t.strictInterface(validatePropsWithForwardRef({
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
v19.defaultProps = {
	Visible = true
}

if FFlagLuaMenuPerfImprovements then
	function v19.init(p1) -- line: 69
		function p1.onActivated() -- line: 70
			-- upvalues: p1 (copy)
			p1.props.onActivated(p1.props.userId)
		end
	end
end

function v19.renderButtons(p2) -- line: 76
	-- upvalues: Roact (copy), Cryo (copy)
	local v22 = p2.props[Roact.Children] or {}

	return (Cryo.Dictionary.join(v22, {
		List = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 12)
		})
	}))
end
function v19.renderWithSelectionCursor(p3, p4) -- line: 91
	-- upvalues: withStyle (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), CursorKind (copy), ImageSetLabel (copy), Cryo (copy), t1 (copy), ThemedTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
	local props = p3.props
	local v26 = props.displayName ~= "" and props.displayName or props.username

	return withStyle(function(p5) -- line: 101
		-- upvalues: p3 (copy), FFlagLuaMenuPerfImprovements (copy), Roact (copy), props (copy), p4 (copy), CursorKind (copy), ImageSetLabel (copy), Cryo (copy), t1 (copy), ThemedTextLabel (copy), v26 (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), GetFFlagLuaAppEnableOpenTypeIGMFix (copy), OpenTypeSupport (copy)
		local BackgroundContrast = p5.Theme.BackgroundContrast

		if p3.props.isSelected then
			BackgroundContrast = p5.Theme.BackgroundOnHover
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
			SelectionImageObject = p4(CursorKind.Square)
		}, {
			PlayerIcon = Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t1, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				ImageColor3 = props.isOnline and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(115, 115, 115),
				Image = props.userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=60&h=60" or ""
			})),
			DisplayNameLabel = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				Position = UDim2.new(0, 104, 0, 14),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 219, 0, 22),
				Text = v26,
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
function v19.render(p6) -- line: 182
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p7) -- line: 183
		-- upvalues: p6 (copy)
		return p6:renderWithSelectionCursor(p7)
	end)
end

return Roact.forwardRef(function(p8, p9) -- line: 188
	-- upvalues: Roact (copy), v19 (copy), Cryo (copy)
	return Roact.createElement(v19, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
