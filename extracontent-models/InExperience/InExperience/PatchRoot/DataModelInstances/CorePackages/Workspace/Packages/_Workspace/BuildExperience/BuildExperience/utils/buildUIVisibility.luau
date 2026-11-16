local BuildExperience = script:FindFirstAncestor("BuildExperience")
local FFlagReportBuildUIVisibility = require(BuildExperience.Flags.FFlagReportBuildUIVisibility)

local engineFeature = game:GetEngineFeature("SSMetabuiLua")

local function getSafetyService()
	local success, result = pcall(function()
		return game:GetService("SafetyService")
	end)
	return if success then result else nil
end

local function createBuildUIVisibility(result)
	local openPanelCountForTests = 0

	return {
		acquire = function()
			openPanelCountForTests += 1

			if openPanelCountForTests ~= 1 or result == nil then
				return
			end

			pcall(function()
				result:ReportBuildUIOpen()
			end)
		end,
		release = function()
			if openPanelCountForTests == 0 then
				return
			end

			openPanelCountForTests -= 1

			if openPanelCountForTests ~= 0 or result == nil then
				return
			end

			pcall(function()
				result:ReportBuildUIClose()
			end)
		end,
		getOpenPanelCountForTests = function()
			return openPanelCountForTests
		end
	}
end

local result

if FFlagReportBuildUIVisibility and engineFeature then
	local success
	success, result = pcall(function()
		return game:GetService("SafetyService")
	end)

	if not success then
		result = nil
	end
end

local buildUIVisibility = createBuildUIVisibility(result)

return {
	acquire = buildUIVisibility.acquire,
	release = buildUIVisibility.release,
	getOpenPanelCountForTests = buildUIVisibility.getOpenPanelCountForTests,
	createForTests = createBuildUIVisibility
}
