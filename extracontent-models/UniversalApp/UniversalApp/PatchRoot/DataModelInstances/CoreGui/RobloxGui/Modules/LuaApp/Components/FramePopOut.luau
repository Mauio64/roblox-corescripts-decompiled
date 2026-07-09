local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local RoactMotion = require(Modules.LuaApp.RoactMotion)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle

local function lerp(p1, p2, p3) -- line: 28
	return (1 - p1) * p2 + p1 * p3
end
local function findPosition(p4, p5, p6) -- line: 32
	local t1 = {}
	local v18 = p4.x + p4.width * 0.5
	local v19 = p4.y + p4.height * 0.5
	local v20 = 0.1 * p6

	t1.pointerHeight = 6
	t1.pointerWidth = 12
	t1.x = p4.x + p4.width * 0.5 - p5 * 0.5
	t1.pointerX = v18 - t1.pointerWidth * 0.5

	if v19 < p4.parentHeight * 0.5 then
		t1.y = p4.y + p4.height + t1.pointerHeight
		t1.height = math.min(p4.parentHeight - t1.y - 10, p6)
		t1.pointerIcon = "LuaApp/dropdown/gr-tip-up"
		t1.pointerY = p4.y + p4.height
		t1.menuStartY = t1.y
	else
		local v21 = p4.y - t1.pointerHeight

		t1.height = math.min(v21 - 10, p6)
		t1.y = v21 - t1.height
		t1.pointerIcon = "LuaApp/dropdown/gr-tip-down"
		t1.pointerY = v21
		t1.menuStartY = t1.pointerY - v20
	end

	if p6 > t1.height then
		t1.pointerHeight = 12
		t1.pointerWidth = 6
		t1.height = math.min(p4.parentHeight - 20, p6)
		t1.y = v19 - t1.height * 0.5

		if t1.y < 10 then
			t1.y = 10
		elseif p4.parentHeight - 10 < t1.y + t1.height then
			t1.y = p4.parentHeight - 10 - t1.height
		end

		t1.pointerY = v19 - t1.pointerHeight * 0.5
		t1.menuStartY = t1.pointerY + t1.pointerHeight / 2 - v20 / 2

		if v18 <= p4.parentWidth * 0.5 then
			t1.x = p4.x + p4.width + t1.pointerWidth

			if t1.x + p5 > p4.parentWidth - 10 then
				t1.x = p4.parentWidth - p5 - 10
			end

			t1.pointerIcon = "LuaApp/dropdown/gr-tip-left"
			t1.pointerX = t1.x - t1.pointerWidth
		else
			t1.x = p4.x - p5 - t1.pointerWidth

			if t1.x < 10 then
				t1.x = 10
			end

			t1.pointerIcon = "LuaApp/dropdown/gr-tip-right"
			t1.pointerX = t1.x + p5
		end
	elseif t1.x < 10 then
		t1.x = 10
	elseif t1.x + p5 > p4.parentWidth - 10 then
		t1.x = p4.parentWidth - p5 - 10
	end

	t1.pointerX = t1.pointerX + -1
	t1.pointerY = t1.pointerY + -1
	t1.pointerWidth = t1.pointerWidth + 2
	t1.pointerHeight = t1.pointerHeight + 2

	return t1
end

local v10 = Roact.PureComponent:extend("FramePopOut")

v10.defaultProps = {
	isAnimated = false
}

function v10.init(p7) -- line: 148
	p7.state = {
		frameHeight = 0,
		hidden = p7.props.isAnimated
	}
	p7.isMounted = false
	p7.animationPercentage = not p7.state.hidden and 1 or 0
	p7.stiffness = nil
	p7.damping = nil
	p7.onRested = nil

	function p7.onActivated() -- line: 162
		-- upvalues: p7 (copy)
		p7:close()
	end
	function p7.onSizeChanged(p8) -- line: 166
		-- upvalues: p7 (copy)
		spawn(function() -- line: 167
			-- upvalues: p7 (copy), p8 (copy)
			if p7.isMounted then
				p7:setState({
					frameHeight = p8.AbsoluteSize.Y
				})
			end
		end)
	end
