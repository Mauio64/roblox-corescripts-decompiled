local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")
local MockableProxyServices = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/MockableProxyServices")

local function createSplitPanePreference()
	local appStorageService = MockableProxyServices.AppStorageService
	local signal, v5 = Signals.createSignal(nil)
	local flag = false
	local flag2 = false

	local function persist(p2)
		pcall(function()
			appStorageService:SetItem("SplitPaneCollapsedPreference", (tostring(p2)))
			appStorageService:Flush()
		end)
	end

	pcall(function()
		appStorageService:WhenLoaded(function()
			flag = true

			if flag2 then
				local v6 = signal(false)
				pcall(function()
					appStorageService:SetItem("SplitPaneCollapsedPreference", (tostring(v6)))
					appStorageService:Flush()
				end)
			else
				local success, result = pcall(function()
					return appStorageService:GetItem("SplitPaneCollapsedPreference")
				end)

				if success and (result == "true" or result == "false") then
					v5(result == "true")
				end
			end
		end)
	end)

	return signal, function(p2)
		flag2 = true
		v5(p2)

		if flag then
			pcall(function()
				appStorageService:SetItem("SplitPaneCollapsedPreference", (tostring(p2)))
				appStorageService:Flush()
			end)
		end
	end
end

return createSplitPanePreference
