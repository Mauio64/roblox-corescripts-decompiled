local parent = script:FindFirstAncestor("ShareSheet").Parent

local v = game:DefineFastFlag("ShareSheetDesktopReadiness3", false)

if not v then
	return v
end

local SharedFlags = require(parent.SharedFlags)
v = SharedFlags.FFlagAppCompositionContainerWidth and require(script.Parent.FFlagShareSheetOmitsEmptyActions)

if v then
	local Foundation = require(parent.Foundation)
	return Foundation.Utility.Flags.FoundationBottomSheetClearsActionsHeight
end

return v
