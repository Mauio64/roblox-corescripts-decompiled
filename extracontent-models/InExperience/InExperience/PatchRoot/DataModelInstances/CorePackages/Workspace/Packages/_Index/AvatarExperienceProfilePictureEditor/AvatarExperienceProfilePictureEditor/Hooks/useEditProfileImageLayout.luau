local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local Constants = require(AvatarExperienceProfilePictureEditor.Constants)
local computeCutoutFieldOfViewDeg = require(AvatarExperienceProfilePictureEditor.Shared.computeCutoutFieldOfViewDeg)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useScreenSize = RobloxAppHooks.useScreenSize
local SharedFlags = require(parent.SharedFlags)
local FFlagSplitPaneProfileEditFillPane = SharedFlags.FFlagSplitPaneProfileEditFillPane

local function computeVisiblePeekabooPreviewHeight(p: number, p2: number) -- 1 equivalent call inferred from this helper
	return p + p2 + Constants.StackedPreviewBottomMargin
end

local function computeEditProfileImageLayout(data)
	local mode = data.deviceOrientation == "Landscape" and "split" or "stacked"
	local safeWidth = data.screenSize.X - data.guiInset.left - data.guiInset.right
	local v = data.screenSize.Y - data.guiInset.top - data.guiInset.bottom

	local previewWidth = safeWidth - (mode ~= "split" and 0 or math.floor(safeWidth * Constants.SplitControlsPaneWidthScale + 0.5))
	local v2 = math.floor(math.min(previewWidth * (2 / 3), v * 0.375) + 0.5)
	local v3 = mode == "split" and 72 or 36
	local v4 = data.guiInset.top + v3
	local closeButtonTopOffset = data.guiInset.top + 12
	local visiblePreviewHeight

	if mode == "split" then
		visiblePreviewHeight = v
	else
		visiblePreviewHeight = computeVisiblePeekabooPreviewHeight(v4, v2) -- inferred equivalent call
	end

	return {
		mode = mode,
		safeWidth = safeWidth,
		previewWidth = previewWidth,
		previewHeight = v,
		visiblePreviewHeight = visiblePreviewHeight,
		cutoutSize = v2,
		cutoutTopOffset = v4,
		closeButtonTopOffset = closeButtonTopOffset,
		cutoutFieldOfViewDeg = computeCutoutFieldOfViewDeg({
			viewportHeightPix = v,
			cutoutTopOffsetPix = v4,
			cutoutDiameterPix = v2
		})
	}
end

return {
	useEditProfileImageLayout = function(p)
		local deviceOrientation = useDeviceOrientation()
		local screenSize = useScreenSize()

		if not FFlagSplitPaneProfileEditFillPane then
			return computeEditProfileImageLayout({
				guiInset = p.guiInset,
				deviceOrientation = deviceOrientation,
				screenSize = screenSize
			})
		end

		local containerSize = p.containerSize

		if containerSize then
			deviceOrientation = containerSize.X > containerSize.Y and "Landscape" or nil
		end

		return computeEditProfileImageLayout({
			guiInset = p.guiInset,
			deviceOrientation = deviceOrientation,
			screenSize = containerSize or screenSize
		})
	end,
	computeEditProfileImageLayout = computeEditProfileImageLayout
}
