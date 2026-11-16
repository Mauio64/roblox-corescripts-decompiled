local parent = script.Parent.Parent
require(parent.FocusNavigation)

local Heartbeat = require(script.Parent.Heartbeat)

local function cancellableDelay(durationSeconds, fn)
	local v = false
	task.delay(durationSeconds, function()
		if not v then
			fn()
		end
	end)
	return {
		cancel = function()
			v = true
		end
	}
end

local function handleInput(data)
	local hold = data.hold
	local v = nil
	local connection = nil

	local v2 = false

	local function clearHeldState() -- 4 equivalent calls inferred from this helper
		if v then
			v.cancel()
			v = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		v2 = false
	end

	return function(p)
		local eventData = p.eventData
		local v3

		if eventData then
			v3 = eventData.immediateDispatch or false
		else
			v3 = false
		end

		v2 = v3 or v2
		local userInputState

		if eventData then
			userInputState = eventData.UserInputState
		end

		if userInputState == Enum.UserInputState.Begin then
			if data.onPress then
				data.onPress(p)
			end

			clearHeldState() -- inferred equivalent call

			if hold then
				if v3 then
					hold.onComplete()
				else
					v = cancellableDelay(hold.durationSeconds, function()
						if not hold.allowReleaseAfterHold then
							v2 = false
						end

						hold.onComplete()

						if connection then
							connection:Disconnect()
							connection = nil
						end
					end)
					local v4

					if hold.onStep then
						v4 = Heartbeat:Connect(hold.onStep)
					end

					connection = v4
				end
			end

			if v3 then
				clearHeldState() -- inferred equivalent call
			else
				v2 = true
			end
		end

		if userInputState == Enum.UserInputState.End then
			if data.onRelease and v2 then
				data.onRelease(p)
			end

			clearHeldState() -- inferred equivalent call
		end

		if userInputState == Enum.UserInputState.Cancel then
			clearHeldState() -- inferred equivalent call
		end
	end
end

return handleInput
