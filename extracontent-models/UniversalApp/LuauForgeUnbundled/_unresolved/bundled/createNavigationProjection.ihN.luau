local function createNavigationProjection(data, p2)
	return {
		containerProps = {
			onNavigationStateChange = function(p3, p4, p5)
				data.update(p4)

				if p2.onStateChange then
					p2.onStateChange(p4)
				end
			end,
			externalDispatchConnector = function(p3)
				data.setDispatch(p3)
				return function()
					data.clearDispatch()
				end
			end
		}
	}
end

return createNavigationProjection
