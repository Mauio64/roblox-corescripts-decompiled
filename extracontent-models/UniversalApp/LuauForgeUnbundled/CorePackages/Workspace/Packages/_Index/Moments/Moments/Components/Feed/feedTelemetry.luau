require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

return {
	createNoopTelemetry = function()
		return {
			logView = function(p2, p3) end,
			logAction = function(p2, p3, p4): nil
				return nil
			end
		}
	end,
	createRecordingTelemetry = function()
		local v5 = {}
		local v6 = {}

		return {
			views = v5,
			actions = v6,
			logView = function(p2, p3)
				table.insert(v5, { attribution = p2, info = p3 })
			end,
			logAction = function(p2, p3, p4): nil
				table.insert(v6, { actionType = p2, attribution = p3, payload = p4 })

				return nil
			end
		}
	end
}
