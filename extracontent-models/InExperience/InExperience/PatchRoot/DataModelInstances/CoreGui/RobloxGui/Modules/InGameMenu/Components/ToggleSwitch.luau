local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Otter = InGameMenuDependencies.Otter
local t = InGameMenuDependencies.t
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local AssetImage = require(script.Parent.AssetImage)
local uDim2 = UDim2.new(0, -3, 0.5, 0)
local uDim2_2 = UDim2.new(1, -39, 0.5, 0)
local t1 = {
	frequency = 4
}
local v16 = Roact.PureComponent:extend("ToggleSwitch")

v16.validateProps = t.strictInterface({
	checked = t.boolean,
	onToggled = t.callback,
	disabled = t.optional(t.boolean),
	buttonRef = t.optional(t.union(t.callback, t.table)),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	NextSelectionUp = t.optional(t.union(t.Instance, t.table)),
	onSelectionLost = t.optional(t.callback),
	onSelectionGained = t.optional(t.callback)
})

function v16.init(p1) -- line: 42
	-- upvalues: Roact (copy), divideTransparency (copy), uDim2 (copy), uDim2_2 (copy), Otter (copy)
	local v18 = not p1.props.checked and 0 or 1
	local v19, v20 = Roact.createBinding(v18)

	p1.progress = v19
	p1.setProgress = v20
	p1.fillTransparency = p1.progress:map(function(p2) -- line: 46
		-- upvalues: divideTransparency (copy), p1 (copy)
		return divideTransparency(1 - p2, not p1.props.disabled and 1 or 4)
	end)
	p1.knobPosition = p1.progress:map(function(p3) -- line: 50
		-- upvalues: uDim2 (copy), uDim2_2 (copy)
		return uDim2:lerp(uDim2_2, p3)
	end)
	p1.motor = Otter.createSingleMotor(v18)
	p1.motor:onStep(p1.setProgress)
end
function v16.renderWithSelectionCursor(p4, p5) -- line: 58
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), AssetImage (copy), divideTransparency (copy), CursorKind (copy)
	return withFoundationOrUIBloxStyle(function(p6) -- line: 59
		return {
			Theme = {
				SecondaryDefault = {
					Color = p6.Color.Extended.White.White_70.Color3,
					Transparency = p6.Color.Extended.White.White_70.Transparency
				},
				Success = {
					Color = p6.Color.System.Success.Color3,
					Transparency = p6.Color.System.Success.Transparency
				}
			}
		}
	end, function(p7) -- line: 66
		-- upvalues: Roact (copy), AssetImage (copy), p4 (copy), divideTransparency (copy), p5 (copy), CursorKind (copy)
		return Roact.createElement(AssetImage.Button, {
			Size = UDim2.new(0, 60, 0, 36),
			BackgroundTransparency = 1,
			Position = p4.props.Position,
			LayoutOrder = p4.props.LayoutOrder,
			imageKey = "ToggleOutline",
			AnchorPoint = p4.props.AnchorPoint,
			ImageColor3 = p7.Theme.SecondaryDefault.Color,
			ImageTransparency = divideTransparency(p7.Theme.SecondaryDefault.Transparency, not p4.props.disabled and 1 or 4),
			NextSelectionUp = p4.props.NextSelectionUp,
			[Roact.Event.Activated] = p4.props.onToggled,
			[Roact.Ref] = p4.props.buttonRef,
			[Roact.Event.SelectionLost] = p4.props.onSelectionLost,
			[Roact.Event.SelectionGained] = p4.props.onSelectionGained,
			SelectionImageObject = p5(CursorKind.Toggle)
		}, {
			Fill = Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				imageKey = "ToggleFill",
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p7.Theme.Success.Color,
				ImageTransparency = p4.fillTransparency
			}),
			Knob = Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				imageKey = "ToggleKnob",
				ZIndex = 2,
				Size = UDim2.new(0, 42, 0, 42),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = p4.knobPosition,
				ImageTransparency = divideTransparency(0, not p4.props.disabled and 1 or 4)
			})
		})
	end)
end
function v16.render(p8) -- line: 106
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p9) -- line: 107
		-- upvalues: p8 (copy)
		return p8:renderWithSelectionCursor(p9)
	end)
end
function v16.didUpdate(p10) -- line: 112
	-- upvalues: Otter (copy), t1 (copy)
	local v25 = not p10.props.checked and 0 or 1

	p10.motor:setGoal(Otter.spring(v25, t1))
end
function v16.willUnmount(p11) -- line: 117
	p11.motor:destroy()
end

return v16
