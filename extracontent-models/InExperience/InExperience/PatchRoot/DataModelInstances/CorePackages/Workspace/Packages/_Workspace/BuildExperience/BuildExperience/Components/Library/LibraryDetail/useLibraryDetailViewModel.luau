local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
local LibraryTypes = require(BuildExperience.Components.Library.LibraryTypes)
require(script.Parent.LibraryDetailView)
require(BuildExperience.Chat.chatTypes)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local function useLibraryDetailViewModel(data, p)
	local v

	if p == nil then
		v = UserInputService
	else
		v = p.userInputService
	end

	local v2

	if p == nil then
		v2 = GuiService
	else
		v2 = p.guiService
	end

	local isActive = data.isActive ~= false
	local v3 = data.chatActions ~= nil
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	React.useEffect(function()
		if not v3 then
			setState(0)
			return
		end

		local function updateKeyboardTop() -- 1 equivalent call inferred from this helper
			local guiInset = v2:GetGuiInset()
			setState(not v.OnScreenKeyboardVisible and 0 or math.max(0, v.OnScreenKeyboardPosition.Y - guiInset.Y))
		end

		updateKeyboardTop() -- inferred equivalent call
		local onScreenKeyboardVisibleChangedConnection = v:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(updateKeyboardTop)

		local onScreenKeyboardSizeChangedConnection = v:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(updateKeyboardTop)

		local onScreenKeyboardPositionChangedConnection = v:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(updateKeyboardTop)
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardSizeChangedConnection:Disconnect()
			onScreenKeyboardPositionChangedConnection:Disconnect()
		end
	end, { v3, v, v2 })
	local onPageMetricsChanged = React.useCallback(function(p2)
		setState2(p2.AbsolutePosition.Y + p2.AbsoluteSize.Y)
	end, {})

	local keyboardOverlap = (not v3 or state <= 0 or state2 <= 0) and 0 or math.max(0, state2 - state)

	local v4 = useLocalization({
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
		soundLabel = "Feature.Build.Label.Sounds"
	})

	local chatActions = data.chatActions

	if chatActions ~= nil and (chatActions.placeholder == nil or chatActions.placeholder == "") then
		chatActions = table.clone(chatActions)
		chatActions.placeholder = v4.composerPlaceholder
	end

	local v5 = React.useCallback(function(p2)
		return data.library.getItem(p2, data.itemId)
	end, { data.library, data.itemId })
	local v6 = SignalsReact.useSignalState(v5)

	if not data.isReady then
		v6 = nil
	end

	React.useEffect(function()
		local resourceActions = data.resourceActions

		if v6 == nil or not isActive then
			return
		end

		local chatResource = LibraryTypes.toChatResource(v6)
		local v7 = resourceActions.onAddResource(chatResource) == true
		return function()
			if v7 then
				resourceActions.onRemoveResource(chatResource)
			end
		end
	end, {
		v6 or false,
		data.resourceActions,
		data.library,
		isActive
	})

	React.useEffect(function()
		if v6 == nil or v6.model == nil or not isActive then
			return nil
		end

		local destroyingConnection = v6.model.Destroying:Connect(data.onBack)
		return function()
			destroyingConnection:Disconnect()
		end
	end, { v6 or false, data.onBack, isActive })
	local image

	if v6 == nil or v6.kind ~= "Image" then
		image = nil
	else
		image = v6.image
	end

	local state3, setState3 = React.useState(nil)
	local onImageLoaded = React.useCallback(function(p2)
		local v7

		if p2 ~= Enum.AssetFetchStatus.Success then
			v7 = image
		end

		setState3(v7)
	end, { image or false })
	local soundId

	if not (v6 == nil or v6.kind ~= "Sound") then
		soundId = v6.soundId
	end

	local liveModel = v6 ~= nil and v6.model ~= nil and {
		id = v6.id,
		displayName = v6.displayName,
		path = v6.path,
		className = v6.className,
		model = v6.model
	} or nil

	local status = data.isReady
		and (liveModel == nil and (v6 == nil or v6.kind ~= "Image" or v6.image == nil or v6.image == "") and (v6 == nil or v6.kind ~= "Sound" or soundId == nil or soundId == "") and "Failed" or "Ready")
		or "Loading"

	local v7 = {
		isActive = isActive,
		keyboardOverlap = keyboardOverlap,
		onPageMetricsChanged = onPageMetricsChanged,
		liveModel = liveModel,
		image = image,
		imageLoadFailed = image ~= nil and state3 == image,
		onImageLoaded = onImageLoaded,
		soundId = soundId,
		modelName = 0,
		description = 0,
		status = 0,
		unavailableText = 0,
		soundLabel = 0,
		chatActions = 0
	}
	local modelName

	if v6 ~= nil then
		modelName = v6.displayName
	end

	v7.modelName = modelName
	local description

	if v6 ~= nil then
		description = v6.description
	end

	v7.description = description
	v7.status = status
	v7.unavailableText = data.unavailableText
	v7.soundLabel = v4.soundLabel
	v7.chatActions = chatActions
	return v7
end

return useLibraryDetailViewModel
