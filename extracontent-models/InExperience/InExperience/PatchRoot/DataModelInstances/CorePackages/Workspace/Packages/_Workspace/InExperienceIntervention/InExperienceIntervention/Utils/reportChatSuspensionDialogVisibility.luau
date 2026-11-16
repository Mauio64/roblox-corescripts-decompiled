local engineFeature = game:GetEngineFeature("SSUIMetaLua")

local function reportChatSuspensionDialogVisibility(flag: boolean)
	if engineFeature then
		pcall(function()
			local SafetyService = game:GetService("SafetyService")

			if flag then
				SafetyService:ReportChatSuspensionDialogOpen()
			else
				SafetyService:ReportChatSuspensionDialogClose()
			end
		end)
	end
end

return reportChatSuspensionDialogVisibility
