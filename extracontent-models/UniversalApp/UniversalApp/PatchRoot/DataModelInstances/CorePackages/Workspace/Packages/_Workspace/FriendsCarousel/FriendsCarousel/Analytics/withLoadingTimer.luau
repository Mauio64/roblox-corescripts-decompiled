local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama

return function(p1, t1: {[any]: any}) -- line: 20
	-- upvalues: Roact (copy), llama (copy)
	local v7 = Roact.PureComponent:extend("LoadingTimer")

	function v7.init(p2) -- line: 24
		-- upvalues: t1 (copy)
		p2.loadingTime = {
			startTime = nil,
			endTime = nil,
			thresholdCanceled = false
		}

		function p2.startThresholdTimer() -- line: 31
			-- upvalues: t1 (copy), p2 (copy)
			if not t1.loadingThreshold then
				return
			end

			delay(t1.loadingThreshold, function() -- line: 36
				-- upvalues: t1 (copy), p2 (copy)
				if t1.onReachingThreshold and (not p2.thresholdCanceled and not p2.loadingTime.endTime and p2.loadingTime.startTime) then
					p2.stopTimer(true)
					t1.onReachingThreshold(p2.getLoadingTime(), p2.props)
				end
			end)
		end
		function p2.resetTimer() -- line: 49
			-- upvalues: p2 (copy)
			p2.loadingTime = {
				startTime = nil,
				endTime = nil
			}
		end
		function p2.startTimer() -- line: 56
			-- upvalues: p2 (copy)
			p2.loadingTime.startTime = os.clock()
			p2.startThresholdTimer()
		end
		function p2.stopTimer(p3) -- line: 62
			-- upvalues: p2 (copy), t1 (copy)
			if p2.loadingTime.endTime then
				return
			end

			p2.loadingTime.endTime = os.clock()

			if t1.onLoaded and not p3 then
				t1.onLoaded(p2.getLoadingTime(), p2.props)
			end
		end
		function p2.getLoadingTime() -- line: 74
			-- upvalues: p2 (copy)
			if p2.loadingTime.endTime and p2.loadingTime.startTime then
				return p2.loadingTime.endTime - p2.loadingTime.startTime
			end

			return -1
		end
		function p2.cancelThreshold() -- line: 82
			-- upvalues: p2 (copy)
			p2.thresholdCanceled = true
		end
	end
	function v7.render(p4) -- line: 87
		-- upvalues: Roact (copy), p1 (copy), llama (copy)
		return Roact.createElement(p1, llama.Dictionary.join(p4.props, {
			loadingTimerProps = {
				startTimer = p4.startTimer,
				stopTimer = p4.stopTimer,
				resetTimer = p4.resetTimer,
				getLoadingTime = p4.getLoadingTime,
				cancelThreshold = p4.cancelThreshold
			}
		}))
	end

	return v7
end
