local CorePackages = game:GetService("CorePackages")
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize

return function(vector2: Vector2, t1: {[any]: any}) -- line: 8
	-- upvalues: getSafeAreaSize (copy)
	return (math.min(getSafeAreaSize(vector2, t1).X.Offset, 640))
end