end
function v10.open(p9) -- line: 177
	if p9.state.hidden and p9.props.isAnimated then
		p9.animationPercentage = 1
		p9.stiffness = nil
		p9.damping = nil
		p9.onRested = nil
		p9:setState({
			hidden = false
		})
	end

	p9.animationPercentage = 1
	p9.stiffness = nil
	p9.damping = nil
	p9.onRested = nil
	p9:setState({
		hidden = false
	})
end
function v10.close(p10) -- line: 198
	local onCancel = p10.props.onCancel

	if not p10.state.hidden and p10.props.isAnimated then
		p10.animationPercentage = 0
		p10.stiffness = 270
		p10.damping = nil
		p10.onRested = onCancel
		p10:setState({
			hidden = true
		})

		return
	end

	if not p10.props.isAnimated then
		onCancel()
	end
end
function v10.didMount(p11) -- line: 216
	p11.isMounted = true
	p11:open()
end
function v10.willUnmount(p12) -- line: 221
	p12.isMounted = false
end
function v10.render(p13) -- line: 225
	-- upvalues: Roact (copy), findPosition (copy), withStyle (copy), DEPRECATED_ImageSetLabel (copy), RoactMotion (copy), FitChildren (copy)
	local v29 = p13.props[Roact.Children]
	local itemWidth = p13.props.itemWidth
	local parentShape = p13.props.parentShape

	if p13.state.frameHeight == 0 then
		itemWidth = 0
	end

	local v32 = findPosition(parentShape, itemWidth, p13.state.frameHeight)

	return withStyle(function(p14) -- line: 246
		-- upvalues: Roact (copy), p13 (copy), DEPRECATED_ImageSetLabel (copy), v32 (copy), RoactMotion (copy), itemWidth (ref), FitChildren (copy), v29 (copy)
		return Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Text = "",
			Selectable = false,
			[Roact.Event.Activated] = p13.onActivated
		}, {
			Pointer = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Image = v32.pointerIcon,
				ImageColor3 = p14.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p14.Theme.BackgroundUIDefault.Transparency,
				Position = UDim2.new(0, v32.pointerX, 0, v32.pointerY),
				Size = UDim2.new(0, v32.pointerWidth, 0, v32.pointerHeight)
			}),
			AnimatedPopout = Roact.createElement(RoactMotion.SimpleMotion, {
				style = {
					animationPercentage = RoactMotion.spring(p13.animationPercentage, p13.stiffness, p13.damping)
				},
				onRested = function() -- line: 269
					-- upvalues: p13 (copy)
					if p13.onRested then
						p13.onRested()
					end
				end,
				render = function(p15) -- line: 274
					-- upvalues: Roact (copy), p14 (copy), v32 (copy), itemWidth (ref), p13 (copy), FitChildren (copy), v29 (copy)
					local createElement = Roact.createElement
					local t2 = {
						BorderSizePixel = 0,
						ClipsDescendants = true,
						BackgroundColor3 = p14.Theme.BackgroundUIDefault.Color,
						BackgroundTransparency = p14.Theme.BackgroundUIDefault.Transparency
					}
					local new = UDim2.new
					local x = v32.x
					local animationPercentage = p15.animationPercentage
					local menuStartY = v32.menuStartY
					local y = v32.y

					t2.Position = new(0, x, 0, (1 - animationPercentage) * menuStartY + animationPercentage * y)

					local new2 = UDim2.new
					local v44 = itemWidth
					local animationPercentage2 = p15.animationPercentage

					t2.Size = new2(0, v44, 0, ((1 - animationPercentage2) * 0.1 + animationPercentage2 * 1) * p13.state.frameHeight)

					return createElement("Frame", t2, {
						Frame = Roact.createElement(FitChildren.FitFrame, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							fitAxis = FitChildren.FitAxis.Height,
							ClipsDescendants = false,
							[Roact.Change.AbsoluteSize] = p13.onSizeChanged
						}, v29)
					})
				end
			})
		})
	end)
end

return v10
