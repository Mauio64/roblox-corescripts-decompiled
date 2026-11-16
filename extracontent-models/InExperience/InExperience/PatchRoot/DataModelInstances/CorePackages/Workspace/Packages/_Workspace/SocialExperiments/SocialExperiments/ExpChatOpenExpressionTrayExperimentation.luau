local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatOpenExpressionTrayExperimentLayer",
	"UniverseChat.OpenExpressionTray"
)

local flag = false

return {
	logExposure = function()
		if flag then
			return
		end

		flag = true

		pcall(function()
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end)
	end
}
