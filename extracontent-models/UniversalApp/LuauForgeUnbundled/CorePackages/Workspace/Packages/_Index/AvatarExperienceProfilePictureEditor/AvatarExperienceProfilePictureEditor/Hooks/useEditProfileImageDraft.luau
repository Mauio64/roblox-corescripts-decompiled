local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileFramesEnabled
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useUserAvatarConfigurations")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")

local function useEditProfileImageDraft(data)
	local savedCloseupConfig = data.savedCloseupConfig
	local savedFrameAssetId = data.savedFrameAssetId
	local isSavedConfigLoading = data.isSavedConfigLoading
	local showFrames = data.showFrames
	local initialFrameAssetId = data.initialFrameAssetId
	local initialFrameSelectionRequestId = data.initialFrameSelectionRequestId
	local isInitialFrameSelectionLoading = data.isInitialFrameSelectionLoading
	local isInitialFrameAvailable = data.isInitialFrameAvailable

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(0)
	local state4, setState4 = React.useState(1)

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(nil)

	local v5 = React.useCallback(function()
		if isSavedConfigLoading then
			return
		end

		setState(savedCloseupConfig.emoteAssetId)
		setState3(savedCloseupConfig.yRotDeg)
		setState4(savedCloseupConfig.distanceScale)

		if fFlagEditProfileFramesEnabled and showFrames then
			setState2(savedFrameAssetId or Constants.ProfileFrameNoneId)
		else
			setState2(nil)
		end
	end, { savedCloseupConfig, savedFrameAssetId, isSavedConfigLoading, showFrames })

	React.useEffect(function()
		if ref.current or isSavedConfigLoading then
			return
		end

		ref.current = true

		if savedCloseupConfig.emoteAssetId then
			setState(savedCloseupConfig.emoteAssetId)
		end

		setState3(savedCloseupConfig.yRotDeg)
		setState4(savedCloseupConfig.distanceScale)
	end, {
		savedCloseupConfig.emoteAssetId,
		savedCloseupConfig.yRotDeg,
		savedCloseupConfig.distanceScale,
		isSavedConfigLoading
	})

	React.useEffect(function()
		local v6

		if initialFrameSelectionRequestId == nil then
			v6 = false
		else
			v6 = initialFrameSelectionRequestId ~= ref3.current
		end

		if
			not fFlagEditProfileFramesEnabled
			or not showFrames
			or ref2.current and not v6
			or isSavedConfigLoading
			or isInitialFrameSelectionLoading
		then
			return
		end

		ref2.current = true
		ref3.current = initialFrameSelectionRequestId

		local v8 = if initialFrameAssetId == nil or not isInitialFrameAvailable then savedFrameAssetId or Constants.ProfileFrameNoneId else initialFrameAssetId
		setState2(v8)
	end, {
		initialFrameAssetId,
		initialFrameSelectionRequestId,
		isInitialFrameSelectionLoading,
		isInitialFrameAvailable,
		savedFrameAssetId,
		isSavedConfigLoading,
		showFrames
	})

	return {
		selectedEmoteId = state,
		selectedFrameId = state2,
		yRotDeg = state3,
		distanceScale = state4,
		onSelectEmote = React.useCallback(function(p2)
			setState(function(p3)
				if p3 == p2 then
					return nil
				end

				return p2
			end)
		end, {}),
		onSelectFrame = React.useCallback(function(p2)
			setState2(function(p3)
				if p3 == p2 then
					return Constants.ProfileFrameNoneId
				end

				return p2
			end)
		end, {}),
		onYRotDegChanged = setState3,
		onDistanceScaleChanged = setState4,
		clearSelectedEmote = React.useCallback(function()
			setState(nil)
		end, {}),
		resetFromSavedConfig = v5
	}
end

return useEditProfileImageDraft
