local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local IconSize = require(Foundation.Enums.IconSize)

local Flags = require(Foundation.Utility.Flags)
local devAssert = require(Foundation.Utility.devAssert)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function isNumber(value): boolean -- 3 equivalent calls inferred from this helper
	if typeof(value) == "number" then
		return true
	elseif typeof(value) == "table" then
		return typeof(value:getValue()) == "number"
	else
		return false
	end
end

local function useIconSize(value, flag: boolean, flag2: boolean?)
	local v = useTokens()
	local v2

	if flag then
		v2 = {}
		local xSmall = IconSize.XSmall
		local v3 = if flag2 then v.Size.Size_400 else v.Size.Size_300
		v2[xSmall] = v3
		local small = IconSize.Small
		local v4 = if flag2 then v.Size.Size_500 else v.Size.Size_400
		v2[small] = v4
		local medium = IconSize.Medium
		local v5 = if flag2 then v.Size.Size_600 else v.Size.Size_500
		v2[medium] = v5
		local large = IconSize.Large
		local v6 = if flag2 then v.Size.Size_700 else v.Size.Size_600
		v2[large] = v6
		local xLarge = IconSize.XLarge
		local v7 = if flag2 then v.Size.Size_800 else v.Size.Size_700
		v2[xLarge] = v7
		local xxLarge = IconSize.XXLarge
		local v8 = if flag2 then v.Size.Size_900 else v.Size.Size_800
		v2[xxLarge] = v8
	else
		v2 = {}
		v2[IconSize.XSmall] = v.Size.Size_200
		v2[IconSize.Small] = v.Size.Size_400
		v2[IconSize.Medium] = v.Size.Size_900
		v2[IconSize.Large] = v.Size.Size_1200
		v2[IconSize.XLarge] = v.Size.Size_2400
		v2[IconSize.XXLarge] = 24 * v.Size.Size_200
	end

	local v3 = nil
	local v4

	if flag then
		if isNumber(value) then -- inferred equivalent call
			v3 = value
		else
			v4 = isNumber(value) -- inferred equivalent call

			if not v4 then
				v3 = v2[value]
			end
		end
	else
		v4 = isNumber(value) -- inferred equivalent call

		if not v4 then
			v3 = v2[value]
		end
	end

	if v3 == nil then
		if Flags.FoundationDevOnlyPropAsserts then
			devAssert(false, "Invalid icon size: " .. tostring(value))
			v3 = v2[IconSize.Medium]
		else
			error("Invalid icon size: " .. tostring(value))
		end
	end

	if typeof(v3) == "table" then
		return (v3:map(function(p)
			return UDim2.fromOffset(p, p)
		end))
	end

	return (UDim2.fromOffset(v3, v3))
end

return useIconSize
