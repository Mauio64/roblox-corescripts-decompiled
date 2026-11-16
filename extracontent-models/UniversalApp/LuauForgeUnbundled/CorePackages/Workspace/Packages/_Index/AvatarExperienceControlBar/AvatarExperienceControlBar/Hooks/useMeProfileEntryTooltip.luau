local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")

local flag = false

local function useMeProfileEntryTooltip(p2, p3)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not p2 then
			setState(nil)
			return
		end

		if flag then
			setState(nil)
			return
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem("MeProfileEntryTooltipShown")
		end)
		local v6 = if not success or result ~= "1" then p3 else nil
		setState(v6)
	end, { p2, p3 })

	local v5 = React.useCallback(function()
		if flag then
			return
		end

		flag = true
		pcall(function()
			AppStorageService:SetItem("MeProfileEntryTooltipShown", "1")
			AppStorageService:Flush()
		end)
	end, {})

	local v6 = if p2 then not (p3 == nil) and state == p3 else p2
	return {
		showTooltip = v6,
		onShown = v5,
		dismiss = React.useCallback(function()
			if v6 then
				v5()
			end

			setState(nil)
		end, { v6, v5 })
	}
end

return useMeProfileEntryTooltip
