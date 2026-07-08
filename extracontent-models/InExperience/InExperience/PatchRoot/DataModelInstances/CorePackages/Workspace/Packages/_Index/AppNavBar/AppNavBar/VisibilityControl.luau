local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Otter = require(ParentParent.Otter)
local SharedFlags = require(ParentParent.SharedFlags)
local v6 = game:DefineFastFlag("AppIaScrollAwayIgnoreHorizontal", false)
local v7 = game:DefineFastInt("AppIaScrollAwayThreshold", 10)
local FFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix
local t1 = {
	dampingRatio = 1,
	frequency = 3,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}
local t2 = {
	binding = nil,
	motor = nil
}

t2.__index = t2

function t2.create(n1: number) -- line: 40
	-- upvalues: React (copy), Otter (copy), t2 (copy)
	local v16, v17 = React.createBinding(n1)
	local v18 = Otter.createSingleMotor(n1)

	v18:onStep(v17)

	local t3 = {
		binding = v16,
		motor = v18
	}

	setmetatable(t3, t2)

	return t3
end
function t2.destroy(p1) -- line: 54
	p1.motor:destroy()
end
function t2.getBinding(p2) -- line: 58
	return p2.binding
end
function t2.show(p3) -- line: 62
	-- upvalues: Otter (copy), t1 (copy)
	p3.motor:setGoal(Otter.spring(1, t1))
end
function t2.hide(p4) -- line: 66
	-- upvalues: Otter (copy), t1 (copy)
	p4.motor:setGoal(Otter.spring(0, t1))
end
function t2.update(t4: {[any]: any}, n2: number) -- line: 70
	-- upvalues: Otter (copy)
	local v26 = math.clamp(t4.binding:getValue() + n2, 0, 1)

	t4.motor:setGoal(Otter.instant(v26))
end
function t2.finishUp(p5) -- line: 76
	if p5.binding:getValue() < 0.5 then
		p5:hide()

		return
	end

	p5:show()
end

local t5 = {
	enabled = false,
	header = nil,
	footer = nil,
	footerVisible = false,
	connections = nil,
	touching = false,
	moving = false,
	touchPositionX = 0,
	touchPositionY = 0,
	horizontalLocked = false,
	scrollDistance = 50,
	contentScrollable = true,
	headerScrollAwayDisabled = not FFlagAppIaScrollAwayPinHeader and nil,
	globalTouchDisabled = not FFlagAppIaScopedScrollAway and nil
}

t5.__index = t5

local t12 = nil

function t5.onTouchMoved(t6: {[any]: any}, n3: number) -- line: 120
	-- upvalues: FFlagEnableScrollAwayContentScrollableFix (copy), FFlagAppIaScrollAwayPinHeader (copy)
	if FFlagEnableScrollAwayContentScrollableFix and not t6.contentScrollable then
		return
	end

	local v30 = n3 / t6.scrollDistance

	if t6.footerVisible then
		t6.footer:update(v30)
	end

	if FFlagAppIaScrollAwayPinHeader then
		if not t6.headerScrollAwayDisabled then
			t6.header:update(v30)

			return
		end
	else
		t6.header:update(v30)
	end
end
function t5.onTouchEnded(p6) -- line: 139
	-- upvalues: FFlagAppIaScrollAwayPinHeader (copy)
	if p6.footerVisible then
		p6.footer:finishUp()
	end

	if FFlagAppIaScrollAwayPinHeader then
		if not p6.headerScrollAwayDisabled then
			p6.header:finishUp()

			return
		end
	else
		p6.header:finishUp()
	end
