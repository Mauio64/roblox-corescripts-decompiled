local RunService = game:GetService("RunService")

local FadeController = {}
FadeController.__index = FadeController

function FadeController.new()
	local self = setmetatable({}, FadeController)
	self.lastInputTimeSec = -1
	self.subscriptions = {}
	self.lastProgress = -1

	return self
end

function FadeController:getCurrentProgress()
	local v = os.clock() - self.lastInputTimeSec

	if v < self.dwellTimeSec then
		return 1
	end

	if v < self.dwellTimeSec + self.fadeDurationSec then
		return 1 - (v - self.dwellTimeSec) / self.fadeDurationSec
	end

	return 0
end

function FadeController:inProgress(): boolean
	return self:getCurrentProgress() > 0
end

function FadeController:isFading(): boolean
	local v = os.clock() - self.lastInputTimeSec
	return self.dwellTimeSec <= v and v < self.dwellTimeSec + self.fadeDurationSec
end

function FadeController:updateLastInputTime()
	self.lastInputTimeSec = os.clock()
end

function FadeController:skipToFade()
	if not self:isFading() then
		self.lastInputTimeSec = os.clock() - self.dwellTimeSec
	end
end

function FadeController:zeroOut()
	self.lastInputTimeSec = -1
end

function FadeController:subscribe(p)
	table.insert(self.subscriptions, p)

	if not self.heartbeatConnection then
		self.heartbeatConnection = RunService.RenderStepped:Connect(function()
			local currentProgress = self:getCurrentProgress()

			if currentProgress ~= self.lastProgress then
				self.lastProgress = currentProgress

				for _, subscription in ipairs(self.subscriptions) do
					subscription(currentProgress)
				end
			end
		end)
	end
end

function FadeController:unsubscribe(p)
	for i, subscription in ipairs(self.subscriptions) do
		if subscription == p then
			table.remove(self.subscriptions, i)
			break
		end
	end

	if #self.subscriptions == 0 and self.heartbeatConnection then
		self.heartbeatConnection:Disconnect()
		self.heartbeatConnection = nil
	end
end

FadeController.fadeDurationSec = 1
FadeController.dwellTimeSec = 1

return FadeController
