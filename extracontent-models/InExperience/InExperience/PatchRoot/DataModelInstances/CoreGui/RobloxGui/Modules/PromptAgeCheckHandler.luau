local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t1 = {}

local function onPromptAgeCheckRequested(p1) -- line: 24
	-- upvalues: Players (copy), CorePackages (copy), CoreGui (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), Logging (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy)
	local LocalPlayer = Players.LocalPlayer

	if p1 ~= LocalPlayer then
		return
	end

	local ok, result = pcall(require, CorePackages.Workspace.Packages.AmpUpsell)

	if not ok or not result or not result.InExpAmpWizardController then
		return
	end

	local ok2, result2 = pcall(require, CoreGui.RobloxGui.Modules.ApolloClient)

	if not ok2 or not result2 then
		return
	end

	result.InExpAmpWizardController.OpenAmpWizardContainerInExp(FStringLuaAppPlayButtonAgeCheckAmpFeatureName, function(p2, _) -- line: 42
		-- upvalues: LocalPlayer (copy), Logging (copy)
		if p2 == "Granted" then
			local ok3, result3 = pcall(function() -- line: 44
				-- upvalues: LocalPlayer (copy)
				LocalPlayer:NotifyAgeCheckPassed()
			end)

			if not ok3 then
				Logging.warn("PromptAgeCheckRequested: NotifyAgeCheckPassed failed: " .. tostring(result3))
			end
		end
	end, nil, "PromptAgeCheckRequested", nil, FStringLuaAppPlayButtonAgeCheckAmpNameSpace, result2)
end

function t1.init() -- line: 62
	-- upvalues: Players (copy), onPromptAgeCheckRequested (copy)
	Players.PromptAgeCheckRequested:Connect(onPromptAgeCheckRequested)
end

return t1
