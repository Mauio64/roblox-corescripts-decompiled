local NotificationsUpsellConstants = require(script.Parent.Parent.NotificationsUpsellConstants)

return {
	getPushUpsellPromptedCount = function(p1, s1: string) -- line: 5
		local ok, result = pcall(function() -- line: 6
			-- upvalues: p1 (copy), s1 (copy)
			return p1:GetItem(s1)
		end)

		if ok then
			local num = tonumber(result)

			if num ~= nil then
				return num
			end

			return 0
		end

		return -1
	end,
	getPushSysUpsellPromptTimestamp = function(p2) -- line: 23
		-- upvalues: NotificationsUpsellConstants (copy)
		local ok, result = pcall(function() -- line: 24
			-- upvalues: p2 (copy), NotificationsUpsellConstants (copy)
			return p2:GetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp)
		end)

		if ok then
			local num = tonumber(result)

			if num ~= nil then
				return num
			end

			return 0
		end

		return -1
	end,
	getPushEduUpsellResponseTimestamp = function(p3) -- line: 41
		-- upvalues: NotificationsUpsellConstants (copy)
		local ok, result = pcall(function() -- line: 42
			-- upvalues: p3 (copy), NotificationsUpsellConstants (copy)
			return p3:GetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp)
		end)

		if ok then
			local num = tonumber(result)

			if num ~= nil then
				return num
			end

			return 0
		end

		return -1
	end,
	incrementPushUpsellPromptedCount = function(p4, s2: string) -- line: 59
		local ok, result = pcall(function() -- line: 60
			-- upvalues: p4 (copy), s2 (copy)
			return p4:GetItem(s2)
		end)

		if ok then
			local v19 = tonumber(result) or 0

			pcall(function() -- line: 66
				-- upvalues: p4 (copy), s2 (copy), v19 (copy)
				p4:SetItem(s2, (tostring(v19 + 1)))
				p4:Flush()
			end)
		end
	end,
	setPushSysUpsellPromptTimestamp = function(p5, n1: number) -- line: 73
		-- upvalues: NotificationsUpsellConstants (copy)
		pcall(function() -- line: 74
			-- upvalues: p5 (copy), NotificationsUpsellConstants (copy), n1 (copy)
			p5:SetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp, (tostring(n1)))
			p5:Flush()
		end)
	end,
	setPushEduUpsellResponseTimestamp = function(p6, n2: number) -- line: 83
		-- upvalues: NotificationsUpsellConstants (copy)
		pcall(function() -- line: 84
			-- upvalues: p6 (copy), NotificationsUpsellConstants (copy), n2 (copy)
			p6:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp, (tostring(n2)))
			p6:Flush()
		end)
	end,
	setPushEduUpsellResponse = function(p7, s3: string) -- line: 93
		-- upvalues: NotificationsUpsellConstants (copy)
		pcall(function() -- line: 94
			-- upvalues: p7 (copy), NotificationsUpsellConstants (copy), s3 (copy)
			p7:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponse, s3)
			p7:Flush()
		end)
	end
}
