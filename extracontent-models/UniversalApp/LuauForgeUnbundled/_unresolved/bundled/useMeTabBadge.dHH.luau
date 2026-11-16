local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dHI")

local function getStorageItem(p2)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p2)
	end)

	if success then
		return result
	end

	return ""
end

local function setStorageItem(p2, p3)
	pcall(function()
		AppStorageService:SetItem(p2, p3)
		AppStorageService:Flush()
	end)
end

local function useMeTabBadge()
	local state, setState = React.useState(function(): boolean
		local v5 = "MeTabBadgeDismissed"
		local success, result = pcall(function()
			return AppStorageService:GetItem(v5)
		end)

		if (not success and "" or result) == "1" then
			return false
		end

		local v6 = "MeTabBadgeSessionCount"
		local success2, result2 = pcall(function()
			return AppStorageService:GetItem(v6)
		end)

		return not (module <= (tonumber(not success2 and "" or result2) or 0))
	end)

	React.useEffect(function()
		local v5 = "MeTabBadgeDismissed"
		local success, result = pcall(function()
			return AppStorageService:GetItem(v5)
		end)

		if (not success and "" or result) == "1" then
			return
		end

		local v6 = "MeTabBadgeSessionCount"
		local success2, result2 = pcall(function()
			return AppStorageService:GetItem(v6)
		end)

		local v7 = tonumber(not success2 and "" or result2) or 0

		if module <= v7 then
			local v8 = "MeTabBadgeDismissed"
			local v9 = "1"
			pcall(function()
				AppStorageService:SetItem(v8, v9)
				AppStorageService:Flush()
			end)
		else
			local v8 = tostring(v7 + 1)
			local v9 = "MeTabBadgeSessionCount"
			pcall(function()
				AppStorageService:SetItem(v9, v8)
				AppStorageService:Flush()
			end)
		end
	end, {})

	return {
		showBadge = state,
		dismiss = React.useCallback(function()
			if not state then
				return
			end

			local v5 = "MeTabBadgeDismissed"
			local v6 = "1"
			pcall(function()
				AppStorageService:SetItem(v5, v6)
				AppStorageService:Flush()
			end)

			setState(false)
		end, { state })
	}
end

return useMeTabBadge
