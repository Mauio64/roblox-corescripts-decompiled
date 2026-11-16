local AppStorageService = game:GetService("AppStorageService")

local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(parent.React)

local flag = false

local function useMeProfileEntryTooltip(flag2: boolean, p: string?)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not flag2 then
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
		local v

		if not (success and result == "1") then
			v = p
		end

		setState(v)
	end, { flag2, p })

	local onShown = React.useCallback(function()
		if flag then
			return
		end

		flag = true
		pcall(function()
			AppStorageService:SetItem("MeProfileEntryTooltipShown", "1")
			AppStorageService:Flush()
		end)
	end, {})
	local showTooltip

	if flag2 then
		if p == nil then
			showTooltip = false
		else
			showTooltip = state == p
		end
	else
		showTooltip = flag2
	end

	return {
		showTooltip = showTooltip,
		onShown = onShown,
		dismiss = React.useCallback(function()
			if showTooltip then
				onShown()
			end

			setState(nil)
		end, { showTooltip, onShown })
	}
end

return useMeProfileEntryTooltip
