local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

return function(p, data)
	local extended = roact.PureComponent:extend("LoadingTimer")

	function extended:init()
		self.loadingTime = { startTime = nil, endTime = nil, thresholdCanceled = false }

		function self.startThresholdTimer()
			if not data.loadingThreshold then
				return
			end

			delay(data.loadingThreshold, function()
				if
					data.onReachingThreshold
					and not self.thresholdCanceled
					and not self.loadingTime.endTime
					and self.loadingTime.startTime
				then
					self.stopTimer(true)
					data.onReachingThreshold(self.getLoadingTime(), self.props)
				end
			end)
		end

		function self.resetTimer()
			self.loadingTime = { startTime = nil, endTime = nil }
		end

		function self.startTimer()
			self.loadingTime.startTime = os.clock()

			self.startThresholdTimer()
		end

		function self.stopTimer(p2)
			if self.loadingTime.endTime then
				return
			end

			self.loadingTime.endTime = os.clock()

			if data.onLoaded and not p2 then
				data.onLoaded(self.getLoadingTime(), self.props)
			end
		end

		function self.getLoadingTime()
			if self.loadingTime.endTime and self.loadingTime.startTime then
				return self.loadingTime.endTime - self.loadingTime.startTime
			end

			return -1
		end

		function self.cancelThreshold()
			self.thresholdCanceled = true
		end
	end

	function extended.render(props)
		return roact.createElement(p, llama.Dictionary.join(props.props, {
			loadingTimerProps = {
				startTimer = props.startTimer,
				stopTimer = props.stopTimer,
				resetTimer = props.resetTimer,
				getLoadingTime = props.getLoadingTime,
				cancelThreshold = props.cancelThreshold
			}
		}))
	end

	return extended
end
