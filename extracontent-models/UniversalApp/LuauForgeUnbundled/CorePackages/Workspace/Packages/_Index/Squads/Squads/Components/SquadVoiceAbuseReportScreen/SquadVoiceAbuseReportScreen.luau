local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local SquadVoiceAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadVoiceAbuseReportScreen/SquadVoiceAbuseReport")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local react = dependencies.React
local foundation = dependencies.Foundation

local function SquadVoiceAbuseReportScreen(p2)
	local navigation = p2.navigation
	local param = navigation.getParam("reportData", nil)
	assert(param ~= nil, "SquadVoiceAbuseReportScreen requires reportData to be passed in")

	return react.createElement(foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		padding = UDim.new(0, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		sizeConstraint = { MaxSize = Vector2.new(800, 450) },
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-voice-abuse-report-screen" or nil
	}, {
		abuseReportFlow = react.createElement(SquadVoiceAbuseReport, {
			reportData = param,
			onAbandon = navigation.pop,
			onComplete = navigation.pop
		})
	})
end

return SquadVoiceAbuseReportScreen
