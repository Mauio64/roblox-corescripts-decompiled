local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("PlayWithRewardState").Parent
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local t = require(parent.t)

local FFlagLuaAppEnableContainedRewardUi = require(script.Parent.FFlagLuaAppEnableContainedRewardUi)

local interface = t.interface
local v = {
	titleText = t.string,
	subtitleText = t.string,
	buttonText = t.string,
	coachmarkTitleText = t.string,
	coachmarkSubtitleText = t.string,
	showButton = t.boolean,
	variantId = t.string,
	keepRewardContained = 0
}
local keepRewardContained

if FFlagLuaAppEnableContainedRewardUi then
	keepRewardContained = t.optional(t.boolean)
end

v.keepRewardContained = keepRewardContained
local v2 = interface(v)

local v3 = {
	titleText = "",
	subtitleText = "",
	buttonText = "",
	coachmarkTitleText = "",
	coachmarkSubtitleText = "",
	showButton = false,
	variantId = "",
	keepRewardContained = not FFlagLuaAppEnableContainedRewardUi and nil
}
return {
	fromJsonData = function(json: string)
		local clone = table.clone(v3)

		local success, result = pcall(function()
			return HttpService:JSONDecode(json)
		end)

		if not success then
			return clone
		end

		local v4, v5 = v2(result)

		if not v4 then
			mutedError(`PlayWithRewardExperimentData invalid: {tostring(v5)}`)
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
