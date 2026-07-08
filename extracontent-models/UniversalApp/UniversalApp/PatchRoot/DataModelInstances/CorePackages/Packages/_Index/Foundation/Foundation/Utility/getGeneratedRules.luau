local Foundation = script:FindFirstAncestor("Foundation")
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local Theme = require(Foundation.Enums.Theme)
local t1 = {
	Common = function() -- line: 11
		-- upvalues: Foundation (copy)
		return require(Foundation.Generated.StyleRules.CommonAttribute)
	end,
	Dark = function() -- line: 14
		-- upvalues: Foundation (copy)
		return require(Foundation.Generated.StyleRules.DarkAttribute)
	end,
	Light = function() -- line: 17
		-- upvalues: Foundation (copy)
		return require(Foundation.Generated.StyleRules.LightAttribute)
	end,
	Console = function() -- line: 20
		-- upvalues: Foundation (copy)
		return require(Foundation.Generated.StyleRules.ConsoleAttribute)
	end,
	Desktop = function() -- line: 23
		-- upvalues: Foundation (copy)
		return require(Foundation.Generated.StyleRules.DesktopAttribute)
	end
}

local function getGeneratedRules(p1, p2) -- line: 28
	-- upvalues: t1 (copy), Theme (copy), Device (copy), Flags (copy)
	local v9 = nil
	local v10 = t1.Common()

	if p1 == Theme.Dark then
		v9 = t1.Dark()
	elseif p1 == Theme.Light then
		v9 = t1.Light()
	end

	local v11 = if p2 ~= Device.Console or Flags.FoundationDisableTokenScaling then t1.Desktop() else t1.Console()

	if not v9 or not v11 or not v10 then
		return {}
	end

	local v12 = table.clone(v11)

	for v13, v14 in v10 do
		v12[v13] = v14
	end

	for v15, v16 in v9 do
		v12[v15] = v16
	end

	return v12
end

return getGeneratedRules
