local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local computeCutoutFieldOfViewDeg = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/computeCutoutFieldOfViewDeg")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RobloxAppHooks")
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useScreenSize = RobloxAppHooks.useScreenSize
local fFlagSplitPaneProfileEditFillPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagSplitPaneProfileEditFillPane

local function computeVisiblePeekabooPreviewHeight(p2, p3)
	return p2 + p3 + Constants.StackedPreviewBottomMargin
end

local function computeEditProfileImageLayout(data)
	local v5 = data.deviceOrientation == "Landscape" and "split" or "stacked"
	local v6 = data.screenSize.X - data.guiInset.left - data.guiInset.right
	local v7 = data.screenSize.Y - data.guiInset.top - data.guiInset.bottom

	local v8 = v6 - (v5 ~= "split" and 0 or math.floor(v6 * Constants.SplitControlsPaneWidthScale + 0.5))
	local v9 = math.floor(math.min(v8 * (2 / 3), v7 * 0.375) + 0.5)
	local v10 = v5 == "split" and 72 or 36
	local v11 = data.guiInset.top + v10
	local v12 = data.guiInset.top + 12
	local v13 = if v5 == "split" then v7 else v11 + v9 + Constants.StackedPreviewBottomMargin

	return {
		mode = v5,
		safeWidth = v6,
		previewWidth = v8,
		previewHeight = v7,
		visiblePreviewHeight = v13,
		cutoutSize = v9,
		cutoutTopOffset = v11,
		closeButtonTopOffset = v12,
		cutoutFieldOfViewDeg = computeCutoutFieldOfViewDeg({
			viewportHeightPix = v7,
			cutoutTopOffsetPix = v11,
			cutoutDiameterPix = v9
		})
	}
end

return {
	useEditProfileImageLayout = function(p2)
		local v5 = useDeviceOrientation()
		local v6 = useScreenSize()

		if not fFlagSplitPaneProfileEditFillPane then
			return computeEditProfileImageLayout({
				guiInset = p2.guiInset,
				deviceOrientation = v5,
				screenSize = v6
			})
		end

		local containerSize = p2.containerSize

		if containerSize then
			v5 = containerSize.X > containerSize.Y and "Landscape" or nil
		end

		return computeEditProfileImageLayout({
			guiInset = p2.guiInset,
			deviceOrientation = v5,
			screenSize = containerSize or v6
		})
	end,
	computeEditProfileImageLayout = computeEditProfileImageLayout
}
