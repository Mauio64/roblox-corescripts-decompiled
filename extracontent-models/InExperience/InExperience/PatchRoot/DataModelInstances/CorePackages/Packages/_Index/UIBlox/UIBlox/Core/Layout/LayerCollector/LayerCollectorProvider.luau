local parent = script.Parent.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)

local LayerCollectorContext = require(script.Parent.LayerCollectorContext)
local GuiService = game:GetService("GuiService")
local extended = Roact.PureComponent:extend("LayerCollectorProvider")

function extended:init()
	self.rootRef = Roact.createRef()
	self.state = {
		absoluteSize = Vector2.new(0, 0),
		insets = { top = 0, left = 0, bottom = 0, right = 0 }
	}
end

function extended:watchLayerCollector(screenGui)
	local absoluteSize = screenGui.AbsoluteSize
	local v = Vector2.new(0, 0)
	local v2 = Vector2.new(0, 0)

	if screenGui:IsA("ScreenGui") then
		local success, result = pcall(function()
			return screenGui.IgnoreGuiInset
		end)

		if success and result then
			v, v2 = GuiService:GetGuiInset()
		end
	end

	self:setState({
		absoluteSize = absoluteSize,
		insets = { top = v.Y, left = v.X, bottom = v2.Y, right = v2.X }
	})

	self.absoluteSizeConnection = screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		absoluteSize = screenGui.AbsoluteSize
		self:setState({
			absoluteSize = absoluteSize,
			insets = { top = v.Y, left = v.X, bottom = v2.Y, right = v2.X }
		})
	end)
end

function extended:didMount()
	local current = self.rootRef.current
	local layerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

	if layerCollector == nil then
		self.ancestryConnection = current.AncestryChanged:Connect(function()
			layerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector ~= nil then
				self.ancestryConnection:Disconnect()
				self.ancestryConnection = nil
				self:watchLayerCollector(layerCollector)
			end
		end)
	else
		self:watchLayerCollector(layerCollector)
	end
end

function extended.render(props)
	return Roact.createElement(LayerCollectorContext.Provider, {
		value = { absoluteSize = props.state.absoluteSize, insets = props.state.insets }
	}, {
		LayerCollectorChildRef = Roact.createElement("Frame", {
			Visible = false,
			[Roact.Ref] = props.rootRef
		}),
		Children = Roact.createFragment(props.props[Roact.Children])
	})
end

return extended
