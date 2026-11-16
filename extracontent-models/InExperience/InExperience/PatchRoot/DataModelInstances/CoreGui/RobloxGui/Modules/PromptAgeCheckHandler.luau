local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local FFlagPioneerLeaveOnInExpFaeDownAge = SharedFlags.FFlagPioneerLeaveOnInExpFaeDownAge

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Logging = AppCommonLib.Logging

local maybeLeavePioneerOnFaeDownAge = require(CorePackages.Workspace.Packages.PioneerUtils.maybeLeavePioneerOnFaeDownAge)

local function onPromptAgeCheckRequested(p)
	local localPlayer = Players.LocalPlayer

	if p ~= localPlayer then
		return
	end

	local success, ampUpsell = pcall(require, CorePackages.Workspace.Packages.AmpUpsell)

	if not (success and ampUpsell and ampUpsell.InExpAmpWizardController) then
		return
	end

	local success2, apolloClient = pcall(require, CoreGui.RobloxGui.Modules.ApolloClient)

	if success2 and apolloClient then
		ampUpsell.InExpAmpWizardController.OpenAmpWizardContainerInExp(
			FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			function(p2, p3)
				local function notifyIfGranted() -- 1 equivalent call inferred from this helper
					if p2 == "Granted" then
						local success3, result = pcall(function()
							localPlayer:NotifyAgeCheckPassed()
						end)

						if not success3 then
							Logging.warn("PromptAgeCheckRequested: NotifyAgeCheckPassed failed: " .. tostring(result))
						end
					end
				end

				if FFlagPioneerLeaveOnInExpFaeDownAge then
					local ampEnums = ampUpsell.AmpEnums

					maybeLeavePioneerOnFaeDownAge(
						p3 ~= nil and p3[ampEnums.ActionTypeEnum.AgeEstimation] == ampEnums.ActionStatusEnum.Success,
						notifyIfGranted
					)
				else
					notifyIfGranted() -- inferred equivalent call
				end
			end,
			nil,
			"PromptAgeCheckRequested",
			nil,
			FStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			apolloClient
		)
	end
end

return {
	init = function()
		Players.PromptAgeCheckRequested:Connect(onPromptAgeCheckRequested)
	end
}
