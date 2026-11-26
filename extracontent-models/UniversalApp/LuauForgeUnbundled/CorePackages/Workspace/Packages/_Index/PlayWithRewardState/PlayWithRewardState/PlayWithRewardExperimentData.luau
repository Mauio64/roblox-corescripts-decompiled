local HttpService = game:GetService("HttpService")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardState/Loggers").mutedError
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardState/t")

local FFlagLuaAppEnableContainedRewardUi = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardState/PlayWithRewardState/FFlagLuaAppEnableContainedRewardUi")

local interface = t.interface
local v5 = {
	titleText = t.string,
	subtitleText = t.string,
	buttonText = t.string,
	coachmarkTitleText = t.string,
	coachmarkSubtitleText = t.string,
	showButton = t.boolean,
	variantId = t.string,
	keepRewardContained = 0
}
local v6 = if FFlagLuaAppEnableContainedRewardUi then t.optional(t.boolean) else nil
v5.keepRewardContained = v6
local v7 = interface(v5)

local v9 = {
	titleText = "",
	subtitleText = "",
	buttonText = "",
	coachmarkTitleText = "",
	coachmarkSubtitleText = "",
	showButton = false,
	variantId = "",
	keepRewardContained = if FFlagLuaAppEnableContainedRewardUi then false else nil
}
return {
	fromJsonData = function(json)
		local clone = table.clone(v9)

		local success, result = pcall(function()
			return HttpService:JSONDecode(json)
		end)

		if not success then
			return clone
		end

		local v11, v12 = v7(result)

		if not v11 then
			mutedError(`PlayWithRewardExperimentData invalid: {tostring(v12)}`)
			return clone
		end

		clone.titleText = result.titleText
		clone.subtitleText = result.subtitleText
		clone.buttonText = result.buttonText
		clone.coachmarkTitleText = result.coachmarkTitleText
		clone.coachmarkSubtitleText = result.coachmarkSubtitleText
		clone.showButton = result.showButton
		clone.variantId = result.variantId

		if FFlagLuaAppEnableContainedRewardUi then
			clone.keepRewardContained = result.keepRewardContained or false
		end

		return clone
	end
}
