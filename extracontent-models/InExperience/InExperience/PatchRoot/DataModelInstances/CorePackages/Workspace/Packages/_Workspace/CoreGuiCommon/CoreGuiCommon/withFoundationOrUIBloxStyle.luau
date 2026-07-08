local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Foundation = require(ParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local withStyle = require(ParentParent.UIBlox).Style.withStyle
local FFlagCoreUiMigrateUIBloxToFoundation = require(ParentParent.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation

local function FoundationStyleAdapter(p1) -- line: 15
	-- upvalues: useTokens (copy), usePreferences (copy)
	local v11 = useTokens()
	local v12 = usePreferences()
	local v13 = p1.tokenMapper(v11, v12)

	return p1.renderContent(v13)
end
local function withFoundationOrUIBloxStyle(p2, p3) -- line: 22
	-- upvalues: FFlagCoreUiMigrateUIBloxToFoundation (copy), Roact (copy), FoundationStyleAdapter (copy), withStyle (copy)
	if FFlagCoreUiMigrateUIBloxToFoundation then
		return Roact.createElement(FoundationStyleAdapter, {
			tokenMapper = p2,
			renderContent = p3
		})
	end

	return withStyle(function(p4) -- line: 29
		-- upvalues: p3 (copy)
		return p3(p4)
	end)
end

return withFoundationOrUIBloxStyle
