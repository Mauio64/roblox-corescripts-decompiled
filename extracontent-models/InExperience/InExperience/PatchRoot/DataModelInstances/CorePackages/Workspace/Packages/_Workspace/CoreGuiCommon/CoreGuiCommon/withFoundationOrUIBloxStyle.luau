local parent = script.Parent.Parent

local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local SharedFlags = require(parent.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local function FoundationStyleAdapter(p)
	local v = useTokens()
	local v2 = usePreferences()
	local tokenMapper = p.tokenMapper(v, v2)
	return p.renderContent(tokenMapper)
end

local function withFoundationOrUIBloxStyle(tokenMapper, renderContent)
	if FFlagCoreUiMigrateUIBloxToFoundation then
		return Roact.createElement(FoundationStyleAdapter, {
			tokenMapper = tokenMapper,
			renderContent = renderContent
		})
	end

	return withStyle(function(p)
		return renderContent(p)
	end)
end

return withFoundationOrUIBloxStyle
