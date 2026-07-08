local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local LayerCollectorContext = require(script.Parent.LayerCollectorContext)
local GuiService = game:GetService("GuiService")
local v5 = Roact.PureComponent:extend("LayerCollectorProvider")

function v5.init(p1) -- line: 11
	-- upvalues: Roact (copy)
	p1.rootRef = Roact.createRef()
	p1.state = {
		absoluteSize = Vector2.new(0, 0),
		insets = {
			top = 0,
			left = 0,
			bottom = 0,
			right = 0
		}
	}
end
function v5.watchLayerCollector(t1: {[any]: any}, p2) -- line: 24
	-- upvalues: GuiService (copy)
	local AbsoluteSize = p2.AbsoluteSize
	local vector2 = Vector2.new(0, 0)
	local vector2_2 = Vector2.new(0, 0)

	if p2:IsA("ScreenGui") then
		local ok, result = pcall(function() -- line: 30
			-- upvalues: p2 (copy)
			return p2.IgnoreGuiInset
		end)

		if ok and result then
			local v14, v15 = GuiService:GetGuiInset()

			vector2 = v14
			vector2_2 = v15
		end
	end

	t1:setState({
		absoluteSize = AbsoluteSize,
		insets = {
			top = vector2.Y,
			left = vector2.X,
			bottom = vector2_2.Y,
			right = vector2_2.X
		}
	})
	t1.absoluteSizeConnection = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 48
		-- upvalues: AbsoluteSize (ref), p2 (copy), t1 (copy), vector2 (ref), vector2_2 (ref)
		AbsoluteSize = p2.AbsoluteSize
		t1:setState({
			absoluteSize = AbsoluteSize,
			insets = {
				top = vector2.Y,
				left = vector2.X,
				bottom = vector2_2.Y,
				right = vector2_2.X
			}
		})
	end)
end
function v5.didMount(p3) -- line: 64
	local current = p3.rootRef.current
	local LayerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

	if LayerCollector == nil then
		p3.ancestryConnection = current.AncestryChanged:Connect(function() -- line: 69
			-- upvalues: LayerCollector (ref), current (copy), p3 (copy)
			LayerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

			if LayerCollector ~= nil then
				p3.ancestryConnection:Disconnect()
				p3.ancestryConnection = nil
				p3:watchLayerCollector(LayerCollector)
			end
		end)
	else
		p3:watchLayerCollector(LayerCollector)
	end
end
function v5.render(p4) -- line: 82
	-- upvalues: Roact (copy), LayerCollectorContext (copy)
	return Roact.createElement(LayerCollectorContext.Provider, {
		value = {
			absoluteSize = p4.state.absoluteSize,
			insets = p4.state.insets
		}
	}, {
		LayerCollectorChildRef = Roact.createElement("Frame", {
			Visible = false,
			[Roact.Ref] = p4.rootRef
		}),
		Children = Roact.createFragment(p4.props[Roact.Children])
	})
end

return v5
