local scriptParent = script.Parent
local Signal = require(scriptParent.AppCommonLib).Signal

return {
	ReloadPage = Signal.new(),
	ReportMutedError = Signal.new()
}
