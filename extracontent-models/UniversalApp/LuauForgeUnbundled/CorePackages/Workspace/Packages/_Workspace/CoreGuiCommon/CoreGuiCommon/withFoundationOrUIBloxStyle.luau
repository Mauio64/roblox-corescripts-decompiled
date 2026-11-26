local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Foundation")
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/UIBlox").Style.withStyle

local fFlagCoreUiMigrateUIBloxToFoundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/SharedFlags").FFlagCoreUiMigrateUIBloxToFoundation

local function FoundationStyleAdapter(p2)
	local v5 = useTokens()
	local v6 = usePreferences()
	local tokenMapper = p2.tokenMapper(v5, v6)
	return p2.renderContent(tokenMapper)
end

local function withFoundationOrUIBloxStyle(p2, callback)
	if fFlagCoreUiMigrateUIBloxToFoundation then
		return Roact.createElement(FoundationStyleAdapter, {
			tokenMapper = p2,
			renderContent = callback
		})
	end

	return withStyle(function(p3)
		return callback(p3)
	end)
end

return withFoundationOrUIBloxStyle
