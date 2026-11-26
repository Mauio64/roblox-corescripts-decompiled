local CorePackages = game:GetService("CorePackages")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local splitPaneStore = require("@luauforge/bundled/dIW").SplitPaneStore

local module = require("@luauforge/bundled/ieI")
local module2 = require("@luauforge/bundled/ieJ")

local function useThemeBackgroundSplitPaneClip()
	return module2(
		SignalsReact.useSignalState(splitPaneStore.getStore().getSupportPaneModeIfActive),
		(SignalsReact.useSignalState(module.getContentRegionRect))
	)
end

return useThemeBackgroundSplitPaneClip
