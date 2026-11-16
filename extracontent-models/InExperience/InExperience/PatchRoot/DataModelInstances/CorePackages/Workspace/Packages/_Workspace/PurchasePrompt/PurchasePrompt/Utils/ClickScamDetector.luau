local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Cryo = PurchasePromptDeps.Cryo

local ClickScamDetector = {}
ClickScamDetector.__index = ClickScamDetector

function ClickScamDetector.new(options)
	local joined = Cryo.Dictionary.join(
		{ clickSpeedThreshold = 3, clickTimeWindow = 1, initialDelay = 1, buttonInput = nil },
		options or {}
	)

	local v = { _inputConnection = nil, _clickCount = 0, _startTime = tick(), _options = joined }

	setmetatable(v, ClickScamDetector)

	v._inputConnection = UserInputService.InputBegan:Connect(function(input)
		v:_onInput(input)
	end)

	return v
end

function ClickScamDetector:_onInput(p)
	local userInputType = p.UserInputType
	local v

	if self._options.buttonInput == nil then
		v = false
	else
		v = p.KeyCode == self._options.buttonInput
	end

	local v2 = userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch

	if v or v2 then
		self._clickCount += 1

		delay(self._options.clickTimeWindow, function()
			self._clickCount -= 1
		end)
	end
end

function ClickScamDetector:isClickValid(): boolean
	if
		UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition
		or tick() - self._startTime < self._options.initialDelay
	then
		return false
	end

	return self._clickCount / self._options.clickTimeWindow < self._options.clickSpeedThreshold
end

function ClickScamDetector:destroy()
	self._inputConnection:Disconnect()
end

return ClickScamDetector
