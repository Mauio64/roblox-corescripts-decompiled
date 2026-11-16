local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)
local MockableProxyServices = require(parent.MockableProxyServices)

local function createSplitPanePreference()
	local appStorageService = MockableProxyServices.AppStorageService
	local signal, v = Signals.createSignal(nil)
	local flag = false
	local flag2 = false

	local function persist(flag3: boolean) -- 2 equivalent calls inferred from this helper
		pcall(function()
			appStorageService:SetItem("SplitPaneCollapsedPreference", (tostring(flag3)))
			appStorageService:Flush()
		end)
	end

	pcall(function()
		appStorageService:WhenLoaded(function()
			flag = true

			if flag2 then
				persist(signal(false)) -- inferred equivalent call
			else
				local success, result = pcall(function()
					return appStorageService:GetItem("SplitPaneCollapsedPreference")
				end)

				if success and (result == "true" or result == "false") then
					v(result == "true")
				end
			end
		end)
	end)

	return signal, function(flag3: boolean)
		flag2 = true
		v(flag3)

		if flag then
			persist(flag3) -- inferred equivalent call
		end
	end
end

return createSplitPanePreference
