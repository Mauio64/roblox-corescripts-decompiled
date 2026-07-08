local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v13 = Roact.PureComponent:extend("ThemedButton")

v13.validateProps = t.strictInterface({
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
v13.defaultProps = {
	enabled = true,
	imageProps = Assets.Images.RoundedRect
}

function v13.init(p1) -- line: 67
	p1:setState({
		hover = false,
		press = false
	})
end
function v13.renderWithSelectionCursor(p2, p3) -- line: 74
	-- upvalues: withStyle (copy), divideTransparency (copy), Roact (copy), ImageSetButton (copy), CursorKind (copy)
	local props = p2.props
	local normalThemeKey = props.normalThemeKey

	if props.enabled and p2.state.hover then
		normalThemeKey = props.hoverThemeKey
	end

	return withStyle(function(p4) -- line: 82
		-- upvalues: normalThemeKey (ref), divideTransparency (copy), p2 (copy), props (copy), Roact (copy), ImageSetButton (copy), p3 (copy), CursorKind (copy)
		local v21 = p4.Theme[normalThemeKey]

		assert(v21 ~= nil, "theme key " .. normalThemeKey .. " is nil")

		local v22 = divideTransparency(v21.Transparency, not p2.state.press and 1 or 2)

		if not props.enabled then
			v22 = 0.5
		end

		return Roact.createElement(ImageSetButton, {
			Visible = props.Visible,
			BackgroundTransparency = 1,
			ImageColor3 = v21.Color,
			Position = props.Position,
			Size = props.Size,
			AnchorPoint = props.AnchorPoint,
			ImageTransparency = v22,
			LayoutOrder = props.LayoutOrder,
			ScaleType = props.imageProps.ScaleType,
			SliceCenter = props.imageProps.SliceCenter,
			Image = props.imageProps.Image,
			SelectionImageObject = p3(CursorKind.RoundedRectNoInset),
			[Roact.Event.Activated] = function() -- line: 102
				-- upvalues: props (copy)
				if props.enabled then
					props.onActivated()
				end
			end,
			[Roact.Event.MouseEnter] = function() -- line: 107
				-- upvalues: p2 (copy)
				p2:setState({
					hover = true
				})
			end,
			[Roact.Event.MouseLeave] = function() -- line: 112
				-- upvalues: p2 (copy)
				p2:setState({
					hover = false,
					press = false
				})
			end,
			[Roact.Event.InputBegan] = function(_, p6) -- line: 118
				-- upvalues: p2 (copy)
				if p6.UserInputType == Enum.UserInputType.MouseButton1 or p6.UserInputType == Enum.UserInputType.Touch then
					p2:setState({
						press = true
					})
				end
			end,
			[Roact.Event.InputEnded] = function(_, p8) -- line: 128
				-- upvalues: p2 (copy)
				if p8.UserInputType == Enum.UserInputType.MouseButton1 or p8.UserInputType == Enum.UserInputType.Touch then
					p2:setState({
						press = false
					})
				end
			end,
			[Roact.Ref] = p2.props.ButtonRef
		}, props.renderChildren(v22, props.enabled and p2.state.hover, props.enabled and p2.state.press))
	end)
end
function v13.render(p9) -- line: 143
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p10) -- line: 144
		-- upvalues: p9 (copy)
		return p9:renderWithSelectionCursor(p10)
	end)
end

return v13
