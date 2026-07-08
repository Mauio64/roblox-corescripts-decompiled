local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local ParentParent = script.Parent.Parent
local BasePublishPrompt = require(ParentParent.BasePublishPrompt)
local ObjectViewport = require(ParentParent.Common.ObjectViewport)
local LabeledTextBox = require(ParentParent.Common.LabeledTextBox)
local PublishInfoList = require(ParentParent.Common.PublishInfoList)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics
local ParentParentParent = ParentParent.Parent
local Actions = ParentParentParent.Actions
local SetPromptVisibility = require(Actions.SetPromptVisibility)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(ParentParentParent.Constants)
local MakeupPreviewUtils = require(ParentParentParent.MakeupPreviewUtils)
local MakeupPartGrid = require(ParentParent.Common.MakeupPartGrid)
local GetFFlagSingleUploadMakeupSupport = require(ParentParentParent.Flags.GetFFlagSingleUploadMakeupSupport)
local uDim = UDim.new(0, 20)

local function PublishAvatarAssetPrompt(t1: {[any]: any}) -- line: 47
	-- upvalues: Players (copy), useSelector (copy), useDispatch (copy), Constants (copy), React (copy), GetFFlagSingleUploadMakeupSupport (copy), MakeupPreviewUtils (copy), PublishAssetAnalytics (copy), PurchasePrompt (copy), mutedError (copy), SetPromptVisibility (copy), RobloxTranslator (copy), uDim (copy), ObjectViewport (copy), LabeledTextBox (copy), PublishInfoList (copy), MakeupPartGrid (copy), BasePublishPrompt (copy)
	local LocalPlayer = Players.LocalPlayer

	assert(LocalPlayer, "LocalPlayer must not be nil")

	local v27 = useSelector(function(p1) -- line: 52
		return p1.promptRequest.promptInfo
	end)
	local v28 = useDispatch()
	local v29 = Constants.AvatarAssetTypeDefaultName[v27.accessoryType]
	local v30 = LocalPlayer.Name .. "'s " .. v29
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(v30)
	local v35, v36 = React.useState(true)
	local v37, v38 = React.useState(v30)
	local v39, v40 = React.useState(true)
	local v41, v42 = React.useState(false)
	local v43, v44 = React.useState(true)
	local v45 = not not GetFFlagSingleUploadMakeupSupport() and MakeupPreviewUtils.isMakeupAssetType(v27.accessoryType)
	local v46, v47 = React.useState(nil)

	React.useEffect(function() -- line: 77
		-- upvalues: v45 (copy), v27 (copy), MakeupPreviewUtils (copy), v47 (copy)
		if not v45 or not v27.accessoryInstance then
			return function() -- line: 79
			end
		end

		local v64 = MakeupPreviewUtils.createMakeupHeadPreview(v27.accessoryInstance, v27.accessoryType)

		v47(v64)

		return function() -- line: 86
			-- upvalues: v64 (copy)
			if v64 then
				v64:Destroy()
			end
		end
	end, {
		v27.accessoryInstance,
		v45,
		v27.accessoryType
	})

	local v48 = if not v45 then v27.accessoryInstance else v46
	local v49 = React.useRef(false)
	local v50 = React.useRef(false)
	local v51 = React.useRef(nil)
	local v52 = React.useRef(nil)
	local v53 = React.useCallback(function() -- line: 102
		-- upvalues: PublishAssetAnalytics (copy), v32 (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Expand)
		v32(true)
	end, {})
	local v54 = React.useCallback(function() -- line: 107
		-- upvalues: v32 (copy)
		v32(false)
	end, {})
	local v55 = React.useCallback(function() -- line: 111
		-- upvalues: v35 (copy), v39 (copy), v27 (copy), v43 (copy)
		return v35 and (v39 and (v27.accessoryInstance ~= nil and v43))
	end, {
		v35,
		v39,
		v27.accessoryInstance,
		v43
	})
	local v56 = React.useCallback(function() -- line: 116
		-- upvalues: PublishAssetAnalytics (copy), v33 (copy), v37 (copy), PurchasePrompt (copy), v27 (copy), v48 (copy), mutedError (copy)
		PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Buy)

		local t2 = {
			name = v33,
			description = v37
		}

		if PurchasePrompt.initiateAvatarCreationFeePurchase then
			PurchasePrompt.initiateAvatarCreationFeePurchase(t2, v27.guid, v48, v27.priceInRobux)

			return
		end

		mutedError("PurchasePrompt.initiateAvatarCreationFeePurchase is not available")
	end, {
		v33,
		v37,
		v27.guid,
		v27.accessoryInstance,
		v27.priceInRobux,
		v48
	})
	local v57 = React.useCallback(function(p2, p3) -- line: 138
		-- upvalues: v34 (copy), v36 (copy), v49 (copy), PublishAssetAnalytics (copy)
		v34(p2)
		v36(p3)

		if not v49.current then
			v49.current = true
			PublishAssetAnalytics.sendFieldTouched(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Name)
		end
	end, {})
	local v58 = React.useCallback(function(p4, p5) -- line: 148
		-- upvalues: v38 (copy), v40 (copy), v50 (copy), PublishAssetAnalytics (copy)
		v38(p4)
		v40(p5)

		if not v50.current then
			v50.current = true
			PublishAssetAnalytics.sendFieldTouched(PublishAssetAnalytics.Section.BuyCreationPage, PublishAssetAnalytics.Element.Description)
		end
	end, {})

	local function v59(p6) -- line: 158
		-- upvalues: v28 (copy), SetPromptVisibility (copy), v42 (copy), v44 (copy)
		local hasCompletedPurchase = p6.hasCompletedPurchase
		local isShown = p6.isShown

		if hasCompletedPurchase and not isShown then
			v28(SetPromptVisibility(false))

			return
		end

		v42(isShown)

		if isShown then
			v44(false)
		end
	end
	local function v60() -- line: 172
		-- upvalues: v44 (copy)
		v44(true)
	end

	React.useEffect(function() -- line: 177
		-- upvalues: PurchasePrompt (copy), v51 (copy), v59 (copy), v52 (copy), v60 (copy), mutedError (copy), PublishAssetAnalytics (copy)
		local windowStateChangedEvent = PurchasePrompt.windowStateChangedEvent
		local promptStateSetToNoneEvent = PurchasePrompt.promptStateSetToNoneEvent

		if windowStateChangedEvent and promptStateSetToNoneEvent then
			v51.current = windowStateChangedEvent:Connect(v59)
			v52.current = promptStateSetToNoneEvent:Connect(v60)
		else
			mutedError("PurchasePrompt.windowStateChangedEvent or PurchasePrompt.promptStateSetToNoneEvent is not available")
		end

		PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyCreationPage)

		return function() -- line: 191
			-- upvalues: v51 (copy), mutedError (copy), v52 (copy)
			if v51.current then
				v51.current:Disconnect()
				v51.current = nil
			else
				mutedError("windowStateChangedConnection was not established")
			end

			if v52.current then
				v52.current:Disconnect()
				v52.current = nil

				return
			end

			mutedError("promptStateSetToNoneConnection was not established")
		end
	end, {})

	local v61 = ((if not v45 then RobloxTranslator:FormatByKey("Feature.Avatar.Label.Accessory") else RobloxTranslator:FormatByKey("Feature.Catalog.Label.Makeup"))) .. " | " .. RobloxTranslator:FormatByKey(Constants.AvatarAssetTypeLocalized[v27.accessoryType])
	local v62 = React.useCallback(function() -- line: 215
		-- upvalues: v48 (copy), React (copy), uDim (copy), ObjectViewport (copy), v53 (copy), GetFFlagSingleUploadMakeupSupport (copy), v45 (copy), LabeledTextBox (copy), RobloxTranslator (copy), v37 (copy), v58 (copy), PublishInfoList (copy), v61 (copy), MakeupPartGrid (copy), v27 (copy), v33 (copy), t1 (copy)
		local v75 = v48 == nil

		return React.createElement(React.Fragment, nil, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = uDim,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = uDim,
				PaddingTop = uDim
			}),
			EmbeddedPreview = React.createElement(ObjectViewport, {
				fieldOfView = 30,
				LayoutOrder = 1,
				openPreviewView = v53,
				model = v48,
				isLoading = v75,
				useFullBodyCameraSettings = not GetFFlagSingleUploadMakeupSupport() or not v45
			}),
			DescriptionInput = React.createElement(LabeledTextBox, {
				LayoutOrder = 2,
				centerText = false,
				maxLength = 1000,
				textBoxHeight = 104,
				labelText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Description"),
				defaultText = v37,
				onTextUpdated = v58,
				invalidInputText = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.InvalidDescription")
			}),
			InfoList = React.createElement(PublishInfoList, {
				LayoutOrder = 3,
				typeName = v61
			}),
			MakeupGrid = v45 and React.createElement(MakeupPartGrid, {
				showAssetTypeInLabel = false,
				LayoutOrder = 4,
				singleDecal = v27.accessoryInstance,
				singleAssetType = v27.accessoryType,
				makeupEntries = {{
					sortOrder = 1,
					assetType = v27.accessoryType
				}},
				name = v33,
				screenSize = t1.screenSize
			}) or nil
		})
	end, {
		v48,
		v27.accessoryType,
		v37,
		if not v45 then nil else v33,
		v45,
		v61
	})

	return React.createElement(BasePublishPrompt, {
		delayInputSeconds = 3,
		promptBody = v62(),
		screenSize = t1.screenSize,
		showingPreviewView = v31,
		closePreviewView = v54,
		asset = v48,
		nameLabel = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.Name"),
		defaultName = v33,
		titleText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.BuyCreation"),
		onNameUpdated = v57,
		canSubmit = v55,
		onSubmit = v56,
		priceInRobux = v27.priceInRobux,
		showTopScrim = v41
	})
end

return PublishAvatarAssetPrompt
