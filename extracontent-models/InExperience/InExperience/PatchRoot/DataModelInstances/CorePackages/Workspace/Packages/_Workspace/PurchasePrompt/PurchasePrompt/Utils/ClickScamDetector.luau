local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Cryo = require(Parent.PurchasePromptDeps).Cryo
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 25
	-- upvalues: Cryo (copy), t1 (copy), UserInputService (copy)
	local v6 = Cryo.Dictionary.join({
		clickSpeedThreshold = 3,
		clickTimeWindow = 1,
		initialDelay = 1,
		buttonInput = nil
	}, p1 or {})
	local t2 = {
		_inputConnection = nil,
		_clickCount = 0,
		_startTime = tick(),
		_options = v6
	}

	setmetatable(t2, t1)
	t2._inputConnection = UserInputService.InputBegan:Connect(function(input) -- line: 50
		-- upvalues: t2 (copy)
		t2:_onInput(input)
	end)

	return t2
end
function t1._onInput(p2, p3) -- line: 63
	local UserInputType = p3.UserInputType
	local v11 = p2._options.buttonInput ~= nil and p3.KeyCode == p2._options.buttonInput
	local v12 = UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch

	if v11 or v12 then
		p2._clickCount = p2._clickCount + 1
		delay(p2._options.clickTimeWindow, function() -- line: 73
			-- upvalues: p2 (copy)
			p2._clickCount = p2._clickCount - 1
		end)
	end
end
function t1.isClickValid(p4) -- line: 83
	-- upvalues: UserInputService (copy)
	if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
		return false
	end

	if tick() - p4._startTime < p4._options.initialDelay then
		return false
	end

	return p4._clickCount / p4._options.clickTimeWindow < p4._options.clickSpeedThreshold
end
function t1.destroy(p5) -- line: 105
	p5._inputConnection:Disconnect()
end

return t1
