local function fn() end

return {
	dumpInstanceTree = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/dumpInstanceTree"),
	idFor = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/idFor"),
	littleTraceback = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/littleTraceback"),
	logTreeGraphviz = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/logTreeGraphviz"),
	LogTree = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/LogTree"),
	register = function()
		return fn
	end
}
