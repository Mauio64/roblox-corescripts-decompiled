local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PlayWithRewardState").Parent
local mutedError = require(Parent.Loggers).mutedError
local t = require(Parent.t)
local FFlagLuaAppEnableContainedRewardUi = require(script.Parent.FFlagLuaAppEnableContainedRewardUi)
local v6 = t.interface({
	titleText = t.string,
	subtitleText = t.string,
	buttonText = t.string,
	coachmarkTitleText = t.string,
	coachmarkSubtitleText = t.string,
	showButton = t.boolean,
	variantId = t.string,
	keepRewardContained = if not FFlagLuaAppEnableContainedRewardUi then nil else t.optional(t.boolean)
})
local t1 = {}
local t2 = {
	titleText = "",
	subtitleText = "",
	buttonText = "",
	coachmarkTitleText = "",
	coachmarkSubtitleText = "",
	showButton = false,
	variantId = "",
	keepRewardContained = not FFlagLuaAppEnableContainedRewardUi and nil
}

function t1.fromJsonData(s1: string) -- line: 44
	-- upvalues: t2 (copy), HttpService (copy), v6 (copy), mutedError (copy), FFlagLuaAppEnableContainedRewardUi (copy)
	local v10 = table.clone(t2)
	local ok, result = pcall(function() -- line: 47
		-- upvalues: HttpService (copy), s1 (copy)
		return HttpService:JSONDecode(s1)
	end)

	if ok then
		local v13, v14 = v6(result)

		if not v13 then
			mutedError(`PlayWithRewardExperimentData invalid: { tostring(v14) }`)

			return v10
		end

		v10.titleText = result.titleText
		v10.subtitleText = result.subtitleText
		v10.buttonText = result.buttonText
		v10.coachmarkTitleText = result.coachmarkTitleText
		v10.coachmarkSubtitleText = result.coachmarkSubtitleText
		v10.showButton = result.showButton
		v10.variantId = result.variantId

		if FFlagLuaAppEnableContainedRewardUi then
			v10.keepRewardContained = result.keepRewardContained or false
		end
	end

	return v10
end

return t1
