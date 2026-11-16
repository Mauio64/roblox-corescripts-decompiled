local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local View = Foundation.View

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
	local zIndex, v = React.useBinding(1)
	local position, v2 = React.useBinding(UDim2.new())
	local size, v3 = React.useBinding(UDim2.new())
	React.useLayoutEffect(function()
		local current = ref.current

		if current == nil then
			return nil
		end

		local function synchronize()
			v(scrollingFrame.ZIndex + 1)
			local v4 = scrollingFrame.AbsolutePosition - current.AbsolutePosition
			local absoluteSize = scrollingFrame.AbsoluteSize
			v2(UDim2.fromOffset(v4.X, v4.Y))
			v3(UDim2.fromOffset(absoluteSize.X, absoluteSize.Y))
		end
		synchronize()
		local v4 = {
			scrollingFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize),
			scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(synchronize),
			scrollingFrame:GetPropertyChangedSignal("ZIndex"):Connect(synchronize),
			current:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize)
		}

		return function()
			for _, connection in v4 do
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
				ZIndex = zIndex,
				ref = ref
			}, {
				Cover = React.createElement(View, {
					Position = position,
					Size = size,
					Visible = props.Visible,
					tag = "bg-surface-100",
					testId = props.testId
				}, props.children)
			})
		})
	}, state)
end

return ScrollingFrameCover
