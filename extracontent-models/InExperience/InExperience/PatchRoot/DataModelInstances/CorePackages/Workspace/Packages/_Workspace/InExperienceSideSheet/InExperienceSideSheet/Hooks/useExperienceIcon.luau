local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local getUniverseId = require(InExperienceSideSheet.Utils.getUniverseId)

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize

local function useExperienceIcon()
	local universeId = getUniverseId()

	return React.useMemo(function()
		if universeId then
			return getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Small)
		end

		return nil
	end, { universeId })
end

return useExperienceIcon
