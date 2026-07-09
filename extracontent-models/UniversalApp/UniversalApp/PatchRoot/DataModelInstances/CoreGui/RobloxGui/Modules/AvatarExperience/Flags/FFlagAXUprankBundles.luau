local CorePackages = game:GetService("CorePackages")
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag

game:DefineFastFlag("AXUprankBundles", false)

return function() -- line: 7
	-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
	return FFlagAXRootSlotBasedEditorFlag and game:GetFastFlag("AXUprankBundles")
end
