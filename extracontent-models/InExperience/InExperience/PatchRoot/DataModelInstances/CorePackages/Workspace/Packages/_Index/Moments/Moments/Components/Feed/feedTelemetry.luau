require(script.Parent.FeedTypes)
local FeedTelemetry = {}

function FeedTelemetry.createNoopTelemetry()
	return {
		logView = function(_, _) end,
		logAction = function(_, _, _): nil
			return nil
		end
	}
end

function FeedTelemetry.createRecordingTelemetry()
	local views = {}
	local actions = {}

	return {
		views = views,
		actions = actions,
		logView = function(attribution, info)
			table.insert(views, { attribution = attribution, info = info })
		end,
		logAction = function(actionType, attribution, payload): nil
			table.insert(actions, {
				actionType = actionType,
				attribution = attribution,
				payload = payload
			})

			return nil
		end
	}
end

return FeedTelemetry
