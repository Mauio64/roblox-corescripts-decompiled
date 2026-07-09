local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local getUniverseId = require(InExperienceSideSheet.Utils.getUniverseId)
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize

local function useExperienceIcon() -- line: 13
	-- upvalues: getUniverseId (copy), React (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
	local v10 = getUniverseId()

	return React.useMemo(function() -- line: 16
		-- upvalues: v10 (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy)
		if not v10 then
			return nil
		end

		return getRbxThumb(ThumbnailType.GameIcon, v10, ThumbnailSize.Small)
	end, { v10 })
end

return useExperienceIcon
