local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Loggers = require(CorePackages.Workspace.Packages.Loggers)
local mutedError = Loggers.mutedError

local parent = script.Parent.Parent
local BasePublishPrompt = require(parent.BasePublishPrompt)
local ObjectViewport = require(parent.Common.ObjectViewport)
local LabeledTextBox = require(parent.Common.LabeledTextBox)
local PublishInfoList = require(parent.Common.PublishInfoList)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics

local parent2 = parent.Parent

local actions = parent2.Actions
local SetPromptVisibility = require(actions.SetPromptVisibility)

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = require(parent2.Constants)
local MakeupPreviewUtils = require(parent2.MakeupPreviewUtils)
local MakeupPartGrid = require(parent.Common.MakeupPartGrid)

local GetFFlagSingleUploadMakeupSupport = require(parent2.Flags.GetFFlagSingleUploadMakeupSupport)

local udim = UDim.new(0, 20)

local function PublishAvatarAssetPrompt(p)
	local localPlayer = Players.LocalPlayer
	assert(localPlayer, "LocalPlayer must not be nil")

	local v = useSelector(function(p2)
		return p2.promptRequest.promptInfo
	end)

	local v2 = useDispatch()

	local v3 = Constants.AvatarAssetTypeDefaultName[v.accessoryType]
	local v4 = localPlayer.Name .. "'s " .. v3

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(v4)
	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState(v4)
	local state5, setState5 = React.useState(true)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(true)
	local isMakeupPreview

	if GetFFlagSingleUploadMakeupSupport() then
		isMakeupPreview = MakeupPreviewUtils.isMakeupAssetType(v.accessoryType)
	else
		isMakeupPreview = false
	end

	local state8, setState8 = React.useState(nil)

	React.useEffect(function()
		if isMakeupPreview and v.accessoryInstance then
			local makeupHeadPreview = MakeupPreviewUtils.createMakeupHeadPreview(v.accessoryInstance, v.accessoryType)
			setState8(makeupHeadPreview)

			return function()
				if makeupHeadPreview then
					makeupHeadPreview:Destroy()
				end
			end
		end

		return function() end
	end, { v.accessoryInstance, isMakeupPreview, v.accessoryType })

	if not isMakeupPreview then
		state8 = v.accessoryInstance
	end

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local openPreviewView = React.useCallback(function()
		PublishAssetAnalytics.sendButtonClicked(
			PublishAssetAnalytics.Section.BuyCreationPage,
			PublishAssetAnalytics.Element.Expand
		)
		setState(true)
	end, {})

	local closePreviewView = React.useCallback(function()
		setState(false)
	end, {})

	local canSubmit = React.useCallback(function()
		local v5 = state3 and state5

		if v5 then
			return not (v.accessoryInstance == nil) and state7
		end

		return v5
	end, { state3, state5, v.accessoryInstance, state7 })

	local onSubmit = React.useCallback(function()
		PublishAssetAnalytics.sendButtonClicked(
			PublishAssetAnalytics.Section.BuyCreationPage,
			PublishAssetAnalytics.Element.Buy
		)

		local v5 = { name = state2, description = state4 }

		if PurchasePrompt.initiateAvatarCreationFeePurchase then
			PurchasePrompt.initiateAvatarCreationFeePurchase(v5, v.guid, state8, v.priceInRobux)
		else
			mutedError("PurchasePrompt.initiateAvatarCreationFeePurchase is not available")
		end
	end, { state2, state4, v.guid, v.accessoryInstance, v.priceInRobux, state8 })

	local onNameUpdated = React.useCallback(function(p2, p3)
		setState2(p2)
		setState3(p3)

		if not ref.current then
			ref.current = true
			PublishAssetAnalytics.sendFieldTouched(
				PublishAssetAnalytics.Section.BuyCreationPage,
				PublishAssetAnalytics.Element.Name
			)
		end
	end, {})

	local onTextUpdated = React.useCallback(function(p2, p3)
		setState4(p2)
		setState5(p3)

		if not ref2.current then
			ref2.current = true
			PublishAssetAnalytics.sendFieldTouched(
				PublishAssetAnalytics.Section.BuyCreationPage,
				PublishAssetAnalytics.Element.Description
			)
		end
	end, {})

	local function fn(p2)
		local hasCompletedPurchase = p2.hasCompletedPurchase
		local isShown = p2.isShown

		if hasCompletedPurchase and not isShown then
			v2(SetPromptVisibility(false))
			return
		end

		setState6(isShown)

		if isShown then
			setState7(false)
		end
	end

	local function fn2()
		setState7(true)
	end

	React.useEffect(function()
		local windowStateChangedEvent = PurchasePrompt.windowStateChangedEvent
		local promptStateSetToNoneEvent = PurchasePrompt.promptStateSetToNoneEvent

		if windowStateChangedEvent and promptStateSetToNoneEvent then
			ref3.current = windowStateChangedEvent:Connect(fn)
			ref4.current = promptStateSetToNoneEvent:Connect(fn2)
		else
			mutedError("PurchasePrompt.windowStateChangedEvent or PurchasePrompt.promptStateSetToNoneEvent is not available")
		end

		PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyCreationPage)

		return function()
			if ref3.current then
				ref3.current:Disconnect()
				ref3.current = nil
			else
				mutedError("windowStateChangedConnection was not established")
			end

			if not ref4.current then
				mutedError("promptStateSetToNoneConnection was not established")

				return
			end

			ref4.current:Disconnect()
			ref4.current = nil
		end
	end, {})
	local v5

	if isMakeupPreview then
		v5 = RobloxTranslator:FormatByKey("Feature.Catalog.Label.Makeup")
	else
		v5 = RobloxTranslator:FormatByKey("Feature.Avatar.Label.Accessory")
	end

	local typeName = v5 .. " | " .. RobloxTranslator:FormatByKey(Constants.AvatarAssetTypeLocalized[v.accessoryType])

	local useCallback = React.useCallback
	local function fn3()
		local isLoading = state8 == nil
		return React.createElement(React.Fragment, nil, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = udim,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = React.createElement("UIPadding", { PaddingBottom = udim, PaddingTop = udim }),
			EmbeddedPreview = React.createElement(ObjectViewport, {
				openPreviewView = openPreviewView,
				model = state8,
				isLoading = isLoading,
				useFullBodyCameraSettings = not GetFFlagSingleUploadMakeupSupport() or not isMakeupPreview,
				fieldOfView = 30,
				LayoutOrder = 1,
				isMakeupPreview = isMakeupPreview
			}),
			DescriptionInput = React.createElement(LabeledTextBox, {
				LayoutOrder = 2,
				labelText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
				centerText = false,
				defaultText = state4,
				maxLength = 1000,
				onTextUpdated = onTextUpdated,
				textBoxHeight = 104,
				invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
			}),
			InfoList = React.createElement(PublishInfoList, { typeName = typeName, LayoutOrder = 3 }),
			MakeupGrid = isMakeupPreview and React.createElement(MakeupPartGrid, {
				singleDecal = v.accessoryInstance,
				singleAssetType = v.accessoryType,
				makeupEntries = {
					{ assetType = v.accessoryType, sortOrder = 1 }
				},
				showAssetTypeInLabel = false,
				name = state2,
				LayoutOrder = 4,
				screenSize = p.screenSize
			}) or nil
		})
	end

	local accessoryType = v.accessoryType
	local v6

	if isMakeupPreview then
		v6 = state2
	end

	local v7 = useCallback(fn3, { state8, accessoryType, state4, v6, isMakeupPreview, typeName })

	return React.createElement(BasePublishPrompt, {
		promptBody = v7(),
		screenSize = p.screenSize,
		showingPreviewView = state,
		closePreviewView = closePreviewView,
		isMakeupPreview = isMakeupPreview,
		asset = state8,
		nameLabel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name"),
		defaultName = state2,
		titleText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BuyCreation"),
		onNameUpdated = onNameUpdated,
		canSubmit = canSubmit,
		onSubmit = onSubmit,
		delayInputSeconds = 3,
		priceInRobux = v.priceInRobux,
		showTopScrim = state6
	})
end

return PublishAvatarAssetPrompt
