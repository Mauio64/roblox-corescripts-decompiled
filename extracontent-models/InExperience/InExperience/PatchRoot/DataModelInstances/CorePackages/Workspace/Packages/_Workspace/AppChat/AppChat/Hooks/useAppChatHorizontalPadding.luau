local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FormFactor = require(AppChatParent.FormFactor).Enums.FormFactor
local Style = require(AppChatParent.Style)
local React = require(AppChatParent.React)
local Responsive = require(AppChatParent.Responsive)
local hasExtraPlatformInset = Responsive.HardwareSafeAreaInsets.hasExtraPlatformInset
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useMemo = React.useMemo
local usePreferredInput = Responsive.usePreferredInput
local useScreenSize = require(AppChatParent.RobloxAppHooks).useScreenSize
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector

local function getLegacySideMargin(n1: number, p1) -- line: 22
	if n1 < 1024 then
		return p1.Size.Size_300
	end

	if n1 < 1280 then
		return 18
	end

	if n1 < 1440 then
		return p1.Size.Size_600
	end

	if n1 < 1920 then
		return 34
	end

	if n1 < 2260 then
		return 38
	end

	return p1.Size.Size_1200
end
local function calculateSideMargin(p2, n2: number) -- line: 41
	-- upvalues: hasExtraPlatformInset (copy)
	if hasExtraPlatformInset() then
		return p2.Size.Size_1600
	end

	if n2 < 1024 then
		return p2.Size.Size_300
	end

	if n2 < 1280 then
		return 18
	end

	if n2 < 1440 then
		return p2.Size.Size_600
	end

	if n2 < 1920 then
		return 34
	end

	if n2 < 2260 then
		return 38
	end

	return p2.Size.Size_1200
end

return function(b1: boolean?) -- line: 50
	-- upvalues: useIsInExperience (copy), useScreenSize (copy), Style (copy), usePreferredInput (copy), Responsive (copy), useSelector (copy), useMemo (copy), hasExtraPlatformInset (copy), FormFactor (copy)
	local v20 = useIsInExperience() or b1
	local v21 = useScreenSize()
	local v22 = (not v21 or v21.X == nil) and 0 or v21.X
	local v23 = Style.useDesignTokens()
	local v24 = usePreferredInput() == Responsive.Input.Pointer
	local v25 = useSelector(function(p3) -- line: 60
		return p3.FormFactor
	end)

	return useMemo(function() -- line: 64
		-- upvalues: v20 (copy), v24 (copy), v23 (copy), v22 (copy), hasExtraPlatformInset (copy), v25 (copy), FormFactor (copy)
		if v20 then
			return {
				outer = 12,
				inner = 12,
				default = 12
			}
		end

		local v29

		if v24 then
			local v27 = v23
			local v28 = v22

			v29 = if not hasExtraPlatformInset() then if not (v28 < 1024) then if not (v28 < 1280) then if not (v28 < 1440) then if not (v28 < 1920) then if not (v28 < 2260) then v27.Size.Size_1200 else 38 else 34 else v27.Size.Size_600 else 18 else v27.Size.Size_300 else v27.Size.Size_1600
		else
			v29 = v25 ~= FormFactor.COMPACT and 48 or 24
		end

		return {
			default = 12,
			outer = v29,
			inner = v29
		}
	end, {
		v22,
		v24,
		v25,
		v20
	})
end
