local Squads = script:FindFirstAncestor("Squads")

require(Squads.Common.ModelTypes)

local SquadVoiceAbuseReport = require(script.Parent.SquadVoiceAbuseReport)
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation

local function SquadVoiceAbuseReportScreen(p1) -- line: 12
	-- upvalues: React (copy), Foundation (copy), SquadVoiceAbuseReport (copy)
	local navigation = p1.navigation
	local v9 = navigation.getParam("reportData", nil)

	assert(v9 ~= nil, "SquadVoiceAbuseReportScreen requires reportData to be passed in")

	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		padding = UDim.new(0, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		sizeConstraint = {
			MaxSize = Vector2.new(800, 450)
		}
	}, {
		abuseReportFlow = React.createElement(SquadVoiceAbuseReport, {
			reportData = v9,
			onAbandon = navigation.pop,
			onComplete = navigation.pop
		})
	})
end

return SquadVoiceAbuseReportScreen
