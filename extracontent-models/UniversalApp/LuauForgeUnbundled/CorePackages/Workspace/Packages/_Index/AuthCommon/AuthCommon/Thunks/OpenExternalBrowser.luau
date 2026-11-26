local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")

return function(object, p2)
	ArgCheck.isNotNil(object, "linking")
	ArgCheck.isType(p2, "string", "url")

	object:openURL(p2)
end