end
function t5.connectTouch(p7) -- line: 154
	-- upvalues: UserInputService (copy), v6 (copy), v7 (copy)
	if p7.connections ~= nil then
		return
	end

	p7.connections = {}
	p7.connections.started = UserInputService.TouchStarted:Connect(function(p8) -- line: 159
		-- upvalues: p7 (copy), v6 (copy)
		p7.touching = true

		if v6 then
			p7.moving = false
			p7.horizontalLocked = false
			p7.touchPositionX = p8.Position.X
		end

		p7.touchPositionY = p8.Position.Y
	end)
	p7.connections.moved = UserInputService.TouchMoved:Connect(function(p9) -- line: 168
		-- upvalues: p7 (copy), v6 (copy), v7 (copy)
		if not p7.touching then
			return
		end

		if v6 and p7.horizontalLocked then
			return
		end

		local PositionY = p9.Position.Y

		if not p7.moving then
			if v6 then
				local v67 = math.abs(p9.Position.X - p7.touchPositionX)
				local v68 = math.abs(PositionY - p7.touchPositionY)

				if v67 > v7 and v68 < v67 then
					p7.horizontalLocked = true

					return
				end

				if v68 > v7 then
					p7.moving = true
					p7.touchPositionY = PositionY

					return
				end
			elseif math.abs(PositionY - p7.touchPositionY) > v7 then
				p7.moving = true
				p7.touchPositionY = PositionY
			end

			return
		end

		local v69 = PositionY - p7.touchPositionY

		p7.touchPositionY = PositionY
		p7:onTouchMoved(v69)
	end)
	p7.connections.ended = UserInputService.TouchEnded:Connect(function(_) -- line: 202
		-- upvalues: p7 (copy), v6 (copy)
		if not p7.touching then
			return
		end

		p7.touching = false
		p7.moving = false

		if v6 then
			p7.horizontalLocked = false
		end

		p7:onTouchEnded()
	end)
end
function t5.disconnectTouch(p11) -- line: 215
	if p11.connections == nil then
		return
	end

	for _, v in pairs(p11.connections) do
		v:Disconnect()
	end

	p11.connections = nil
end
function t5.isEnabled(p12) -- line: 228
	return p12.enabled
end
function t5.setEnabled(t7: {[any]: any}, b1: boolean) -- line: 235
	-- upvalues: FFlagAppIaScopedScrollAway (copy), FFlagEnableScrollAwayContentScrollableFix (copy)
	if b1 == t7.enabled then
		return
	end

	t7.enabled = b1

	if b1 then
		if not FFlagAppIaScopedScrollAway then
			t7:connectTouch()

			return
		end

		if not t7.globalTouchDisabled then
			t7:connectTouch()

			return
		end
	else
		t7:disconnectTouch()

		if FFlagEnableScrollAwayContentScrollableFix then
			t7.contentScrollable = true
		end
	end
end
function t5.setGlobalTouchEnabled(t8: {[any]: any}, b2: boolean) -- line: 261
	t8.globalTouchDisabled = not b2

	if b2 then
		if t8.enabled then
			t8:connectTouch()

			return
		end
	else
		t8:disconnectTouch()
	end
end
function t5.setContentScrollable(t9: {[any]: any}, b3: boolean) -- line: 272
	if b3 == t9.contentScrollable then
		return
	end

	if not b3 then
		t9:show()
	end

	t9.contentScrollable = b3
end
function t5.setFooterVisible(t10: {[any]: any}, b4: boolean) -- line: 285
	if b4 == t10.footerVisible then
		return
	end

	t10.footerVisible = b4

	if b4 then
		t10.footer:show()

		return
	end

	t10.footer:hide()
end
function t5.getHeaderBinding(p13) -- line: 300
	return p13.header:getBinding()
end
function t5.getFooterBinding(p14) -- line: 307
	return p14.footer:getBinding()
end
function t5.setHeaderScrollAwayDisabled(t11: {[any]: any}, b5: boolean) -- line: 315
	-- upvalues: FFlagAppIaScrollAwayPinHeader (copy)
	if not FFlagAppIaScrollAwayPinHeader then
		return
	end

	t11.headerScrollAwayDisabled = b5

	if b5 then
		t11.header:show()
	end
