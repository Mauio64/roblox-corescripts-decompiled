local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local SetScreenSize = require(parent.Actions.SetScreenSize)

local EventConnection = require(script.Parent.EventConnection)

local extended = Roact.PureComponent:extend("ScreenSizeConnector")

function extended:init()
	self.state = { layerCollector = nil }

	self.folderRef = Roact.createRef()
end

function extended.render(props)
	if props.state.layerCollector then
		local absoluteSize = props.state.layerCollector.AbsoluteSize
		props.props.setScreenSize(absoluteSize.X, absoluteSize.Y)
		return Roact.createElement(EventConnection, {
			event = props.state.layerCollector:GetPropertyChangedSignal("AbsoluteSize"),
			callback = function()
				absoluteSize = props.state.layerCollector.AbsoluteSize
				props.props.setScreenSize(absoluteSize.X, absoluteSize.Y)
			end
		})
	end

	return Roact.createElement("Folder", { [Roact.Ref] = props.folderRef })
end

function extended:watchFolderAncestery()
	if self.folderRef.current and self.ancesteryConnection == nil then
		local layerCollector = self.folderRef.current:FindFirstAncestorWhichIsA("LayerCollector")

		if layerCollector then
			self:setState({ layerCollector = layerCollector })
		else
			self.ancesteryConnection = self.folderRef.current.AncestryChanged:Connect(function()
				if self.folderRef.current then
					layerCollector = self.folderRef.current:FindFirstAncestorWhichIsA("LayerCollector")

					if layerCollector then
						self:setState({ layerCollector = layerCollector })
					end
				end
			end)
		end
	end
end

function extended:didMount()
	self:watchFolderAncestery()
end

function extended:didUpdate()
	if not self.state.layerCollector then
		self:watchFolderAncestery()
	elseif self.ancesteryConnection then
		self.ancesteryConnection:Disconnect()
		self.ancesteryConnection = nil
	end
end

function extended:willUnmount()
	if self.ancesteryConnection then
		self.ancesteryConnection:Disconnect()
		self.ancesteryConnection = nil
	end
end

local function mapDispatchToProps(callback)
	return {
		setScreenSize = function(p, p2)
			return callback(SetScreenSize(p, p2))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
