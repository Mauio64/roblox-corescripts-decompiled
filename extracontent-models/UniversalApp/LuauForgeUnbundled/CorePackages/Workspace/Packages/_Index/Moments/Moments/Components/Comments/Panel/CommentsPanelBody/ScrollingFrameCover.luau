local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactRoblox")

local view = Foundation.View

local function ScrollingFrameCover(props)
	local scrollingFrame = props.scrollingFrame
	local state, setState = React.useState(nil)
	React.useLayoutEffect(function()
		setState(scrollingFrame.Parent)
		local parentChangedConnection = scrollingFrame:GetPropertyChangedSignal("Parent"):Connect(function()
			setState(scrollingFrame.Parent)
		end)
		return function()
			parentChangedConnection:Disconnect()
		end
	end, { scrollingFrame })

	local ref = React.useRef(nil)
	local v5, v6 = React.useBinding(1)
	local v7, v8 = React.useBinding(UDim2.new())
	local v9, v10 = React.useBinding(UDim2.new())
	React.useLayoutEffect(function()
		local current = ref.current

		if current == nil then
			return nil
		end

		local function synchronize()
			v6(scrollingFrame.ZIndex + 1)
			local v11 = scrollingFrame.AbsolutePosition - current.AbsolutePosition
			local absoluteSize = scrollingFrame.AbsoluteSize
			v8(UDim2.fromOffset(v11.X, v11.Y))
			v10(UDim2.fromOffset(absoluteSize.X, absoluteSize.Y))
		end
		synchronize()
		local v11 = {
			scrollingFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize),
			scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(synchronize),
			scrollingFrame:GetPropertyChangedSignal("ZIndex"):Connect(synchronize),
			current:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize)
		}

		return function()
			for k, connection in v11 do
				connection:Disconnect()
			end
		end
	end, { scrollingFrame, state })

	if state == nil then
		return nil
	end

	return ReactRoblox.createPortal({
		ScrollingFrameCover = React.createElement("Folder", nil, {
			Bounds = React.createElement("ScrollingFrame", {
				Active = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(),
				ScrollBarThickness = 0,
				ScrollingEnabled = false,
				Selectable = false,
				Size = UDim2.fromScale(1, 1),
				ZIndex = v5,
				ref = ref
			}, {
				Cover = React.createElement(view, {
					Position = v7,
					Size = v9,
					Visible = props.Visible,
					tag = "bg-surface-100",
					testId = props.testId
				}, props.children)
			})
		})
	}, state)
end

return ScrollingFrameCover