end
function t5.show(p15) -- line: 328
	-- upvalues: FFlagEnableScrollAwayContentScrollableFix (copy)
	if FFlagEnableScrollAwayContentScrollableFix then
		p15.contentScrollable = true
	end

	p15.header:show()

	if p15.footerVisible then
		p15.footer:show()
	end
end
function t5.hide(p16) -- line: 341
	-- upvalues: FFlagAppIaScrollAwayPinHeader (copy)
	if FFlagAppIaScrollAwayPinHeader then
		if not p16.headerScrollAwayDisabled then
			p16.header:hide()
		end
	else
		p16.header:hide()
	end

	if p16.footerVisible then
		p16.footer:hide()
	end
end
function t5.getInstance() -- line: 357
	-- upvalues: t12 (ref), t5 (copy)
	if not t12 then
		t12 = {}
		setmetatable(t12, t5)
		t12:initialize()
	end

	return t12
end
function t5.initialize(p17) -- line: 367
	-- upvalues: t2 (copy)
	p17.header = t2.create(1)
	p17.footer = t2.create(0)
end
function t5.destroy(p18) -- line: 377
	-- upvalues: t12 (ref)
	p18.header:destroy()
	p18.footer:destroy()
	p18:disconnectTouch()
	t12 = nil
end
function t5.setScrollDistance(t13: {[any]: any}, n4: number) -- line: 387
	if n4 == 0 then
		return
	end

	t13.scrollDistance = n4
end

return {
	isEnabled = function() -- line: 399
		-- upvalues: t5 (copy)
		return t5.getInstance():isEnabled()
	end,
	setEnabled = function(b6: boolean) -- line: 402
		-- upvalues: t5 (copy)
		t5.getInstance():setEnabled(b6)
	end,
	getHeaderBinding = function() -- line: 405
		-- upvalues: t5 (copy)
		return t5.getInstance():getHeaderBinding()
	end,
	getFooterBinding = function() -- line: 408
		-- upvalues: t5 (copy)
		return t5.getInstance():getFooterBinding()
	end,
	setFooterVisible = function(b7: boolean) -- line: 411
		-- upvalues: t5 (copy)
		t5.getInstance():setFooterVisible(b7)
	end,
	setHeaderScrollAwayDisabled = if not FFlagAppIaScrollAwayPinHeader then nil else function(b8: boolean) -- line: 415
		-- upvalues: t5 (copy)
		t5.getInstance():setHeaderScrollAwayDisabled(b8)
	end,
	show = function() -- line: 419
		-- upvalues: t5 (copy)
		t5.getInstance():show()
	end,
	hide = function() -- line: 422
		-- upvalues: t5 (copy)
		t5.getInstance():hide()
	end,
	destroy = function() -- line: 425
		-- upvalues: t5 (copy)
		t5.getInstance():destroy()
	end,
	setScrollDistance = function(n5: number) -- line: 428
		-- upvalues: t5 (copy)
		t5.getInstance():setScrollDistance(n5)
	end,
	setGlobalTouchEnabled = if not FFlagAppIaScopedScrollAway then nil else function(b9: boolean) -- line: 432
		-- upvalues: t5 (copy)
		t5.getInstance():setGlobalTouchEnabled(b9)
	end,
	onTouchMoved = if not FFlagAppIaScopedScrollAway then nil else function(n6: number) -- line: 437
		-- upvalues: t5 (copy)
		local v61 = t5.getInstance()

		if v61.enabled then
			v61:onTouchMoved(n6)
		end
	end,
	onTouchEnded = if not FFlagAppIaScopedScrollAway then nil else function() -- line: 445
		-- upvalues: t5 (copy)
		local v62 = t5.getInstance()

		if v62.enabled then
			v62:onTouchEnded()
		end
	end,
	setContentScrollable = function(b10: boolean) -- line: 452
		-- upvalues: t5 (copy)
		t5.getInstance():setContentScrollable(b10)
	end
}
