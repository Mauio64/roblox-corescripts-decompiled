local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)
local EventConnection = require(script.Parent.EventConnection)
local v7 = Roact.PureComponent:extend("ScreenSizeConnector")

function v7.init(p1) -- line: 15
	-- upvalues: Roact (copy)
	p1.state = {
		layerCollector = nil
	}
	p1.folderRef = Roact.createRef()
end
function v7.render(p2) -- line: 23
	-- upvalues: Roact (copy), EventConnection (copy)
	if p2.state.layerCollector then
		local AbsoluteSize = p2.state.layerCollector.AbsoluteSize

		p2.props.setScreenSize(AbsoluteSize.X, AbsoluteSize.Y)

		return Roact.createElement(EventConnection, {
			event = p2.state.layerCollector:GetPropertyChangedSignal("AbsoluteSize"),
			callback = function() -- line: 29
				-- upvalues: AbsoluteSize (ref), p2 (copy)
				AbsoluteSize = p2.state.layerCollector.AbsoluteSize
				p2.props.setScreenSize(AbsoluteSize.X, AbsoluteSize.Y)
			end
		})
	end

	return Roact.createElement("Folder", {
		[Roact.Ref] = p2.folderRef
	})
end
function v7.watchFolderAncestery(p3) -- line: 41
	if p3.folderRef.current and p3.ancesteryConnection == nil then
		local LayerCollector = p3.folderRef.current:FindFirstAncestorWhichIsA("LayerCollector")

		if LayerCollector then
			p3:setState({
				layerCollector = LayerCollector
			})
		else
			p3.ancesteryConnection = p3.folderRef.current.AncestryChanged:Connect(function() -- line: 49
				-- upvalues: p3 (copy), LayerCollector (ref)
				if p3.folderRef.current then
					LayerCollector = p3.folderRef.current:FindFirstAncestorWhichIsA("LayerCollector")

					if LayerCollector then
						p3:setState({
							layerCollector = LayerCollector
						})
					end
				end
			end)
		end
	end
end
function v7.didMount(p4) -- line: 63
	p4:watchFolderAncestery()
end
function v7.didUpdate(p5) -- line: 67
	if not p5.state.layerCollector then
		p5:watchFolderAncestery()

		return
	end

	if p5.ancesteryConnection then
		p5.ancesteryConnection:Disconnect()
		p5.ancesteryConnection = nil
	end
end
function v7.willUnmount(p6) -- line: 76
	if p6.ancesteryConnection then
		p6.ancesteryConnection:Disconnect()
		p6.ancesteryConnection = nil
	end
end

local function mapDispatchToProps(p7) -- line: 83
	-- upvalues: SetScreenSize (copy)
	return {
		setScreenSize = function(p8, p9) -- line: 85
			-- upvalues: p7 (copy), SetScreenSize (copy)
			return p7(SetScreenSize(p8, p9))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v7)
