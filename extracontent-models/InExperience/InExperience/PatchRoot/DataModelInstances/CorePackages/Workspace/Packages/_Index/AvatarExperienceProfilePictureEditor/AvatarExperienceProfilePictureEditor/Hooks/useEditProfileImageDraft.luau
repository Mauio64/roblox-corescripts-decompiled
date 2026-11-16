local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled
local React = require(parent.React)
require(AvatarExperienceProfilePictureEditor.Hooks.useUserAvatarConfigurations)

local Constants = require(AvatarExperienceProfilePictureEditor.Constants)

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

	local resetFromSavedConfig = React.useCallback(function()
		if isSavedConfigLoading then
			return
		end

		setState(savedCloseupConfig.emoteAssetId)
		setState3(savedCloseupConfig.yRotDeg)
		setState4(savedCloseupConfig.distanceScale)

		if FFlagEditProfileFramesEnabled and showFrames then
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
		local v

		if initialFrameSelectionRequestId == nil then
			v = false
		else
			v = initialFrameSelectionRequestId ~= ref3.current
		end

		if
			not FFlagEditProfileFramesEnabled
			or not showFrames
			or ref2.current and not v
			or isSavedConfigLoading
			or isInitialFrameSelectionLoading
		then
			return
		end

		ref2.current = true
		ref3.current = initialFrameSelectionRequestId
		local v2

		if initialFrameAssetId == nil or not isInitialFrameAvailable then
			v2 = savedFrameAssetId or Constants.ProfileFrameNoneId
		else
			v2 = initialFrameAssetId
		end

		setState2(v2)
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
		onSelectEmote = React.useCallback(function(p: string)
			setState(function(p2)
				return if p2 ~= p then p else nil
			end)
		end, {}),
		onSelectFrame = React.useCallback(function(p: string)
			setState2(function(p2)
				if p2 == p then
					return Constants.ProfileFrameNoneId
				end

				return p
			end)
		end, {}),
		onYRotDegChanged = setState3,
		onDistanceScaleChanged = setState4,
		clearSelectedEmote = React.useCallback(function()
			setState(nil)
		end, {}),
		resetFromSavedConfig = resetFromSavedConfig
	}
end

return useEditProfileImageDraft
