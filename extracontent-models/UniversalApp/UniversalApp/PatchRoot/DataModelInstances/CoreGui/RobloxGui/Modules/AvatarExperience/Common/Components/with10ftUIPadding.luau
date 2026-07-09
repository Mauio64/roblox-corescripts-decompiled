local CorePackages = game:GetService("CorePackages")
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function with10ftUIPadding(p1) -- line: 17
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), Dash (copy)
	return function(p2) -- line: 18
		-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), p1 (copy), Dash (copy)
		local v12 = useDesignTokens(function(p3) -- line: 19
			-- upvalues: useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
			local v14 = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole
			local v15 = not v14 and 0 or if not FFlagRenameDeprecatedUIBloxTokens then p3.Global.Space_500 else p3.Size.Size_1000
			local v16 = not v14 and 0 or if not FFlagRenameDeprecatedUIBloxTokens then p3.Global.Space_800 else p3.Size.Size_1600
			local v17 = not v14 and 0 or -(v15 + if not FFlagRenameDeprecatedUIBloxTokens then p3.Global.Space_500 else p3.Size.Size_1000)
			local v18 = not v14 and 0 or -2 * v16

			return {
				topPadding = v15,
				leftPadding = v16,
				bottomPadding = v17,
				rightPadding = v18
			}
		end)

		return React.createElement(p1, Dash.join(p2, {
			designTokens = v12
		}))
	end
end

return with10ftUIPadding
