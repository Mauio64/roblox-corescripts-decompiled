local parent = script.Parent
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

return { ReloadPage = Signal.new(), ReportMutedError = Signal.new() }
