require(script.Parent.FeedTypes)

return {
	createNoopTelemetry = function() -- line: 19
		return {
			logView = function(_, _) -- line: 21
			end,
			logAction = function(_, _, _: {[any]: any}) -- line: 22
				return nil
			end
		}
	end,
	createRecordingTelemetry = function() -- line: 56
		local t2 = {}
		local t3 = {}

		return {
			views = t2,
			actions = t3,
			logView = function(p5, p6) -- line: 63
				-- upvalues: t2 (copy)
				table.insert(t2, {
					attribution = p5,
					info = p6
				})
			end,
			logAction = function(p7, p8, t4: {[any]: any}) -- line: 66
				-- upvalues: t3 (copy)
				table.insert(t3, {
					actionType = p7,
					attribution = p8,
					payload = t4
				})

				return nil
			end
		}
	end
}
