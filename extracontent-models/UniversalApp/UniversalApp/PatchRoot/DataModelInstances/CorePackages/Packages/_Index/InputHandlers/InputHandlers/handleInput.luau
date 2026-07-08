local ParentParent = script.Parent.Parent

require(ParentParent.FocusNavigation)

local Heartbeat = require(script.Parent.Heartbeat)

local function cancellableDelay(p1, p2) -- line: 28
	local u7 = false

	task.delay(p1, function() -- line: 30
		-- upvalues: u7 (ref), p2 (copy)
		if not u7 then
			p2()
		end
	end)

	return {
		cancel = function() -- line: 36
			-- upvalues: u7 (ref)
			u7 = true
		end
	}
end
local function handleInput(t1: {[any]: any}) -- line: 42
	-- upvalues: cancellableDelay (copy), Heartbeat (copy)
	local hold = t1.hold
	local u10 = nil
	local u11 = nil
	local u12 = false

	local function clearHeldState() -- line: 49
		-- upvalues: u10 (ref), u11 (ref), u12 (ref)
		if u10 then
			u10.cancel()
			u10 = nil
		end

		if u11 then
			u11:Disconnect()
			u11 = nil
		end

		u12 = false
	end

	return function(p3) -- line: 61
		-- upvalues: u12 (ref), t1 (copy), u10 (ref), u11 (ref), hold (copy), cancellableDelay (copy), Heartbeat (copy)
		local eventData = p3.eventData
		local v16 = not not eventData and (eventData.immediateDispatch or false)

		u12 = v16 or u12

		local v17 = if not eventData then nil else eventData.UserInputState

		if v17 == Enum.UserInputState.Begin then
			if t1.onPress then
				t1.onPress(p3)
			end

			if u10 then
				u10.cancel()
				u10 = nil
			end

			if u11 then
				u11:Disconnect()
				u11 = nil
			end

			u12 = false

			if hold then
				if v16 then
					hold.onComplete()
				else
					u10 = cancellableDelay(hold.durationSeconds, function() -- line: 81
						-- upvalues: hold (copy), u12 (ref), u11 (ref)
						if not hold.allowReleaseAfterHold then
							u12 = false
						end

						hold.onComplete()

						if u11 then
							u11:Disconnect()
							u11 = nil
						end
					end)
					u11 = if not hold.onStep then nil else Heartbeat:Connect(hold.onStep)
				end
			end

			if v16 then
				if u10 then
					u10.cancel()
					u10 = nil
				end

				if u11 then
					u11:Disconnect()
					u11 = nil
				end

				u12 = false
			else
				u12 = true
			end
		end

		if v17 == Enum.UserInputState.End then
			if t1.onRelease and u12 then
				t1.onRelease(p3)
			end

			if u10 then
				u10.cancel()
				u10 = nil
			end

			if u11 then
				u11:Disconnect()
				u11 = nil
			end

			u12 = false
		end

		if v17 == Enum.UserInputState.Cancel then
			if u10 then
				u10.cancel()
				u10 = nil
			end

			if u11 then
				u11:Disconnect()
				u11 = nil
			end

			u12 = false
		end
	end
end

return handleInput
